
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
  default = "latest"
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

variable "diaspora_admin_account" {
  type = string
  description = "The admin account"
  default = "podmin"
}

variable "diaspora_admin_email" {
  type = string
  description = "The admin email"
  default = "<>"
}

variable "diaspora_display_statistics" {
  type = bool
  description = "whether to display user/comment/post counts"
  default = true
}

variable "diaspora_enable_registrations" {
  type = bool
  default = true
}

variable "diaspora_autofollow_podmin" {
  type = bool
  default = true
}

variable "diaspora_enable_welcome_message" {
  type = bool
  default = true
}

variable "diaspora_remove_old_users" {
  type = bool
  default = true
}

variable "diaspora_terms_enable" {
  type = bool
  default = true
}

variable "diaspora_terms_jurisdication" {
  type = string
  default = "Germany"
}

variable "letsencrypt_email" {
  type = string
  description = "Email for letsencrypt mail notification"
}