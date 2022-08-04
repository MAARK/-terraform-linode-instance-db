output "instance" {
  value       = try(linode_instance.this, "")
  description = "linode instance info.https://registry.terraform.io/providers/linode/linode/latest/docs/resources/instance# "
  sensitive   = true
}

output "instance_tags" {
  value       = try(flatten(linode_instance.this.tags), "")
  description = "List of tags attached tot eh instance"
}

output "database" {
  value       = try(linode_database_mysql.this, "")
  description = "linode database info.https://registry.terraform.io/providers/linode/linode/latest/docs/resources/database# "
  sensitive   = true
}
