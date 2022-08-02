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
  root_pass       = random_string.inst_root_passord.result
  stackscript_id  = linode_stackscript.this.id
  tags            = var.tags
}

resource "linode_stackscript" "this" {
  label       = var.label
  description = "Connects database ${var.label} with trhe instance."
  script      = <<EOF
#!/bin/bash

${var.stackscript_extend}

EOF
  images      = ["linode/ubuntu18.04", "linode/ubuntu16.04lts"]
  rev_note    = "initial version"
}

resource "linode_database_mysql" "this" {
  label     = var.label
  engine_id = var.db_engine_id
  region    = var.region
  type      = var.db_type

  cluster_size     = var.db_cluster_size
  encrypted        = var.db_encrytion
  replication_type = var.db_replication_type
  ssl_connection   = var.db_ssl
  /* TODO update blocks
  updates {
    day_of_week   = "saturday"
    duration      = 1
    frequency     = "monthly"
    hour_of_day   = 22
    week_of_month = 2
  }
  */
}
