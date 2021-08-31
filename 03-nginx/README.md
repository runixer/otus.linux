## Description

This terraform module creates:
* 1 bastion instance (used as ssh jumphost and gateway with NAT)
* 1 mysql database instance (db-0)
* Specified number of app instances with wordpress and php_fpm role
* Specified number of nginx instances with wordpress and nginx role
* 1 Yandex Cloud load balancer targeting nginx instances

Features:
* No TLS at this time
* Tested using CentOS 8 Stream image only
* All available operating system updates are installed
* Backups wordpress database on destroy and restores on provision

Notes:
* Please use ssh agent forwading when connecting to bastion
* Please use http://otus.internal to connect to website
* Credentials for http://otus.internal/wp-admin/ are:
  * Username: otus
  * Password: vyf2uxnnZhWfjeX4ty

<!-- BEGIN_TF_DOCS -->
## Requirements

Some ansible collections:
```sh
ansible-galaxy collection install community.mysql
ansible-galaxy collection install ansible.posix
ansible-galaxy collection install community.crypto
```

## Providers

The following providers are used by this module:

- <a name="provider_local"></a> [local](#provider\_local) (2.1.0)

- <a name="provider_yandex"></a> [yandex](#provider\_yandex) (0.61.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [local_file.ansible_inventory](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) (resource)
- [yandex_compute_instance.app](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance) (resource)
- [yandex_compute_instance.bastion](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance) (resource)
- [yandex_compute_instance.db](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance) (resource)
- [yandex_compute_instance.nginx](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance) (resource)
- [yandex_lb_network_load_balancer.lb](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lb_network_load_balancer) (resource)
- [yandex_lb_target_group.lb-tg](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lb_target_group) (resource)
- [yandex_vpc_network.otus-network](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_network) (resource)
- [yandex_vpc_route_table.route-public](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_route_table) (resource)
- [yandex_vpc_subnet.otus-internal](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet) (resource)
- [yandex_vpc_subnet.otus-public](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_cloud_id"></a> [cloud\_id](#input\_cloud\_id)

Description: The ID of the yandex cloud

Type: `string`

### <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id)

Description: The ID of the folder in the yandex cloud to operate under

Type: `string`

### <a name="input_ssh_pubkey"></a> [ssh\_pubkey](#input\_ssh\_pubkey)

Description: SSH public key

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_app_count"></a> [app\_count](#input\_app\_count)

Description: Count of app node instances

Type: `number`

Default: `2`

### <a name="input_image_id"></a> [image\_id](#input\_image\_id)

Description: The ID of the existing disk, default is CentOS 8 Stream

Type: `string`

Default: `"fd8hnbln4tn9k0823esa"`

### <a name="input_nginx_count"></a> [nginx\_count](#input\_nginx\_count)

Description: Count of nginx node instances

Type: `number`

Default: `2`

### <a name="input_username"></a> [username](#input\_username)

Description: Username to use for ssh

Type: `string`

Default: `"otus"`

### <a name="input_yc_service_account_key_file"></a> [yc\_service\_account\_key\_file](#input\_yc\_service\_account\_key\_file)

Description: (Optional) Contains either a path to or the contents of the Service Account file in JSON format

Type: `string`

Default: `null`

### <a name="input_yc_token"></a> [yc\_token](#input\_yc\_token)

Description: (Optional) Security token or IAM token used for authentication in Yandex.Cloud

Type: `string`

Default: `null`

### <a name="input_zone"></a> [zone](#input\_zone)

Description: Yandex.Cloud availability zone

Type: `string`

Default: `"ru-central1-a"`

## Outputs

The following outputs are exported:

### <a name="output_external_ip_address_bastion"></a> [external\_ip\_address\_bastion](#output\_external\_ip\_address\_bastion)

Description: External IP of ready bastion instance

### <a name="output_external_ip_address_lb"></a> [external\_ip\_address\_lb](#output\_external\_ip\_address\_lb)

Description: External IP of ready load balancer
<!-- END_TF_DOCS -->