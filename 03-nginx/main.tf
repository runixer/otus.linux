terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
  service_account_key_file = var.yc_service_account_key_file
  token                    = var.yc_token
}

resource "yandex_compute_instance" "bastion" {
  name                      = "bastion"
  hostname                  = "bastion"
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
      image_id = "fd8drj7lsj7btotd7et5" # Yandex NAT Instance (nat-instance-ubuntu-1612818947)
    }
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.otus-internal.id
    ip_address = "192.168.11.254"
    nat        = true
  }
  metadata = {
    # https://cloud.yandex.ru/docs/compute/concepts/vm-metadata
    user-data = templatefile("templates/cloud-config.yaml", {
      username = "otus",
      ssh-key  = var.ssh_pubkey
    })
  }
  connection {
    type  = "ssh"
    user  = "otus"
    agent = true
    host  = self.network_interface.0.nat_ip_address
  }

  # test ssh connection
  provisioner "remote-exec" {
    inline = ["echo 'Im ready!'"]
  }

  # add bastion ip to /etc/hosts
  provisioner "local-exec" {
    command = "sudo sed -i '2i${self.network_interface.0.nat_ip_address} ${self.name}' /etc/hosts"
  }

  # remove bastion ip from /etc/hosts
  provisioner "local-exec" {
    when    = destroy
    command = "sudo sed -i '/${self.network_interface.0.nat_ip_address} ${self.name}/d' /etc/hosts"
  }

}

resource "yandex_compute_instance" "db" {
  name                      = "db-0"
  hostname                  = "db-0"
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
    subnet_id = yandex_vpc_subnet.otus-internal.id
    nat       = false
  }
  metadata = {
    # https://cloud.yandex.ru/docs/compute/concepts/vm-metadata
    user-data = templatefile("templates/cloud-config.yaml", {
      username = var.username,
      ssh-key  = var.ssh_pubkey
    })
  }
  connection {
    type  = "ssh"
    user  = var.username
    agent = true
    host  = self.network_interface.0.ip_address
    # Since there is no public ip, connecting through bastion host
    bastion_host = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
  }
  provisioner "remote-exec" {
    inline = ["echo 'Im ready!'"]
  }
}

resource "yandex_compute_instance" "app" {
  count                     = var.app_count
  name                      = "app-${count.index}"
  hostname                  = "app-${count.index}"
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
    subnet_id = yandex_vpc_subnet.otus-internal.id
    nat       = false
  }
  metadata = {
    # https://cloud.yandex.ru/docs/compute/concepts/vm-metadata
    user-data = templatefile("templates/cloud-config.yaml", {
      username = var.username,
      ssh-key  = var.ssh_pubkey
    })
  }
  connection {
    type  = "ssh"
    user  = var.username
    agent = true
    host  = self.network_interface.0.ip_address
    # Since there is no public ip, connecting through bastion host
    bastion_host = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
  }
  provisioner "remote-exec" {
    inline = ["echo 'Im ready!'"]
  }
}

resource "yandex_compute_instance" "nginx" {
  count                     = var.nginx_count
  name                      = "nginx-${count.index}"
  hostname                  = "nginx-${count.index}"
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
    subnet_id = yandex_vpc_subnet.otus-internal.id
    nat       = false
  }
  metadata = {
    # https://cloud.yandex.ru/docs/compute/concepts/vm-metadata
    user-data = templatefile("templates/cloud-config.yaml", {
      username = var.username,
      ssh-key  = var.ssh_pubkey
    })
  }
  connection {
    type  = "ssh"
    user  = var.username
    agent = true
    host  = self.network_interface.0.ip_address
    # Since there is no public ip, connecting through bastion host
    bastion_host = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
  }
  provisioner "remote-exec" {
    inline = ["echo 'Im ready!'"]
  }
}

resource "yandex_vpc_network" "otus-network" {
  name = "otus-network"
}

resource "yandex_vpc_subnet" "otus-public" {
  name           = "otus-public"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.otus-network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "otus-internal" {
  name           = "otus-internal"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.otus-network.id
  v4_cidr_blocks = ["192.168.11.0/24"]
  route_table_id = yandex_vpc_route_table.route-public.id
}

resource "yandex_vpc_route_table" "route-public" {
  network_id = yandex_vpc_network.otus-network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.11.254"
  }
}

resource "yandex_lb_target_group" "lb-tg" {
  name = "lb-tg"

  dynamic "target" {
    for_each = yandex_compute_instance.nginx
    content {
      subnet_id = yandex_vpc_subnet.otus-internal.id
      address   = target.value.network_interface.0.ip_address
    }
  }
}

resource "yandex_lb_network_load_balancer" "lb" {
  name = "lb1"

  listener {
    name = "my-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.lb-tg.id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/health"
      }
    }
  }

  # add otus.internal ip to /etc/hosts
  provisioner "local-exec" {
    command = "sudo sed -i '3i${tolist(tolist(self.listener)[0].external_address_spec)[0].address} otus.internal' /etc/hosts"
  }

  # remove otus.internal ip from /etc/hosts
  provisioner "local-exec" {
    when    = destroy
    command = "sudo sed -i '/${tolist(tolist(self.listener)[0].external_address_spec)[0].address} otus.internal/d' /etc/hosts"
  }
}

resource "local_file" "ansible_inventory" {
  content = templatefile("templates/ansible-inventory.ini",
    {
      bastion     = yandex_compute_instance.bastion
      db          = yandex_compute_instance.db
      app         = yandex_compute_instance.app.*
      nginx       = yandex_compute_instance.nginx.*
      username    = var.username
      yc_folder   = var.folder_id
      external_ip = tolist(tolist(yandex_lb_network_load_balancer.lb.listener)[0].external_address_spec)[0].address
    }
  )
  filename = "ansible/inventory.ini"

  provisioner "local-exec" {
    working_dir = "ansible/"
    command     = "ansible-playbook playbook.yaml"
  }

  # Backup database on destroy
  provisioner "local-exec" {
    when        = destroy
    working_dir = "ansible/"
    command     = "ansible-playbook playbook-backup.yaml"
  }
}

output "external_ip_address_bastion" {
  value       = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
  description = "External IP of ready bastion instance"
}

output "external_ip_address_lb" {
  value       = tolist(tolist(yandex_lb_network_load_balancer.lb.listener)[0].external_address_spec)[0].address
  description = "External IP of ready load balancer"
}
