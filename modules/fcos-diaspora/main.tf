locals {
  cached_kernel = "${var.matchbox_http_endpoint}/assets/fedora-coreos/fedora-coreos-${var.os_version}-live-kernel-x86_64"
  cached_initrd = "${var.matchbox_http_endpoint}/assets/fedora-coreos/fedora-coreos-${var.os_version}-live-initramfs.x86_64.img"
  cached_rootfs = "${var.matchbox_http_endpoint}/assets/fedora-coreos/fedora-coreos-${var.os_version}-live-rootfs.x86_64.img"

  boot_args = [
    "ip=dhcp",
    "rd.neednet=1",
    "console=tty0",
    "console=ttyS0",
    "coreos.inst.install_dev=${var.install_disk}",
    #"coreos.inst.stream=${var.os_stream}",
    # for the next line to work, the .raw.xz must be downloaded to the appropriate place.
    # !!! AND the .raw.xz.sig file must be downloaded from the same location and placed next to the .raw.xz file !!!
    # If the .sig file is not present, there will be a hang-screen during PXE boot and no message why.
    "coreos.inst.image_url=${var.matchbox_http_endpoint}/assets/fedora-coreos/fedora-coreos-${var.os_version}-metal.x86_64.raw.xz",
    "coreos.inst.ignition_url=${var.matchbox_http_endpoint}/ignition?uuid=$${uuid}&mac=$${mac:hexhyp}",
  ]

  kernel = local.cached_kernel
  initramfs = local.cached_initrd
  initrootfs = local.cached_rootfs
  args   = local.boot_args
}

data "ct_config" "diaspora_ignition" {
  strict = true
  pretty_print = false

  content = file("${path.module}/templates/main.yaml")

  snippets = concat(
          var.snippets,
  [
    templatefile("${path.module}/templates/diaspora-config.yaml", {
      postgres_password = var.postgres_password
      diaspora_server_name = var.diaspora_server_name
    }),
    templatefile("${path.module}/templates/nginx-config.yaml", {
      diaspora_server_name = var.diaspora_server_name
    }),
    templatefile("${path.module}/templates/letsencrypt.yaml", {
      diaspora_server_name = var.diaspora_server_name
      letsencrypt_email = var.letsencrypt_email
    }),
    templatefile("${path.module}/templates/diaspora-pod.yaml", {
      postgres_password = var.postgres_password
    })
  ]
  )
}

resource "matchbox_profile" "diaspora" {
  name  = "diaspora"

  kernel = local.kernel
  initrd = [
    local.initramfs,
    local.initrootfs
  ]
  args = concat(local.args, var.kernel_args)

  raw_ignition = data.ct_config.diaspora_ignition.rendered
}

resource "matchbox_group" "diaspora" {
  name = "diaspora"
  profile = matchbox_profile.diaspora.name
  selector = {
    mac = var.mac_address
  }
}