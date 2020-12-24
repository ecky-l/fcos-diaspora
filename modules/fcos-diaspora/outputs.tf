output "postgresql-password" {
  value = random_password.postgresql-password.result
}