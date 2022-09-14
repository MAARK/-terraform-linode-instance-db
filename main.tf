locals {
  db_name              = var.db_name != "" ? var.db_name : var.label
  create_lb            = var.instance_count > 1 ? 1 : 0
  private_ip_addresses = toset([for e in linode_instance.this : e.private_ip_address])
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
  count            = var.instance_count
  image            = var.instance_image
  label            = var.instance_count > 1 ? "${var.label}-${count.index}" : var.label
  region           = var.region
  type             = var.instance_type
  authorized_keys  = var.authorized_keys
  root_pass        = random_string.inst_root_passord.result
  stackscript_id   = linode_stackscript.this.id
  private_ip       = var.instance_private_ip
  backups_enabled  = var.instance_backups_enabled
  watchdog_enabled = var.instance_watchdog_enabled
  tags             = var.tags
}

resource "linode_stackscript" "this" {
  label       = var.label
  description = "Connects database ${var.label} with trhe instance."
  script = templatefile(
    "${path.module}/templates/stack_script.sh.tftpl",
    {
      db_host            = linode_database_mysql.this.host_secondary,
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
resource "linode_database_access_controls" "this" {
  database_id   = linode_database_mysql.this.id
  database_type = "mysql"

  allow_list = local.private_ip_addresses
}
resource "linode_nodebalancer" "this" {
  count                = local.create_lb
  label                = var.label
  region               = var.region
  client_conn_throttle = var.lb_client_conn_throttle
  tags                 = var.tags
}

resource "linode_nodebalancer_config" "http" {
  nodebalancer_id = linode_nodebalancer.this[0].id
  port            = 80
  protocol        = "http"
  check           = "http"
  check_path      = var.lb_config_check_path
  check_attempts  = 3
  check_interval  = var.lb_config_check_interval
  check_timeout   = var.lb_config_check_timeout
  stickiness      = "http_cookie"
  algorithm       = "source"
}

resource "linode_nodebalancer_node" "http" {
  count           = var.instance_count
  nodebalancer_id = linode_nodebalancer.this[0].id
  config_id       = linode_nodebalancer_config.http.id
  address         = "${linode_instance.this[count.index].private_ip_address}:80"
  label           = "${var.label}-${count.index}"
  weight          = 50
}

/* TODO Add cert
resource "linode_nodebalancer_config" "https" {
  nodebalancer_id = linode_nodebalancer.this[0].id
  port            = 443
  protocol        = "https"
  check           = "http"
  check_path      = var.lb_config_check_path
  check_attempts  = 3
  check_interval  = var.lb_config_check_interval
  check_timeout   = var.lb_config_check_timeout
  stickiness      = "http_cookie"
  algorithm       = "source"
}

resource "linode_nodebalancer_node" "https" {
  count           = var.instance_count
  nodebalancer_id = linode_nodebalancer.this[0].id
  config_id       = linode_nodebalancer_config.https.id
  address         = "${linode_instance.this[count.index].private_ip_address}:80"
  label           = "${var.label}-${count.index}"
  weight          = 50
}
*/
