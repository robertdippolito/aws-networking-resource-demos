terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

resource "aws_ec2_transit_gateway" "this" {
  description = var.description

  amazon_side_asn                 = var.amazon_side_asn
  auto_accept_shared_attachments  = var.auto_accept_shared_attachments ? "enable" : "disable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  dns_support                     = var.dns_support ? "enable" : "disable"
  vpn_ecmp_support                = var.vpn_ecmp_support ? "enable" : "disable"

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  for_each = var.vpc_attachments

  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = each.value.vpc_id
  subnet_ids         = each.value.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.name}-${each.key}-attachment"
  })
}

resource "aws_ec2_transit_gateway_route_table" "this" {
  count = var.create_transit_gateway_route_table ? 1 : 0

  transit_gateway_id = aws_ec2_transit_gateway.this.id

  tags = merge(var.tags, {
    Name = "${var.name}-rt"
  })
}

resource "aws_ec2_transit_gateway_route_table_association" "this" {
  for_each = var.create_transit_gateway_route_table ? aws_ec2_transit_gateway_vpc_attachment.this : {}

  transit_gateway_attachment_id  = each.value.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this[0].id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
  for_each = var.create_transit_gateway_route_table ? aws_ec2_transit_gateway_vpc_attachment.this : {}

  transit_gateway_attachment_id  = each.value.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this[0].id
}
