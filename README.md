[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
# Linode Instance and Database Module

Terraform module  which creates instance(s) and database instance or cluster,
Optional can put instances behind a load balancer.

[![SWUbanner](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner2-direct.svg)](https://github.com/vshymanskyy/StandWithUkraine/blob/main/docs/README.md)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_linode"></a> [linode](#requirement\_linode) | >= 1.28 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_linode"></a> [linode](#provider\_linode) | 1.28.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.3.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [linode_database_mysql.this](https://registry.terraform.io/providers/linode/linode/latest/docs/resources/database_mysql) | resource |
| [linode_instance.this](https://registry.terraform.io/providers/linode/linode/latest/docs/resources/instance) | resource |
| [linode_nodebalancer.this](https://registry.terraform.io/providers/linode/linode/latest/docs/resources/nodebalancer) | resource |
| [linode_nodebalancer_config.this](https://registry.terraform.io/providers/linode/linode/latest/docs/resources/nodebalancer_config) | resource |
| [linode_nodebalancer_node.this](https://registry.terraform.io/providers/linode/linode/latest/docs/resources/nodebalancer_node) | resource |
| [linode_stackscript.this](https://registry.terraform.io/providers/linode/linode/latest/docs/resources/stackscript) | resource |
| [random_string.db_passord](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [random_string.inst_root_passord](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorized_keys"></a> [authorized\_keys](#input\_authorized\_keys) | n/a | `list(any)` | `[]` | no |
| <a name="input_db_cluster_size"></a> [db\_cluster\_size](#input\_db\_cluster\_size) | number of instance to run in the db cluster | `number` | `1` | no |
| <a name="input_db_encrytion"></a> [db\_encrytion](#input\_db\_encrytion) | n/a | `bool` | `true` | no |
| <a name="input_db_engine_id"></a> [db\_engine\_id](#input\_db\_engine\_id) | Options avaible by running `linode-cli databases engines` | `string` | `"mysql/8.0.26"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | default database name to use. Will use Label variable if not set | `string` | `""` | no |
| <a name="input_db_replication_type"></a> [db\_replication\_type](#input\_db\_replication\_type) | (Optional) The replication method used for the Managed Database. (none, asynch, semi\_synch; default none) | `string` | `"none"` | no |
| <a name="input_db_ssl"></a> [db\_ssl](#input\_db\_ssl) | n/a | `bool` | `true` | no |
| <a name="input_db_type"></a> [db\_type](#input\_db\_type) | Options avaible by running `linode-cli databases types` | `string` | `"g6-nanode-1"` | no |
| <a name="input_group"></a> [group](#input\_group) | n/a | `string` | `""` | no |
| <a name="input_instance_backups_enabled"></a> [instance\_backups\_enabled](#input\_instance\_backups\_enabled) | (Optional) If this field is set to true, the created Linode will automatically be enrolled in the Linode Backup service | `bool` | `true` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | number of instances. if more than 1 ins selected a Node ballancer will be created and traffic served through it. | `number` | `1` | no |
| <a name="input_instance_image"></a> [instance\_image](#input\_instance\_image) | Options avaible by running `linode-cli images list` | `string` | `"linode/alpine3.16"` | no |
| <a name="input_instance_private_ip"></a> [instance\_private\_ip](#input\_instance\_private\_ip) | (Optional) If true, the created Linode will have private networking enabled, allowing use of the 192.168.128.0/17 network within the Linode's region. It can be enabled on an existing Linode but it can't be disabled | `bool` | `true` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | n/a | `string` | `"g6-standard-1"` | no |
| <a name="input_instance_watchdog_enabled"></a> [instance\_watchdog\_enabled](#input\_instance\_watchdog\_enabled) | The watchdog, named Lassie, is a Shutdown Watchdog that monitors your Linode and will reboot it if it powers off unexpectedly. | `bool` | `true` | no |
| <a name="input_label"></a> [label](#input\_label) | The base name for the stack | `string` | n/a | yes |
| <a name="input_lb_client_conn_throttle"></a> [lb\_client\_conn\_throttle](#input\_lb\_client\_conn\_throttle) | value for Nodebalanacer client\_conn\_throttle | `number` | `0` | no |
| <a name="input_lb_config_check_interval"></a> [lb\_config\_check\_interval](#input\_lb\_config\_check\_interval) | How often, in seconds, to check that backends are up and serving requests. | `number` | `60` | no |
| <a name="input_lb_config_check_path"></a> [lb\_config\_check\_path](#input\_lb\_config\_check\_path) | (Optional) The URL path to check on each backend. If the backend does not respond to this request it is considered to be down. | `string` | `"/health"` | no |
| <a name="input_lb_config_check_timeout"></a> [lb\_config\_check\_timeout](#input\_lb\_config\_check\_timeout) | How long, in seconds, to wait for a check attempt before considering it failed. (1-30) | `number` | `30` | no |
| <a name="input_region"></a> [region](#input\_region) | (Required) This is the location where the Linode is deployed. Examples are ＂us-east＂, ＂us-west＂, ＂ap-south＂, etc. See all regions here. Changing region forces the creation of a new Linode Instance | `string` | `"us-east"` | no |
| <a name="input_stackscript_data"></a> [stackscript\_data](#input\_stackscript\_data) | Map of required StackScript UDF data. | `map(any)` | `{}` | no |
| <a name="input_stackscript_extend"></a> [stackscript\_extend](#input\_stackscript\_extend) | appeded to the base stack script that provides mysql access. | `string` | `""` | no |
| <a name="input_swap_space"></a> [swap\_space](#input\_swap\_space) | n/a | `number` | `256` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database"></a> [database](#output\_database) | linode database info.https://registry.terraform.io/providers/linode/linode/latest/docs/resources/database# |
| <a name="output_instance"></a> [instance](#output\_instance) | linode instance info.https://registry.terraform.io/providers/linode/linode/latest/docs/resources/instance# |
| <a name="output_instance_tags"></a> [instance\_tags](#output\_instance\_tags) | List of tags attached tot eh instance |
| <a name="output_nodebalancer_hostname"></a> [nodebalancer\_hostname](#output\_nodebalancer\_hostname) | This NodeBalancer's hostname, ending with .nodebalancer.linode.com |
| <a name="output_nodebalancer_ipv4"></a> [nodebalancer\_ipv4](#output\_nodebalancer\_ipv4) | The Public IPv4 Address of this NodeBalancer |
| <a name="output_nodebalancer_ipv6"></a> [nodebalancer\_ipv6](#output\_nodebalancer\_ipv6) | The Public IPv6 Address of this NodeBalancer |
<!-- END_TF_DOCS -->
