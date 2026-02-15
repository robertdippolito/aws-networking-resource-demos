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
  source = "../../modules/vpc"

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
  source = "../../modules/vpc"

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
