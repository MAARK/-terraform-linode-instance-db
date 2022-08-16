locals {
  db_name   = var.db_name != "" ? var.db_name : var.label
  create_lb = var.instance_count > 1 ? 1 : 0
}

resource "random_string" "db_passord" {
  length  = 32
  special = true
}
resource "random_string" "inst_root_passord" {
  length  = 32
  special = true
}

resource "linode_instance" "this" {
  count           = var.instance_count
  image           = var.instance_image
  label           = var.instance_count > 1 ? "${var.label}-${count.index}" : var.label
  region          = var.region
  type            = var.instance_type
  authorized_keys = var.authorized_keys
  root_pass       = random_string.inst_root_passord.result
  stackscript_id  = linode_stackscript.this.id
  private_ip      = var.instance_private_ip
  tags            = var.tags
}

resource "linode_stackscript" "this" {
  label       = var.label
  description = "Connects database ${var.label} with trhe instance."
  script = templatefile(
    "${path.module}/templates/stack_script.sh.tftpl",
    {
      db_host            = linode_database_mysql.this.host_primary,
      db_user            = linode_database_mysql.this.root_username,
      db_name            = local.db_name,
      db_password        = linode_database_mysql.this.root_password,
      stackscript_extend = try(var.stackscript_extend, "")
    }
  )
  images   = [var.instance_image]
  rev_note = "initial version"
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

resource "linode_nodebalancer" "this" {
  count                = local.create_lb
  label                = var.label
  region               = var.region
  client_conn_throttle = var.lb_client_conn_throttle
  tags                 = var.tags
}

resource "linode_nodebalancer_config" "this" {
  nodebalancer_id = linode_nodebalancer.this[0].id
  port            = 80
  protocol        = "http"
  check           = "http"
  check_path      = "/foo"
  check_attempts  = 3
  check_timeout   = 30
  stickiness      = "http_cookie"
  algorithm       = "source"
}

resource "linode_nodebalancer_node" "this" {
  count           = var.instance_count
  nodebalancer_id = linode_nodebalancer.this[0].id
  config_id       = linode_nodebalancer_config.this.id
  address         = "${linode_instance.this[count.index].private_ip_address}:80"
  label           = "${var.label}-${count.index}"
  weight          = 50
}
