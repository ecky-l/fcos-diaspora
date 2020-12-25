output "postgresql-password" {
  value = random_password.postgresql-password.result
}

output "diaspora_ignition" {
  value = data.ct_config.diaspora_ignition
}