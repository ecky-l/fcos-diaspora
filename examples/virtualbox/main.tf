
module "vb_snippets" {
  source = "git::https://github.com/ecky-l/fcos-ignition-snippets.git//modules/ignition-snippets"

  user_authorized_keys = {
    diaspora = [
      file("~/.ssh/id_rsa.pub")
    ]
  }

  networks = {
    diaspora = {
      enp0s3 = {
        ipv4 = {
          "method" = "manual"
          "address1" = "10.10.0.10/16,10.10.0.1"
          "dns" = "10.10.0.1;"
          "dns-search" = "local.vlan;"
          "never-default" = "true"
        }
      }
      enp0s8 = {
        ipv4 = {
          "method" = "manual"
          "address1" = "192.168.56.20/24"
          "never-default" = "true"
        }
      }
      enp0s9 = {
        "ipv4" = {
          "method" = "auto"
          "ignore-auto-dns" = "true"
        }
      }
    }
  }

  root_partition_size_gib = {
    diaspora = 24
  }
}