locals {
  postgresql_ip = "10.88.0.5"
  redis_ip = "10.88.0.6"
  diaspora_ip = "10.88.0.7"
  nginx_ip = "10.88.0.8"
  smtpd_ip = "10.88.0.9"
}

resource "random_password" "postgresql-password" {
  length = 24
  special = false
}

data "ct_config" "diaspora_ignition" {
  strict = true
  pretty_print = false

  content = file("${path.module}/templates/main.yaml")

  snippets = concat(
          var.snippets,
  [
    templatefile("${path.module}/templates/diaspora-config.yaml", {
      postgres_password = random_password.postgresql-password.result
      diaspora_server_name = var.diaspora_server_name
      postgresql_ip = local.postgresql_ip
      redis_ip = local.redis_ip
      smtpd_ip = local.smtpd_ip
    }),
    templatefile("${path.module}/templates/nginx-config.yaml", {
      diaspora_server_name = var.diaspora_server_name
      diaspora_ip = local.diaspora_ip
    }),
    templatefile("${path.module}/templates/letsencrypt.yaml", {
      diaspora_server_name = var.diaspora_server_name
      letsencrypt_email = var.letsencrypt_email
    }),
    templatefile("${path.module}/templates/diaspora-services.yaml", {
      postgres_password = random_password.postgresql-password.result
      diaspora_server_name = var.diaspora_server_name
      postgresql_ip = local.postgresql_ip
      redis_ip = local.redis_ip
      diaspora_ip = local.diaspora_ip
      nginx_ip = local.nginx_ip
      smtpd_ip = local.smtpd_ip
    })
  ]
  )
}

