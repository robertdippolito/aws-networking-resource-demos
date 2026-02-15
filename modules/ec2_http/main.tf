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
  use_default_ami = var.ami_id == null
  selected_ami_id = local.use_default_ami ? data.aws_ssm_parameter.al2023_ami[0].value : var.ami_id

  default_security_group_ids = var.create_security_group ? [aws_security_group.this[0].id] : []
  security_group_ids         = concat(local.default_security_group_ids, var.additional_security_group_ids)
}

data "aws_ssm_parameter" "al2023_ami" {
  count = local.use_default_ami ? 1 : 0
  name  = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_security_group" "this" {
  count = var.create_security_group ? 1 : 0

  name_prefix = "${var.name}-sg-"
  description = "Security group for ${var.name}"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_ingress_cidrs
  }

  ingress {
    description = "HTTP demo endpoint"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.http_ingress_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-sg"
  })
}

resource "aws_instance" "this" {
  ami                         = local.selected_ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = local.security_group_ids
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = var.key_name
  iam_instance_profile        = var.iam_instance_profile

  user_data = templatefile("${path.module}/user_data.sh.tftpl", {
    endpoint_message = var.endpoint_message
  })

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = merge(var.tags, {
    Name = var.name
  })

  lifecycle {
    precondition {
      condition     = length(local.security_group_ids) > 0
      error_message = "At least one security group must be attached. Either set create_security_group=true or provide additional_security_group_ids."
    }
  }
}
