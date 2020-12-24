## The diaspora* social network on Fedora CoreOS

This project provides a terraform module to provision a [diaspora*](https://diasporafoundation.org/) pod on
[Fedora CoreOS](https://getfedora.org/de/coreos?stream=stable).

## Description

A pod installation on CoreOS is special in two ways:

* All services are running as containers
* The machine is (usually a vm and) provisioned at first startup with an [ignition file](https://coreos.github.io/ignition/).
  Usually this includes service container installation with respective config files etc.
  
There are several ways to produce an ignition and one of them is [terraform](https://www.terraform.io/) with the
[poseidon/ct](https://registry.terraform.io/providers/poseidon/ct/latest) provider. This project makes use of this
provider to generate an ignition suitable for provisioning and installation of a complete Fedora CoreOS machine with
a diaspora* pod. It does also make use of the [fcos-ignition-snippets](https://github.com/ecky-l/fcos-ignition-snippets)
module to produce common ignition fragments, including special partition setup. The resulting machine has a small root
partition, which is large enough to hold two ostree deployments and the container metadata plus some configuration, and
a presumably large data partition for the diaspora data, that can survive a reprovisioning (as long as the partition
sizes are not changed). That means that the root partition can be recreated at any time without loosing the data - 
nevertheless it makes sense to pull backups of the data.

There are several ways to attach an ignition file to a new VM/image to boot and configure the image. One of them is PXE
boot boot. This is currently the only implemented method in this project and it requires a machine running a matchbox
service and a PXE boot environment. The project [fcos-pxe-bootstrapper](https://github.com/ecky-l/fcos-pxe-bootstrapper)
could help to provision a CoreOS VM with such a matchbox service. But it can be achieved by other means too, see the
[matchbox docs](https://matchbox.psdn.io/network-booting/). Mind that you need a private network for the PXE boot
environment, i.e. a VLAN that can be attached to a second NIC in a hosters VPC.  To get started, there is an example for
virtualbox in the examples directory and there is also a virtualbox example in fcos-pxe-bootstrapper, so you can try
everything out before actually going in production.

## Usage

The virtualbox example shows a terraform module which uses the fcos-diaspora module. You can edit the values as needed
(especially the url and the MAC address) and then run `terraform init`, `terraform plan` and `terraform apply` in the
examples/virtualbox directory. This actually needs the mentioned matchbox service setup to work and it will upload a
matchbox profile to the matchbox service, which is delivered when the host is switched on and requests network boot.

A real world deployment works the same but with different parameters. You must have a matchbox/PXE environment running
in your public hosting platform, but just for as long as the diaspora pod boots up via network. Then you write a module
that source's this project's module, i.e.

```
module "my_diaspora_pod" {
  source = "git::https://github.com/ecky-l/fcos-diaspora.git//modules/fcos-diaspora"
  ...
}
```

Like in the example but with real parameters. The ignition snippets are also necessary, at least for the core user
authorized keys. The terraform matchbox provider configuration (see examples/virtualbox/providers.tf) points to your
matchbox service. Then, a `terraform apply` will generate the profile in your real matchbox environment and the machine
can be started and will be ready within a few minutes.

## Data migration / restoration steps

This assumes that the diaspora pod is already running. It is not necessary to stop it, unless there is no data coming in.

* create a backup from old diaspora database on the old host
```
pg_dump diaspora_production -Ft -f diaspora_production.dump
```

* create a backup of uploads directory content on the old host
```
tar -C <path/to/diaspora/public/uploads> --preserve-permissions --same-owner -czf /tmp/diaspora_uploads.tar.gz images tmp users
```

* download both files and place them on the new host to
  * `/mnt/data/postgresql/backups/diaspora_production.dump`
  * `/mnt/data/diaspora/backups/diaspora_uploads.tar.gz`

* execute the database restore
```
sudo podman exec -it postgresql \
    pg_restore \
        -U diaspora \
        -h localhost \
        -d diaspora_production \
        -O -x -c --if-exists -Ft \
        /var/local/postgresql-backups/diaspora_production.dump 
```

* execute the uploads restore
```
tar -C /mnt/data/diaspora/public/uploads xvz -f /mnt/data/diaspora/backups/diaspora_uploads.tar.gz
```

* restart the diaspora-ct container to trigger database migration
```
sudo podman restart diaspora-ct
```