resource "random_string" "db_passord" {
  length  = 32
  special = true
}
resource "random_string" "inst_root_passord" {
  length  = 32
  special = true
}

resource "linode_instance" "this" {
  image           = var.image
  label           = var.label
  region          = var.region
  type            = var.instance_type
  authorized_keys = var.authorized_keys
  root_pass       = random_string.inst_root_passord
  stackscript_id  = linode_stackscript.this.id
  tags            = var.tags
}

resource "linode_stackscript" "this" {
  label       = var.label
  description = "Connects database ${var.label} with trhe instance."
  script      = <<EOF
#!/bin/bash

$var.stackscript_extend

EOF
  images      = ["linode/ubuntu18.04", "linode/ubuntu16.04lts"]
  rev_note    = "initial version"
}

data "linode_instances" "this" {
  filter {
    name   = "id"
    values = linode_instance.this.id
  }
}
