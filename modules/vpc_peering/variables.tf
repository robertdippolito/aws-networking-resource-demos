variable "name" {
  description = "Name tag for the peering connection."
  type        = string
  default     = "demo-vpc-peering"
}

variable "requester_vpc_id" {
  description = "Requester VPC ID."
  type        = string
}

variable "accepter_vpc_id" {
  description = "Accepter VPC ID."
  type        = string
}

variable "requester_vpc_cidr" {
  description = "Requester VPC CIDR block."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.requester_vpc_cidr))
    error_message = "requester_vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "accepter_vpc_cidr" {
  description = "Accepter VPC CIDR block."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.accepter_vpc_cidr))
    error_message = "accepter_vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "requester_route_table_ids" {
  description = "Route table IDs in requester VPC that need routes to accepter VPC."
  type        = list(string)

  validation {
    condition     = length(var.requester_route_table_ids) > 0
    error_message = "requester_route_table_ids must contain at least one route table ID."
  }
}

variable "accepter_route_table_ids" {
  description = "Route table IDs in accepter VPC that need routes to requester VPC."
  type        = list(string)

  validation {
    condition     = length(var.accepter_route_table_ids) > 0
    error_message = "accepter_route_table_ids must contain at least one route table ID."
  }
}

variable "auto_accept" {
  description = "Whether to auto-accept the peering request."
  type        = bool
  default     = true
}

variable "allow_remote_vpc_dns_resolution" {
  description = "Enable DNS resolution across the peering connection on both sides."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to the peering connection."
  type        = map(string)
  default     = {}
}
