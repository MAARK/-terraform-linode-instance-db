terraform {
  required_version = ">= 1.1"
  required_providers {
    linode = {
      source  = "linode/linode"
      version = ">= 1.28"
    }
    random = ">= 2.0"
  }
}
provider "linode" {
}

resource "random_pet" "this" {
  length = 3

}
variable "region" {
  default = "us-east"
  type    = string
}
variable "label" {
  default = "testInstance"

}
variable "testing_tag" {
  default = "manual_test_tag"
}

locals {
  #if name is provided by testing module use that otherwise use random_pet
  label = (var.label != "" ? var.label : random_pet.this.id)
}

# Calling the module
module "this" {
  source = "../../"

  label  = local.label
  region = var.region
  tags   = [var.testing_tag]
}

output "instance" {
  value     = try(module.this.instance, "instance not found")
  sensitive = true
}
output "instance_tags" {
  value = try(module.this.instance_tags, "")
}
output "db" {
  value     = try(module.this.database, "database not found")
  sensitive = true
}
