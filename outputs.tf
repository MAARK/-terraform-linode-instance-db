output "instance" {
  value       = try(linode_instance.this, "")
  description = "linode instance info.https://registry.terraform.io/providers/linode/linode/latest/docs/resources/instance# "
  sensitive   = true
}

output "instance_tags" {
  value       = try(flatten(linode_instance.this[*].tags), "")
  description = "List of tags attached tot eh instance"
}

output "database" {
  value       = try(linode_database_mysql.this, "")
  description = "linode database info.https://registry.terraform.io/providers/linode/linode/latest/docs/resources/database# "
  sensitive   = true
}

output "nodebalancer_hostname" {
  value       = try(linode_nodebalancer.this[0].hostname, "")
  description = "This NodeBalancer's hostname, ending with .nodebalancer.linode.com"
}
output "nodebalancer_ipv4" {
  value       = try(linode_nodebalancer.this[0].ipv4, "")
  description = " The Public IPv4 Address of this NodeBalancer"
}
output "nodebalancer_ipv6" {
  value       = try(linode_nodebalancer.this[0].ipv6, "")
  description = "The Public IPv6 Address of this NodeBalancer"
}
