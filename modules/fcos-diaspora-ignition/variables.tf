
variable "snippets" {
  type = list(string)
  description = "additional ignition snippets"
  default = []
}

variable "postgresql_version" {
  type = string
  description = "postgresql version"
  default = "10-alpine"
}

variable "redis_version" {
  type = string
  description = "redis version"
  default = "6.2"
}

variable "diaspora_version" {
  type = string
  description = "version of diaspora"
}

variable "nginx_version" {
  type = string
  description = "nginx version"
  default = "stable-alpine"
}

variable "diaspora_server_name" {
  type = string
  description = "The diaspora pod url"
}

variable "letsencrypt_email" {
  type = string
  description = "Email for letsencrypt mail notification"
}