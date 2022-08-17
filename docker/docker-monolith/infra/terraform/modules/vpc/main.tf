terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.73.0"
    }
  }
}

resource "yandex_vpc_network" "docker-network" {
  name = "docker-network"
}

resource "yandex_vpc_subnet" "docker-subnet" {
  name           = "docker-subnet"
  zone           = var.zone
  network_id     = "${yandex_vpc_network.docker-network.id}"
  v4_cidr_blocks = ["192.168.10.0/24"]
}
