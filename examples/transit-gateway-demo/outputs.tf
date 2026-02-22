output "transit_gateway_id" {
  description = "Transit Gateway ID used in this demo."
  value       = module.tgw.transit_gateway_id
}

output "vpc_ids" {
  description = "VPC IDs by name."
  value = {
    vpc_a = module.vpc_a.vpc_id
    vpc_b = module.vpc_b.vpc_id
    vpc_c = module.vpc_c.vpc_id
    vpc_d = module.vpc_d.vpc_id
  }
}

output "instance_private_ips" {
  description = "Private IPs for the four demo instances."
  value = {
    app_a = module.app_a.private_ip
    app_b = module.app_b.private_ip
    app_c = module.app_c.private_ip
    app_d = module.app_d.private_ip
  }
}

output "instance_public_ips" {
  description = "Public IPs for the four demo instances."
  value = {
    app_a = module.app_a.public_ip
    app_b = module.app_b.public_ip
    app_c = module.app_c.public_ip
    app_d = module.app_d.public_ip
  }
}
