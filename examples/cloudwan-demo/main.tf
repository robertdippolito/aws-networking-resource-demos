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
  alias  = "use1"
  region = var.region_a
}

provider "aws" {
  alias  = "use2"
  region = var.region_b
}

locals {
  project_tags = {
    Project = "cloudwan-demo"
    Env     = "lab"
  }

  vpc_a_cidr = "10.50.0.0/16"
  vpc_b_cidr = "10.60.0.0/16"
}

module "vpc_a" {
  source = "../../modules/vpc"

  providers = {
    aws = aws.use1
  }

  name                = "cloudwan-vpc-a"
  vpc_cidr            = local.vpc_a_cidr
  public_subnet_cidr  = "10.50.1.0/24"
  private_subnet_cidr = "10.50.2.0/24"
  availability_zone   = var.region_a_az

  tags = merge(local.project_tags, {
    Region = var.region_a
    VPC    = "a"
  })
}

module "vpc_b" {
  source = "../../modules/vpc"

  providers = {
    aws = aws.use2
  }

  name                = "cloudwan-vpc-b"
  vpc_cidr            = local.vpc_b_cidr
  public_subnet_cidr  = "10.60.1.0/24"
  private_subnet_cidr = "10.60.2.0/24"
  availability_zone   = var.region_b_az

  tags = merge(local.project_tags, {
    Region = var.region_b
    VPC    = "b"
  })
}

module "app_a" {
  source = "../../modules/ec2_http"

  providers = {
    aws = aws.use1
  }

  name      = "cloudwan-app-a"
  vpc_id    = module.vpc_a.vpc_id
  subnet_id = module.vpc_a.public_subnet_id

  key_name         = var.key_name_region_a
  endpoint_message = "hello from ${var.region_a}"

  http_ingress_cidrs = [local.vpc_b_cidr]

  tags = merge(local.project_tags, {
    Region = var.region_a
  })
}

module "app_b" {
  source = "../../modules/ec2_http"

  providers = {
    aws = aws.use2
  }

  name      = "cloudwan-app-b"
  vpc_id    = module.vpc_b.vpc_id
  subnet_id = module.vpc_b.public_subnet_id

  key_name         = var.key_name_region_b
  endpoint_message = "hello from ${var.region_b}"

  http_ingress_cidrs = [local.vpc_a_cidr]

  tags = merge(local.project_tags, {
    Region = var.region_b
  })
}

module "cloudwan" {
  source = "../../modules/cloudwan"

  providers = {
    aws = aws.use1
  }

  name           = "demo-cloudwan"
  edge_locations = [var.region_a, var.region_b]

  tags = local.project_tags
}

data "aws_vpc" "vpc_a" {
  provider = aws.use1
  id       = module.vpc_a.vpc_id
}

data "aws_vpc" "vpc_b" {
  provider = aws.use2
  id       = module.vpc_b.vpc_id
}

data "aws_subnet" "vpc_a_private" {
  provider = aws.use1
  id       = module.vpc_a.private_subnet_id
}

data "aws_subnet" "vpc_b_private" {
  provider = aws.use2
  id       = module.vpc_b.private_subnet_id
}

resource "aws_networkmanager_vpc_attachment" "vpc_a" {
  provider = aws.use1

  core_network_id = module.cloudwan.core_network_id
  vpc_arn         = data.aws_vpc.vpc_a.arn
  subnet_arns     = [data.aws_subnet.vpc_a_private.arn]

  tags = merge(local.project_tags, {
    Name    = "cloudwan-vpc-a-attachment"
    Segment = module.cloudwan.segment_name
  })
}

resource "aws_networkmanager_vpc_attachment" "vpc_b" {
  provider = aws.use2

  core_network_id = module.cloudwan.core_network_id
  vpc_arn         = data.aws_vpc.vpc_b.arn
  subnet_arns     = [data.aws_subnet.vpc_b_private.arn]

  tags = merge(local.project_tags, {
    Name    = "cloudwan-vpc-b-attachment"
    Segment = module.cloudwan.segment_name
  })
}

resource "aws_route" "vpc_a_public_to_cloudwan" {
  provider = aws.use1

  route_table_id         = module.vpc_a.public_route_table_id
  destination_cidr_block = local.vpc_b_cidr
  core_network_arn       = module.cloudwan.core_network_arn

  depends_on = [
    aws_networkmanager_vpc_attachment.vpc_a,
    aws_networkmanager_vpc_attachment.vpc_b,
  ]
}

resource "aws_route" "vpc_a_private_to_cloudwan" {
  provider = aws.use1

  route_table_id         = module.vpc_a.private_route_table_id
  destination_cidr_block = local.vpc_b_cidr
  core_network_arn       = module.cloudwan.core_network_arn

  depends_on = [
    aws_networkmanager_vpc_attachment.vpc_a,
    aws_networkmanager_vpc_attachment.vpc_b,
  ]
}

resource "aws_route" "vpc_b_public_to_cloudwan" {
  provider = aws.use2

  route_table_id         = module.vpc_b.public_route_table_id
  destination_cidr_block = local.vpc_a_cidr
  core_network_arn       = module.cloudwan.core_network_arn

  depends_on = [
    aws_networkmanager_vpc_attachment.vpc_a,
    aws_networkmanager_vpc_attachment.vpc_b,
  ]
}

resource "aws_route" "vpc_b_private_to_cloudwan" {
  provider = aws.use2

  route_table_id         = module.vpc_b.private_route_table_id
  destination_cidr_block = local.vpc_a_cidr
  core_network_arn       = module.cloudwan.core_network_arn

  depends_on = [
    aws_networkmanager_vpc_attachment.vpc_a,
    aws_networkmanager_vpc_attachment.vpc_b,
  ]
}
