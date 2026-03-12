# cloudwan module

Creates a minimal AWS CloudWAN foundation for demos:

- `aws_networkmanager_global_network`
- `aws_networkmanager_core_network`
- `aws_networkmanager_core_network_policy_attachment`

The module applies a simple base policy with:

- one segment (default: `shared`)
- listed edge locations
- one attachment policy that associates attachments with tag `Segment=shared` into the shared segment

## Example

```hcl
module "cloudwan" {
  source = "../../modules/cloudwan"

  name           = "demo-cloudwan"
  edge_locations = ["us-east-1", "us-west-2"]

  tags = {
    Project = "cloudwan-demo"
    Env     = "lab"
  }
}
```
