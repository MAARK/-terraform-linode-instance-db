
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
