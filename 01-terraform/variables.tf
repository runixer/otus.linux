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

variable "image_id" {
  type = string
  default = "fd8vmcue7aajpmeo39kk"
  description = "The ID of the existing disk, default is Ubuntu 20.04"
}

variable "username" {
  type = string
  default = "ubuntu"
  description = "Username to use for ssh"
}