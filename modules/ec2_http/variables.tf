variable "name" {
  description = "Name tag for the EC2 instance and related resources."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the instance security group is created."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the instance is launched."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID to use. If null, latest Amazon Linux 2023 x86_64 is used via SSM public parameter."
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP to the instance."
  type        = bool
  default     = true
}

variable "key_name" {
  description = "Optional EC2 key pair name."
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "Optional IAM instance profile name."
  type        = string
  default     = null
}

variable "create_security_group" {
  description = "Whether to create and attach a security group in this module."
  type        = bool
  default     = true
}

variable "additional_security_group_ids" {
  description = "Additional security groups to attach to the instance."
  type        = list(string)
  default     = []
}

variable "ssh_ingress_cidrs" {
  description = "CIDR blocks allowed to SSH to the instance on port 22 (used when create_security_group=true)."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "http_ingress_cidrs" {
  description = "CIDR blocks allowed to access the demo HTTP endpoint on port 8080 (used when create_security_group=true)."
  type        = list(string)
  default     = []
}

variable "endpoint_message" {
  description = "Message returned by the demo HTTP endpoint."
  type        = string
  default     = "hello from demo instance"
}

variable "tags" {
  description = "Tags applied to all resources created by this module."
  type        = map(string)
  default     = {}
}
