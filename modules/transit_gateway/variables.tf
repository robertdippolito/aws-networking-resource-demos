variable "name" {
  description = "Base name for TGW resources."
  type        = string
}

variable "description" {
  description = "Description for the transit gateway."
  type        = string
  default     = "Transit Gateway for demo connectivity"
}

variable "amazon_side_asn" {
  description = "Private ASN for the transit gateway."
  type        = number
  default     = 64512
}

variable "auto_accept_shared_attachments" {
  description = "Whether TGW auto-accepts shared attachments."
  type        = bool
  default     = false
}

variable "dns_support" {
  description = "Whether DNS support is enabled on the TGW."
  type        = bool
  default     = true
}

variable "vpn_ecmp_support" {
  description = "Whether VPN ECMP support is enabled on the TGW."
  type        = bool
  default     = true
}

variable "create_transit_gateway_route_table" {
  description = "Whether to create and manage a dedicated TGW route table."
  type        = bool
  default     = true
}

variable "vpc_attachments" {
  description = "Map of VPC attachments keyed by a friendly name."
  type = map(object({
    vpc_id     = string
    subnet_ids = list(string)
  }))
  default = {}
}

variable "tags" {
  description = "Tags applied to all TGW resources."
  type        = map(string)
  default     = {}
}
