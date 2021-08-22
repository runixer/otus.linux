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

resource "yandex_compute_instance" "bastion" {
  name = "bastion"
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
      image_id = "fd8drj7lsj7btotd7et5" # Yandex NAT Instance (Ubuntu)
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.otus-public.id
    nat       = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.otus-mgmt.id
    ip_address = "192.168.11.254"
    nat       = false
  }
  metadata = {
    # https://cloud.yandex.ru/docs/compute/concepts/vm-metadata
    user-data = templatefile("templates/cloud-config.yaml", {
      username=var.username,
      ssh-key=file("~/.ssh/id_ed25519.pub"),
      hostname="bastion"
    })
  }
  connection {
    type  = "ssh"
    user  = var.username
    agent = true
    host  = self.network_interface.0.nat_ip_address
  }
  # TODO: Some hack to enable second interface
  provisioner "remote-exec" {
    inline = [
      "sudo ip li set dev eth1 up",
      "sudo ip addr add dev eth1 192.168.11.254/24"
    ]
  }
}

resource "yandex_compute_instance" "iscsi" {
  count = 1
  name = "iscsi-${count.index}"
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
    subnet_id = yandex_vpc_subnet.otus-mgmt.id
    nat       = false
  }
  metadata = {
    # https://cloud.yandex.ru/docs/compute/concepts/vm-metadata
    user-data = templatefile("templates/cloud-config.yaml", {
      username=var.username,
      ssh-key=file("~/.ssh/id_ed25519.pub"),
      hostname="iscsi-${count.index}"
    })
  }
  connection {
    type  = "ssh"
    user  = var.username
    agent = true
    host  = self.network_interface.0.ip_address
    bastion_host = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
  }
  provisioner "remote-exec" {
    inline = ["echo 'Im ready!'"]
  }
}

resource "yandex_compute_instance" "gvfs2" {
  count = 1
  name = "gvfs2-${count.index}"
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
    subnet_id = yandex_vpc_subnet.otus-mgmt.id
    nat       = false
  }
  metadata = {
    # https://cloud.yandex.ru/docs/compute/concepts/vm-metadata
    user-data = templatefile("templates/cloud-config.yaml", {
      username=var.username,
      ssh-key=file("~/.ssh/id_ed25519.pub"),
      hostname="gvfs2-${count.index}"
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

resource "yandex_vpc_subnet" "otus-mgmt" {
  name           = "otus-mgmt"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.otus-network.id
  v4_cidr_blocks = ["192.168.11.0/24"]
  route_table_id = yandex_vpc_route_table.route-public.id
}

resource "yandex_vpc_route_table" "route-public" {
  network_id = yandex_vpc_network.otus-network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.1.254"
  }
}

resource "local_file" "ansible_inventory" {
  content = templatefile("templates/ansible-inventory.ini",
    {
      bastion_ip = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
      bastion_name = yandex_compute_instance.bastion.name
      iscsi = yandex_compute_instance.iscsi.*
      gvfs2 = yandex_compute_instance.gvfs2.*
      username = var.username
    }
  )
  filename = "ansible/inventory.ini"
}

resource "null_resource" "ansible-install" {
  provisioner "local-exec" {
    command = "ANSIBLE_CONFIG=ansible/ansible.cfg ansible -i ${local_file.ansible_inventory.filename} all -m ping"
  }
}

output "external_ip_address_bastion" {
  value = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
  description = "External IP of ready iscsi instance"
}