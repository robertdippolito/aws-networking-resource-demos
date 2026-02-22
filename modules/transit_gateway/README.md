# transit_gateway module

Creates one AWS Transit Gateway, optional route table, and VPC attachments.

## What this module creates

- `aws_ec2_transit_gateway`
- `aws_ec2_transit_gateway_vpc_attachment` (one per entry in `vpc_attachments`)
- optional `aws_ec2_transit_gateway_route_table`
- optional TGW route table associations and propagations for all attachments

## Example

```hcl
module "tgw" {
  source = "../../modules/transit_gateway"

  name = "demo-tgw"

  vpc_attachments = {
    vpc_a = {
      vpc_id     = module.vpc_a.vpc_id
      subnet_ids = [module.vpc_a.private_subnet_id]
    }
    vpc_b = {
      vpc_id     = module.vpc_b.vpc_id
      subnet_ids = [module.vpc_b.private_subnet_id]
    }
  }

  tags = {
    Project = "tgw-demo"
    Env     = "lab"
  }
}
```
