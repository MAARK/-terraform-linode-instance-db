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

  label          = local.label
  region         = var.region
  tags           = [var.testing_tag]
  instance_count = 2
}
