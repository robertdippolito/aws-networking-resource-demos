terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  project_tags = {
    Project = "transit-gateway-demo"
    Env     = "lab"
  }

  vpc_cidrs = {
    vpc_a = "10.10.0.0/16"
    vpc_b = "10.20.0.0/16"
    vpc_c = "10.30.0.0/16"
    vpc_d = "10.40.0.0/16"
  }
}

module "vpc_a" {
  source = "../../modules/vpc"

  name                = "demo-vpc-a"
  vpc_cidr            = local.vpc_cidrs.vpc_a
  public_subnet_cidr  = "10.10.1.0/24"
  private_subnet_cidr = "10.10.2.0/24"
  availability_zone   = var.vpc_a_az

  tags = merge(local.project_tags, { VPC = "a" })
}

module "vpc_b" {
  source = "../../modules/vpc"

  name                = "demo-vpc-b"
  vpc_cidr            = local.vpc_cidrs.vpc_b
  public_subnet_cidr  = "10.20.1.0/24"
  private_subnet_cidr = "10.20.2.0/24"
  availability_zone   = var.vpc_b_az

  tags = merge(local.project_tags, { VPC = "b" })
}

module "vpc_c" {
  source = "../../modules/vpc"

  name                = "demo-vpc-c"
  vpc_cidr            = local.vpc_cidrs.vpc_c
  public_subnet_cidr  = "10.30.1.0/24"
  private_subnet_cidr = "10.30.2.0/24"
  availability_zone   = var.vpc_c_az

  tags = merge(local.project_tags, { VPC = "c" })
}

module "vpc_d" {
  source = "../../modules/vpc"

  name                = "demo-vpc-d"
  vpc_cidr            = local.vpc_cidrs.vpc_d
  public_subnet_cidr  = "10.40.1.0/24"
  private_subnet_cidr = "10.40.2.0/24"
  availability_zone   = var.vpc_d_az

  tags = merge(local.project_tags, { VPC = "d" })
}

module "app_a" {
  source = "../../modules/ec2_http"

  name      = "app-a"
  vpc_id    = module.vpc_a.vpc_id
  subnet_id = module.vpc_a.public_subnet_id

  key_name         = var.key_name
  endpoint_message = "hello from vpc-a"

  http_ingress_cidrs = [
    local.vpc_cidrs.vpc_b,
    local.vpc_cidrs.vpc_c,
    local.vpc_cidrs.vpc_d,
  ]

  tags = local.project_tags
}

module "app_b" {
  source = "../../modules/ec2_http"

  name      = "app-b"
  vpc_id    = module.vpc_b.vpc_id
  subnet_id = module.vpc_b.public_subnet_id

  key_name         = var.key_name
  endpoint_message = "hello from vpc-b"

  http_ingress_cidrs = [
    local.vpc_cidrs.vpc_a,
    local.vpc_cidrs.vpc_c,
    local.vpc_cidrs.vpc_d,
  ]

  tags = local.project_tags
}

module "app_c" {
  source = "../../modules/ec2_http"

  name      = "app-c"
  vpc_id    = module.vpc_c.vpc_id
  subnet_id = module.vpc_c.public_subnet_id

  key_name         = var.key_name
  endpoint_message = "hello from vpc-c"

  http_ingress_cidrs = [
    local.vpc_cidrs.vpc_a,
    local.vpc_cidrs.vpc_b,
    local.vpc_cidrs.vpc_d,
  ]

  tags = local.project_tags
}

module "app_d" {
  source = "../../modules/ec2_http"

  name      = "app-d"
  vpc_id    = module.vpc_d.vpc_id
  subnet_id = module.vpc_d.public_subnet_id

  key_name         = var.key_name
  endpoint_message = "hello from vpc-d"

  http_ingress_cidrs = [
    local.vpc_cidrs.vpc_a,
    local.vpc_cidrs.vpc_b,
    local.vpc_cidrs.vpc_c,
  ]

  tags = local.project_tags
}

module "tgw" {
  source = "../../modules/transit_gateway"

  name = "demo-transit-gateway"

  vpc_attachments = {
    vpc_a = {
      vpc_id     = module.vpc_a.vpc_id
      subnet_ids = [module.vpc_a.private_subnet_id]
    }
    vpc_b = {
      vpc_id     = module.vpc_b.vpc_id
      subnet_ids = [module.vpc_b.private_subnet_id]
    }
    vpc_c = {
      vpc_id     = module.vpc_c.vpc_id
      subnet_ids = [module.vpc_c.private_subnet_id]
    }
    vpc_d = {
      vpc_id     = module.vpc_d.vpc_id
      subnet_ids = [module.vpc_d.private_subnet_id]
    }
  }

  tags = local.project_tags
}

locals {
  vpc_route_tables = {
    vpc_a = [module.vpc_a.public_route_table_id, module.vpc_a.private_route_table_id]
    vpc_b = [module.vpc_b.public_route_table_id, module.vpc_b.private_route_table_id]
    vpc_c = [module.vpc_c.public_route_table_id, module.vpc_c.private_route_table_id]
    vpc_d = [module.vpc_d.public_route_table_id, module.vpc_d.private_route_table_id]
  }

  # who talks to who
  vpc_pairs = {
    for pair in setproduct(keys(local.vpc_cidrs), keys(local.vpc_cidrs)) :
    "${pair[0]}->${pair[1]}" => {
      source_vpc       = pair[0]
      destination_vpc  = pair[1]
      destination_cidr = local.vpc_cidrs[pair[1]]
    } if pair[0] != pair[1]
  }

  # which route tables need routes
  tgw_routes = merge([
    for _, pair in local.vpc_pairs : {
      for route_table_id in local.vpc_route_tables[pair.source_vpc] :
      "${pair.source_vpc}-${route_table_id}-${pair.destination_vpc}" => {
        route_table_id   = route_table_id
        destination_cidr = pair.destination_cidr
      }
    }
  ]...)
}

resource "aws_route" "to_tgw" {
  for_each = local.tgw_routes

  route_table_id         = each.value.route_table_id
  destination_cidr_block = each.value.destination_cidr
  transit_gateway_id     = module.tgw.transit_gateway_id
}
