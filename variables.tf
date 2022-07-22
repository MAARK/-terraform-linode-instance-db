variable "label" {
  type        = string
  description = "The base name for the stack"
}

variable "region" {
  default     = "us-east"
  description = "(Required) This is the location where the Linode is deployed. Examples are ＂us-east＂, ＂us-west＂, ＂ap-south＂, etc. See all regions here. Changing region forces the creation of a new Linode Instance"
}

# Instance Settings
variable "image" {
  default = ""
  type    = string
}

variable "tags" {
  default = []
  type    = list(any)
}

variable "instance_type" {

  default = "g6-standard-1"
}

variable "instance_private_ip" {
  type    = bool
  default = true
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

#db settings
