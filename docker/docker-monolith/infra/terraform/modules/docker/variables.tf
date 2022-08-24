variable "public_key_path" {
  description = "Path to the public key used for ssh access"
}
variable "private_key_path" {
  description = "Path to private key used for provisioner"
}
variable "docker_disk_image" {
  description = "Disk image for docker"
  default     = "Ubuntu-18.04"
}
variable "subnet_id" {
  description = "Subnet"
}
variable "count_vm" {
  description = "Count of instances"
  default = 1
}
