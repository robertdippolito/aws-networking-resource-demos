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

module "vpc_a" {
  source = "../modules/vpc"

  name                = "demo-vpc-a"
  vpc_cidr            = "10.10.0.0/16"
  public_subnet_cidr  = "10.10.1.0/24"
  private_subnet_cidr = "10.10.2.0/24"
  availability_zone   = var.vpc_a_az

  tags = {
    Project = "vpc-peering-demo"
    Env     = "lab"
    VPC     = "a"
  }
}

module "vpc_b" {
  source = "../modules/vpc"

  name                = "demo-vpc-b"
  vpc_cidr            = "10.20.0.0/16"
  public_subnet_cidr  = "10.20.1.0/24"
  private_subnet_cidr = "10.20.2.0/24"
  availability_zone   = var.vpc_b_az

  tags = {
    Project = "vpc-peering-demo"
    Env     = "lab"
    VPC     = "b"
  }
}

module "app_a" {
  source = "../modules/ec2_http"

  name      = "app-a"
  vpc_id    = module.vpc_a.vpc_id
  subnet_id = module.vpc_a.public_subnet_id

  endpoint_message = "hello from vpc-a"

  http_ingress_cidrs = ["10.20.0.0/16"]

  tags = {
    Project = "vpc-peering-demo"
    Env     = "lab"
  }
}

module "app_b" {
  source = "../modules/ec2_http"

  name      = "app-b"
  vpc_id    = module.vpc_b.vpc_id
  subnet_id = module.vpc_b.public_subnet_id

  endpoint_message = "hello from vpc-b"

  http_ingress_cidrs = ["10.10.0.0/16"]

  tags = {
    Project = "vpc-peering-demo"
    Env     = "lab"
  }
}

module "peering" {
  source = "../modules/vpc_peering"

  name = "demo-a-b-peering"

  requester_vpc_id   = module.vpc_a.vpc_id
  accepter_vpc_id    = module.vpc_b.vpc_id
  requester_vpc_cidr = module.vpc_a.vpc_cidr
  accepter_vpc_cidr  = module.vpc_b.vpc_cidr

  requester_route_table_ids = [
    module.vpc_a.public_route_table_id,
    module.vpc_a.private_route_table_id,
  ]

  accepter_route_table_ids = [
    module.vpc_b.public_route_table_id,
    module.vpc_b.private_route_table_id,
  ]

  tags = {
    Project = "vpc-peering-demo"
    Env     = "lab"
  }
}