variable "label" {
  type        = string
  description = "The base name for the stack"
}

variable "region" {
  default     = "us-east"
  description = "(Required) This is the location where the Linode is deployed. Examples are ＂us-east＂, ＂us-west＂, ＂ap-south＂, etc. See all regions here. Changing region forces the creation of a new Linode Instance"
}

# Instance Settings
variable "instance_image" {
  default     = "linode/alpine3.16"
  type        = string
  description = "Base Image forthe instance(s). Options avaible by running `linode-cli images list`"
}

variable "tags" {
  default     = []
  type        = list(any)
  description = "Tage to be added to the `linode_instance` and and any other resource that had tags"
}

variable "instance_type" {
  type        = string
  default     = "g6-standard-1"
  description = "Linode Instance type. Get options avaible by running `linode-cli images list`"
}

variable "instance_private_ip" {
  type        = bool
  default     = true
  description = " (Optional) If true, the created Linode will have private networking enabled, allowing use of the 192.168.128.0/17 network within the Linode's region. It can be enabled on an existing Linode but it can't be disabled"
}

variable "instance_backups_enabled" {
  default     = true
  type        = bool
  description = "(Optional) If this field is set to true, the created Linode will automatically be enrolled in the Linode Backup service"
}
variable "instance_watchdog_enabled" {
  default     = true
  type        = bool
  description = "The watchdog, named Lassie, is a Shutdown Watchdog that monitors your Linode and will reboot it if it powers off unexpectedly."
}

variable "group" {
  default = ""
  type    = string
}

variable "swap_space" {
  default = 256
  type    = number
}

variable "stackscript_data" {
  description = "Map of required StackScript UDF data."
  type        = map(any)
  default     = {}
}

variable "stackscript_extend" {
  description = "appeded to the base stack script that provides mysql access."
  default     = ""
}

variable "authorized_keys" {
  default = []
  type    = list(any)
}
variable "instance_count" {
  default     = 1
  type        = number
  description = "number of instances. if more than 1 is selected a Node ballancer will be created and traffic served through it."
}

#db settings

variable "db_engine_id" {
  default     = "mysql/8.0.26"
  type        = string
  description = "Options avaible by running `linode-cli databases engines`"
}

variable "db_type" {
  default     = "g6-nanode-1"
  type        = string
  description = "Options avaible by running `linode-cli databases types`"
}

variable "db_cluster_size" {
  default     = 1
  type        = number
  description = "number of instance to run in the db cluster"
}

variable "db_replication_type" {
  default     = "none"
  description = "(Optional) The replication method used for the Managed Database. (none, asynch, semi_synch; default none)"
  type        = string
}

variable "db_encrytion" {
  default = true
  type    = bool
}

variable "db_ssl" {
  default = true
  type    = bool
}

variable "db_name" {
  default     = ""
  type        = string
  description = "default database name to use. Will use Label variable if not set"
}

# LB settings
variable "lb_client_conn_throttle" {
  default     = 0
  type        = number
  description = "value for Nodebalanacer client_conn_throttle"
}

variable "lb_config_check_path" {
  default     = "/health"
  type        = string
  description = "(Optional) The URL path to check on each backend. If the backend does not respond to this request it is considered to be down."
}

variable "lb_config_check_interval" {
  default     = 60
  type        = number
  description = "How often, in seconds, to check that backends are up and serving requests."
}

variable "lb_config_check_timeout" {
  default     = 30
  type        = number
  description = "How long, in seconds, to wait for a check attempt before considering it failed. (1-30)"
}
