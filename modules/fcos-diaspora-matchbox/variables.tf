variable "matchbox_http_endpoint" {
  type        = string
  description = "Matchbox HTTP read-only endpoint (e.g. http://matchbox.example.com:8080)"
}

variable "os_stream" {
  type        = string
  description = "Fedora CoreOS release stream (e.g. testing, stable)"
  default     = "stable"
}

variable "os_version" {
  type        = string
  description = "Fedora CoreOS version to PXE and install (e.g. 31.20200310.3.0)"
  default = "33.20210426.3.0"
}

variable "install_disk" {
  type        = string
  description = "Disk device to install Fedora CoreOS (e.g. /dev/sda)"
  default     = "/dev/sda"
}

variable "kernel_args" {
  type        = list(string)
  description = "Additional kernel arguments to provide at PXE boot."
  default     = []
}

variable "mac_address" {
  type = string
  description = "MAC address of the node for matchbox selection"
}

variable "diaspora_ignition" {
  type = string
  description = "The ignition to upload"
}