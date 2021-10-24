variable "cloud_id" {
  type        = string
  description = "The ID of the yandex cloud"
}

variable "folder_id" {
  type        = string
  description = "The ID of the folder in the yandex cloud to operate under"
}

variable "yc_token" {
  type        = string
  default     = null
  description = "(Optional) Security token or IAM token used for authentication in Yandex.Cloud"
}

variable "yc_service_account_key_file" {
  type        = string
  default     = null
  description = "(Optional) Contains either a path to or the contents of the Service Account file in JSON format"
}

variable "zone" {
  type        = string
  default     = "ru-central1-a"
  description = "Yandex.Cloud availability zone"
}

variable "nginx_count" {
  type        = number
  default     = 2
  description = "Count of nginx node instances"
}

variable "app_count" {
  type        = number
  default     = 2
  description = "Count of app node instances"
}

variable "db_count" {
  type        = number
  default     = 3
  description = "Count of database instances"
}

variable "log_count" {
  type        = number
  default     = 3
  description = "Count of log instances"
}

variable "username" {
  type        = string
  default     = "otus"
  description = "Username to use for ssh"
}

variable "ssh_pubkey" {
  type        = string
  description = "SSH public key"
}

variable "image_id" {
  type        = string
  # yc compute image list --folder-id standard-images | grep -i centos-stream-8
  # centos-stream-8-v20210908
  default     = "fd8t1sokqbcid8mj5elf"
  description = "The ID of the existing disk, default is CentOS 8 Stream"
}
