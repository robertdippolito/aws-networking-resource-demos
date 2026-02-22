output "transit_gateway_id" {
  description = "Transit Gateway ID."
  value       = aws_ec2_transit_gateway.this.id
}

output "transit_gateway_arn" {
  description = "Transit Gateway ARN."
  value       = aws_ec2_transit_gateway.this.arn
}

output "transit_gateway_route_table_id" {
  description = "Dedicated TGW route table ID if created; otherwise null."
  value       = var.create_transit_gateway_route_table ? aws_ec2_transit_gateway_route_table.this[0].id : null
}

output "vpc_attachment_ids" {
  description = "Map of attachment IDs keyed by attachment name."
  value       = { for key, attachment in aws_ec2_transit_gateway_vpc_attachment.this : key => attachment.id }
}
