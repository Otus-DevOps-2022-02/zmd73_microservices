terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.73.0"
    }
  }
}

data "yandex_compute_image" "docker_image" {
  folder_id = var.docker_disk_folder
  family = var.docker_disk_image
}

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

module "vpc" {
  source           = "../modules/vpc"
  zone = var.zone
}

module "docker" {
  count_vm = 2
  source           = "../modules/docker"
  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path
  docker_disk_image   = data.yandex_compute_image.docker_image.id
  subnet_id        = module.vpc.subnet_id
}
