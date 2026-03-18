variable "region_a" {
  description = "Primary region for VPC A and CloudWAN control provider."
  type        = string
  default     = "us-east-1"
}

variable "region_b" {
  description = "Secondary region for VPC B."
  type        = string
  default     = "us-west-2"
}

variable "region_a_az" {
  description = "AZ used for VPC A resources."
  type        = string
  default     = "us-east-1a"
}

variable "region_b_az" {
  description = "AZ used for VPC B resources."
  type        = string
  default     = "us-west-2a"
}

variable "key_name_region_a" {
  description = "Optional EC2 key pair name for region A instance."
  type        = string
  default     = null
}

variable "key_name_region_b" {
  description = "Optional EC2 key pair name for region B instance."
  type        = string
  default     = null
}
