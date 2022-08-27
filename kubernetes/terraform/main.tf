terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.73.0"
    }
  }
}

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

data "yandex_compute_image" "image" {
  folder_id = "standard-images"
  family    = var.disk_image
}

resource "yandex_vpc_network" "kube-network" {
  name = "gitlab-network"
}

resource "yandex_vpc_subnet" "kube-subnet" {
  name           = "kube-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.kube-network.id
  v4_cidr_blocks = ["10.244.0.0/16"]
}

resource "yandex_compute_instance" "k8s_master" {
  name                      = "k8s-master-${count.index}"
  hostname                  = "k8s-master-${count.index}"
  count                     = var.count_of_masters
  allow_stopping_for_update = true

  resources {
    cores  = var.cores
    memory = var.memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image.id
      size     = var.disk_size
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.kube-subnet.id
    nat       = true
  }

  metadata = {
    role = "master"
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

}

resource "yandex_compute_instance" "k8s_worker" {
  name                      = "k8s-worker-${count.index}"
  hostname                  = "k8s-worker-${count.index}"
  count                     = var.count_of_workers
  allow_stopping_for_update = true

  resources {
    cores  = var.cores
    memory = var.memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image.id
      size     = var.disk_size
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.kube-subnet.id
    nat       = true
  }

  metadata = {
    role = "worker"
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

}
