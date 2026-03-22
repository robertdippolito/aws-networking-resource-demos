terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

locals {
  core_network_policy = {
    version = "2021.12"
    "core-network-configuration" = {
      "asn-ranges" = var.asn_ranges
      "edge-locations" = [
        for location in var.edge_locations : {
          location = location
        }
      ]
    }
    segments = [
      {
        name                            = var.segment_name
        "require-attachment-acceptance" = false
      }
    ]
    "attachment-policies" = [
      {
        "rule-number"     = 100
        "condition-logic" = "and"
        conditions = [
          {
            type     = "tag-value"
            operator = "equals"
            key      = var.attachment_policy_tag_key
            value    = var.attachment_policy_tag_value
          }
        ]
        action = {
          "association-method" = "constant"
          segment              = var.segment_name
        }
      }
    ]
  }
}

resource "aws_networkmanager_global_network" "this" {
  description = var.global_network_description

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_networkmanager_core_network" "this" {
  global_network_id = aws_networkmanager_global_network.this.id
  description       = var.core_network_description

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_networkmanager_core_network_policy_attachment" "this" {
  core_network_id = aws_networkmanager_core_network.this.id
  policy_document = jsonencode(local.core_network_policy)
}
