# vpc module

Creates one standard, single-AZ VPC with:

- 1 public subnet
- 1 private subnet
- 1 Internet Gateway
- 1 NAT Gateway (+ Elastic IP)
- public/private route tables and associations

Use this module multiple times in your root config (for example `vpc_a` and `vpc_b`).

## Example

```hcl
module "vpc_a" {
  source = "./modules/vpc"

  name                = "demo-vpc-a"
  vpc_cidr            = "10.10.0.0/16"
  public_subnet_cidr  = "10.10.1.0/24"
  private_subnet_cidr = "10.10.2.0/24"
  availability_zone   = "us-east-1a"
}

module "vpc_b" {
  source = "./modules/vpc"

  name                = "demo-vpc-b"
  vpc_cidr            = "10.20.0.0/16"
  public_subnet_cidr  = "10.20.1.0/24"
  private_subnet_cidr = "10.20.2.0/24"
  availability_zone   = "us-east-1b"
}
```
