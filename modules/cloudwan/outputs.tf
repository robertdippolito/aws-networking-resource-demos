output "global_network_id" {
  description = "Network Manager Global Network ID."
  value       = aws_networkmanager_global_network.this.id
}

output "core_network_id" {
  description = "CloudWAN Core Network ID."
  value       = aws_networkmanager_core_network.this.id
}

output "core_network_arn" {
  description = "CloudWAN Core Network ARN."
  value       = aws_networkmanager_core_network.this.arn
}

output "segment_name" {
  description = "Segment name used by the base policy."
  value       = var.segment_name
}
