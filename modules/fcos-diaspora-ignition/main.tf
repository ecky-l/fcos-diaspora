locals {
  postgresql_ip = "10.88.0.5"
  redis_ip = "10.88.0.6"
  diaspora_ip = "10.88.0.7"
  nginx_ip = "10.88.0.8"
  smtpd_ip = "10.88.0.1"
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
    templatefile("${path.module}/templates/config-diaspora.yaml", {
      postgres_password = random_password.postgresql-password.result
      diaspora_server_name = var.diaspora_server_name
      admin_account = var.diaspora_admin_account
      admin_email = var.diaspora_admin_email == "<>" ? "${var.diaspora_admin_account}@${var.diaspora_server_name}" : var.diaspora_admin_email
      display_statistics = var.diaspora_display_statistics
      enable_registrations = var.diaspora_enable_registrations
      autofollow_podmin = var.diaspora_autofollow_podmin
      enable_welcome_message = var.diaspora_enable_welcome_message
      remove_old_users = var.diaspora_remove_old_users
      terms_enable = var.diaspora_terms_enable
      terms_jurisdication = var.diaspora_terms_jurisdication
      postgresql_ip = local.postgresql_ip
      redis_ip = local.redis_ip
      smtpd_ip = local.smtpd_ip
    }),
    templatefile("${path.module}/templates/config-exim4.yaml", {
      exim4_smtp_iface = var.exim4_smtp_iface
    }),
    templatefile("${path.module}/templates/config-nginx.yaml", {
      diaspora_server_name = var.diaspora_server_name
      diaspora_ip = local.diaspora_ip
    }),
    templatefile("${path.module}/templates/letsencrypt.yaml", {
      diaspora_server_name = var.diaspora_server_name
      letsencrypt_email = var.letsencrypt_email
    }),
    templatefile("${path.module}/templates/diaspora-services.yaml", {
      postgres_password = random_password.postgresql-password.result
      postgresql_version = var.postgresql_version
      redis_version = var.redis_version
      diaspora_version = var.diaspora_version
      nginx_version = var.nginx_version
      diaspora_server_name = var.diaspora_server_name
      postgresql_ip = local.postgresql_ip
      redis_ip = local.redis_ip
      diaspora_ip = local.diaspora_ip
      nginx_ip = local.nginx_ip
    })
  ]
  )
}

