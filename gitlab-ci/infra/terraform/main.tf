terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.73.0"
    }
  }
}

data "yandex_compute_image" "gitlab_image" {
  folder_id = "standard-images"
  family = var.gitlab_disk_image
}

resource "yandex_vpc_network" "gitlab-network" {
  name = "gitlab-network"
}

resource "yandex_vpc_subnet" "gitlab-subnet" {
  name           = "gitlab-subnet"
  zone           = var.zone
  network_id     = "${yandex_vpc_network.gitlab-network.id}"
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_compute_instance" "gitlab" {
  name     = "gitlab-ci"
  hostname = "gitlab-ci"

  resources {
    cores  = 2
    memory = 6
  }

  boot_disk {
    initialize_params {
      size     = 50
      image_id = data.yandex_compute_image.gitlab_image.id
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.gitlab-subnet.id}"
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
}
