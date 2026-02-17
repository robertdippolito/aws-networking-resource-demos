variable "aws_region" {
  description = "AWS region for the demo environment."
  type        = string
  default     = "us-east-1"
}

variable "vpc_a_az" {
  description = "AZ for VPC A (for example: us-east-1a)."
  type        = string
  default     = "us-east-1a"
}

variable "vpc_b_az" {
  description = "AZ for VPC B (for example: us-east-1b)."
  type        = string
  default     = "us-east-1b"
}
