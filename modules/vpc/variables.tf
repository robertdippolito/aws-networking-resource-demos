variable "name" {
  description = "Base name for VPC resources."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.public_subnet_cidr))
    error_message = "public_subnet_cidr must be a valid IPv4 CIDR block."
  }
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.private_subnet_cidr))
    error_message = "private_subnet_cidr must be a valid IPv4 CIDR block."
  }

  validation {
    condition     = var.private_subnet_cidr != var.public_subnet_cidr
    error_message = "public_subnet_cidr and private_subnet_cidr must be different."
  }
}

variable "availability_zone" {
  description = "Availability Zone used for both subnets (for example: us-east-1a)."
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources in this VPC."
  type        = map(string)
  default     = {}
}
