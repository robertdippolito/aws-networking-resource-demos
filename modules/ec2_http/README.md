# ec2_http module

Launches an EC2 instance (default `t3.micro`) in a subnet you choose and starts a demo HTTP endpoint on boot.

The endpoint listens on `:8080` and returns:

- `message`
- `hostname`
- `private_ip`

## What this module creates

- `aws_instance`
- optional `aws_security_group` (enabled by default)

## Defaults

- `instance_type = t3.micro`
- latest Amazon Linux 2023 AMI from SSM Parameter Store (unless `ami_id` is set)
- SSH ingress allowed from `0.0.0.0/0` when module SG is enabled
- HTTP ingress on `8080` denied by default until you set `http_ingress_cidrs`

## Example

```hcl
module "app_a" {
  source = "../modules/ec2_http"

  name      = "app-a"
  vpc_id    = module.vpc_a.vpc_id
  subnet_id = module.vpc_a.public_subnet_id

  endpoint_message = "hello from vpc-a"

  http_ingress_cidrs = ["10.20.0.0/16"]

  tags = {
    Project = "vpc-peering-demo"
    Env     = "lab"
  }
}

module "app_b" {
  source = "../modules/ec2_http"

  name      = "app-b"
  vpc_id    = module.vpc_b.vpc_id
  subnet_id = module.vpc_b.public_subnet_id

  endpoint_message = "hello from vpc-b"

  http_ingress_cidrs = ["10.10.0.0/16"]

  tags = {
    Project = "vpc-peering-demo"
    Env     = "lab"
  }
}
```

Then from one instance shell:

```bash
curl http://<other-instance-private-ip>:8080
```
