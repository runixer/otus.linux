terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
  token     = var.yc_token
}

resource "yandex_compute_instance" "nginx" {
  name = "nginx"
  allow_stopping_for_update = true
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 100
  }
  scheduling_policy {
    preemptible = true
  }
  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }
  metadata = {
    ssh-keys = "${var.username}:${file("~/.ssh/id_ed25519.pub")}"
  }

  connection {
    type  = "ssh"
    user  = var.username
    agent = true
    host  = self.network_interface.0.nat_ip_address
  }

  provisioner "remote-exec" {
    inline = ["echo 'Im ready!'"]
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u ${var.username} -i '${self.network_interface.0.nat_ip_address},' provision.yml"
  }

}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

output "external_url_address_nginx" {
  value = format("http://%s", yandex_compute_instance.nginx.network_interface.0.nat_ip_address)
  description = "External URL of ready nginx instance"
}
