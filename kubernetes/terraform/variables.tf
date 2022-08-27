variable "cloud_id" {
  description = "Cloud"
}
variable "folder_id" {
  description = "Folder"
}
variable "zone" {
  description = "Zone"
  default     = "ru-central1-a"
}
variable "public_key_path" {
  description = "Path to the public key used for ssh access"
}
variable "disk_image" {
  description = "Disk image"
  default     = "ubuntu-1804-lts"
}
variable "service_account_key_file" {
  description = "key_tf.json"
}
variable "count_of_masters" {
  description = "Count of master nodes"
  default     = 1
}
variable "count_of_workers" {
  description = "Count of worker nodes"
  default     = 1
}
variable "cores" {
  description = "Core number for instance"
  default     = 4
}
variable "memory" {
  description = "Memory GB for instance"
  default     = 4
}
variable "disk_size" {
  description = "OS disk size"
  default     = 40
}
