<!-- BEGIN_TF_DOCS -->
## Description

This terraform module creates:
* 1 bastion instance (used as ssh jumphost and gateway with NAT)
* 1 iscsi instance with a mounted disk and iscsi-target role
* Specified number of gvfs2 instances with isci-initiator, corosync and gvfs2 roles

Features:
* The corosync role implements fencing for Yandex Cloud
* Tested using CentOS 8 Stream image only
* All available operating system updates are installed

Notes:
* Please use ssh agent forwading when connecting to bastion

## Providers

The following providers are used by this module:

- <a name="provider_yandex"></a> [yandex](#provider\_yandex) (0.61.0)

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

### <a name="input_gvfs2_count"></a> [gvfs2\_count](#input\_gvfs2\_count)

Description: Count of gvfs2 client instances

Type: `number`

Default: `3`

### <a name="input_image_id"></a> [image\_id](#input\_image\_id)

Description: The ID of the existing disk, default is CentOS 8 Stream

Type: `string`

Default: `"fd8hnbln4tn9k0823esa"`

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
<!-- END_TF_DOCS -->