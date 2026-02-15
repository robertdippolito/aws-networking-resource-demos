output "instance_id" {
  description = "EC2 instance ID."
  value       = aws_instance.this.id
}

output "private_ip" {
  description = "Private IP address of the instance."
  value       = aws_instance.this.private_ip
}

output "public_ip" {
  description = "Public IP address of the instance (if assigned)."
  value       = aws_instance.this.public_ip
}

output "availability_zone" {
  description = "Availability zone of the instance."
  value       = aws_instance.this.availability_zone
}

output "security_group_id" {
  description = "ID of the module-created security group, or null if create_security_group=false."
  value       = var.create_security_group ? aws_security_group.this[0].id : null
}
