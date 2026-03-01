variable "aws_region" {
  description = "AWS region for the demo environment."
  type        = string
  default     = "us-east-1"
}

variable "key_name" {
  description = "Optional EC2 key pair name for SSH access."
  type        = string
  default     = null
}

variable "vpc_a_az" {
  description = "AZ for VPC A."
  type        = string
  default     = "us-east-1a"
}

variable "vpc_b_az" {
  description = "AZ for VPC B."
  type        = string
  default     = "us-east-1b"
}

variable "vpc_c_az" {
  description = "AZ for VPC C."
  type        = string
  default     = "us-east-1c"
}

variable "vpc_d_az" {
  description = "AZ for VPC D."
  type        = string
  default     = "us-east-1d"
}
