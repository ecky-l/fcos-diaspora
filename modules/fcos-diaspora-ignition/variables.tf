
variable "snippets" {
  type = list(string)
  description = "additional ignition snippets"
  default = []
}


variable "diaspora_server_name" {
  type = string
  description = "The diaspora pod url"
}

variable "letsencrypt_email" {
  type = string
  description = "Email for letsencrypt mail notification"
}