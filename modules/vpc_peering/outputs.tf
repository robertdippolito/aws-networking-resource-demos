output "peering_connection_id" {
  description = "VPC peering connection ID."
  value       = aws_vpc_peering_connection.this.id
}

output "peering_status" {
  description = "Current status of the peering connection."
  value       = aws_vpc_peering_connection.this.accept_status
}
