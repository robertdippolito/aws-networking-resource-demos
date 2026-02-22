# transit-gateway-demo

Creates 4 VPCs, 4 EC2 demo instances, a Transit Gateway, and routes between all VPC CIDRs through the TGW.

## Demo workflow

1. Apply VPC + EC2 modules only to show no cross-VPC connectivity.
2. Apply TGW module and TGW routes to show full connectivity between all four VPCs.

### Step 1: no TGW connectivity

```bash
terraform apply \
  -target=module.vpc_a \
  -target=module.vpc_b \
  -target=module.vpc_c \
  -target=module.vpc_d \
  -target=module.app_a \
  -target=module.app_b \
  -target=module.app_c \
  -target=module.app_d
```

### Step 2: add TGW connectivity

```bash
terraform apply \
  -target=module.tgw \
  -target=aws_route.to_tgw
```

### Optional: full converge

```bash
terraform apply
```
