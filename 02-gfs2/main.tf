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
    subnet_id  = yandex_vpc_subnet.otus-mgmt.id
    ip_address = "192.168.11.254"
    nat        = true
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
    host  = self.network_interface.0.nat_ip_address
  }
}

resource "yandex_compute_instance" "iscsi" {
  name                      = "iscsi-t"
  hostname                  = "iscsi-t"
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
  secondary_disk {
    disk_id     = yandex_compute_disk.iscsi-disk.id
    device_name = yandex_compute_disk.iscsi-disk.name
    auto_delete = false
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.otus-mgmt.id
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

resource "yandex_compute_disk" "iscsi-disk" {
  name = "isci-disk"
  size = 20
  type = "network-hdd"
}

resource "yandex_compute_instance" "gvfs2" {
  count                     = var.gvfs2_count
  name                      = "gvfs2-${count.index}"
  hostname                  = "gvfs2-${count.index}"
  service_account_id        = yandex_iam_service_account.sa_corosync.id
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
    next_hop_address   = "192.168.11.254"
  }
}

# Yandex.Cloud Service account for corosync fence
resource "yandex_iam_service_account" "sa_corosync" {
  name        = "otus-corosync"
  description = "service account for corosync fence"
}

resource "yandex_resourcemanager_folder_iam_member" "otus-compute-admin-corosync" {
  folder_id = var.folder_id
  role      = "compute.admin"
  member    = format("serviceAccount:%s", yandex_iam_service_account.sa_corosync.id)
}

resource "local_file" "ansible_inventory" {
  content = templatefile("templates/ansible-inventory.ini",
    {
      bastion   = yandex_compute_instance.bastion
      iscsi     = yandex_compute_instance.iscsi
      gvfs2     = yandex_compute_instance.gvfs2.*
      username  = var.username
      yc_folder = var.folder_id
    }
  )
  filename = "ansible/inventory.ini"
}

resource "null_resource" "ansible-install" {
  provisioner "local-exec" {
    command = "ANSIBLE_CONFIG=ansible/ansible.cfg ansible-playbook -i ${local_file.ansible_inventory.filename} ansible/playbook.yaml"
  }
}

# replace bastion ip in /etc/hosts and remove from ssh known_hosts
resource "null_resource" "hosts" {
  provisioner "local-exec" {
    command = "sudo sed -i '/${yandex_compute_instance.bastion.name}/ s/.*/${yandex_compute_instance.bastion.network_interface.0.nat_ip_address} ${yandex_compute_instance.bastion.name}/g' /etc/hosts; ssh-keygen -R ${yandex_compute_instance.bastion.name}"
  }
}

output "external_ip_address_bastion" {
  value       = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
  description = "External IP of ready bastion instance"
}
