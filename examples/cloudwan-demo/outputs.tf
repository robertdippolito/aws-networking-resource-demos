output "global_network_id" {
  description = "Network Manager global network ID."
  value       = module.cloudwan.global_network_id
}

output "core_network_id" {
  description = "CloudWAN core network ID."
  value       = module.cloudwan.core_network_id
}

output "vpc_attachment_ids" {
  description = "CloudWAN VPC attachment IDs by region."
  value = {
    region_a = aws_networkmanager_vpc_attachment.vpc_a.id
    region_b = aws_networkmanager_vpc_attachment.vpc_b.id
  }
}

output "instance_public_ips" {
  description = "Public IPs of demo instances."
  value = {
    app_a = module.app_a.public_ip
    app_b = module.app_b.public_ip
  }
}

output "instance_private_ips" {
  description = "Private IPs of demo instances."
  value = {
    app_a = module.app_a.private_ip
    app_b = module.app_b.private_ip
  }
}
