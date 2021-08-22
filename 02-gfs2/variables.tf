variable "cloud_id" {
  type = string
  description = "The ID of the yandex cloud"
}

variable "folder_id" {
  type = string
  description = "The ID of the folder in the yandex cloud to operate under"
}

variable "yc_token" {
  type = string
  description = "Security token or IAM token used for authentication in Yandex.Cloud"
}

variable "zone" {
  type = string
  default = "ru-central1-a"
  description = "Yandex.Cloud availability zone"
}

variable "gvfs2_count" {
  type = number
  default = 3
  description = "Count of gvfs2 client instances"
}

variable "username" {
  type = string
  default = "otus"
  description = "Username to use for ssh"
}

variable "ssh_pubkey" {
  type = string
  description = "SSH public key"
}

variable "image_id" {
  type = string
  default = "fd8hnbln4tn9k0823esa"  # centos-stream-8-v20210818
  description = "The ID of the existing disk, default is CentOS 8 Stream"
}