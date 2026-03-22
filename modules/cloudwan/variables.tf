variable "name" {
  description = "Base name for CloudWAN resources."
  type        = string
}

variable "global_network_description" {
  description = "Description for the Network Manager global network."
  type        = string
  default     = "Global network for CloudWAN demo"
}

variable "core_network_description" {
  description = "Description for the core network."
  type        = string
  default     = "Core network for CloudWAN demo"
}

variable "edge_locations" {
  description = "AWS regions where CloudWAN core network edges are created."
  type        = list(string)
}

variable "asn_ranges" {
  description = "ASN ranges for the core network."
  type        = list(string)
  default     = ["64512-65534"]
}

variable "segment_name" {
  description = "Segment name used by the base CloudWAN policy."
  type        = string
  default     = "shared"
}

variable "attachment_policy_tag_key" {
  description = "Tag key used to match attachments into the segment."
  type        = string
  default     = "Segment"
}

variable "attachment_policy_tag_value" {
  description = "Tag value used to match attachments into the segment."
  type        = string
  default     = "shared"
}

variable "tags" {
  description = "Tags applied to CloudWAN resources."
  type        = map(string)
  default     = {}
}
