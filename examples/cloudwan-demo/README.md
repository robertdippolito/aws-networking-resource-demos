# cloudwan-demo

Creates a basic cross-region CloudWAN topology:

- VPC A in `region_a` (default `us-east-1`)
- VPC B in `region_b` (default `us-west-2`)
- One EC2 demo endpoint per VPC
- CloudWAN global network and core network
- One VPC attachment per region
- VPC route entries that send inter-VPC traffic to CloudWAN

## Demo workflow

1. Apply VPC + EC2 only to show no cross-region private connectivity.
2. Apply CloudWAN resources and routes to show connectivity.

### Step 1: no CloudWAN path

```bash
terraform apply \
  -target=module.vpc_a \
  -target=module.vpc_b \
  -target=module.app_a \
  -target=module.app_b
```

### Step 2: add CloudWAN path

```bash
terraform apply \
  -target=module.cloudwan \
  -target=aws_networkmanager_vpc_attachment.vpc_a \
  -target=aws_networkmanager_vpc_attachment.vpc_b \
  -target=aws_route.vpc_a_public_to_cloudwan \
  -target=aws_route.vpc_a_private_to_cloudwan \
  -target=aws_route.vpc_b_public_to_cloudwan \
  -target=aws_route.vpc_b_private_to_cloudwan
```

### Optional: full converge

```bash
terraform apply
```

## Validate

Use the instance public IPs for SSH and curl the opposite instance private IP on port `8080`.

## Destroy

```bash
terraform destroy
```
