# vpc_peering module

Creates one VPC peering connection and installs routes in both directions.

## What this module creates

- `aws_vpc_peering_connection`
- `aws_route` entries in requester route table(s) to accepter CIDR
- `aws_route` entries in accepter route table(s) to requester CIDR

## Example

```hcl
module "peering" {
  source = "../modules/vpc_peering"

  name = "demo-a-b-peering"

  requester_vpc_id   = module.vpc_a.vpc_id
  accepter_vpc_id    = module.vpc_b.vpc_id
  requester_vpc_cidr = module.vpc_a.vpc_cidr
  accepter_vpc_cidr  = module.vpc_b.vpc_cidr

  requester_route_table_ids = [
    module.vpc_a.public_route_table_id,
    module.vpc_a.private_route_table_id,
  ]

  accepter_route_table_ids = [
    module.vpc_b.public_route_table_id,
    module.vpc_b.private_route_table_id,
  ]

  tags = {
    Project = "vpc-peering-demo"
    Env     = "lab"
  }
}
```
