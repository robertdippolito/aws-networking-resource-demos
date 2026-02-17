output "vpc_a_id" {
  value = module.vpc_a.vpc_id
}

output "vpc_b_id" {
  value = module.vpc_b.vpc_id
}

output "vpc_a_private_subnet_id" {
  value = module.vpc_a.private_subnet_id
}

output "vpc_b_private_subnet_id" {
  value = module.vpc_b.private_subnet_id
}

output "vpc_a_public_subnet_id" {
  value = module.vpc_a.public_subnet_id
}

output "vpc_b_public_subnet_id" {
  value = module.vpc_b.public_subnet_id
}
