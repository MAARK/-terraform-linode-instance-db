output "instance_id" {
  value       = linode_instance.this.id
  description = "linode instance ID"
}

output "instance_details" {
  value       = data.linode_instances.this
  description = "detailed instance info"
}
