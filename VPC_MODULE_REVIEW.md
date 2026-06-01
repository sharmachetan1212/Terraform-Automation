# VPC Module Review

Date: 2026-06-02

## Focus

Week 2 Day 9: inspect `modules/vpc` and document inputs, resources, outputs, subnet behavior, and public IP behavior.

## What This Module Does

The VPC module creates the base network that other Terraform modules can use.

It creates:

- One VPC.
- One or more subnets.
- An internet gateway when public subnet behavior is enabled.
- A public route table when public subnet behavior is enabled.
- Route table associations for each public subnet.

This module is used by `envs/dev` when:

```hcl
enable_vpc = true
```

## Input Variables

| Variable | Purpose |
| --- | --- |
| `name` | Base name used for the VPC and related resource tags. |
| `environment` | Environment tag, such as `dev`. |
| `cidr_block` | Main IP range for the VPC, such as `10.10.0.0/16`. |
| `subnet_count` | Number of subnets to create. Default is `2`. |
| `map_public_ip_on_launch` | Controls whether new instances launched in the subnets get public IPs by default. Default is `true`. |

## Resource Flow

The module flow is:

```text
aws_vpc.this
  -> data.aws_availability_zones.available
  -> aws_subnet.this
  -> aws_internet_gateway.this
  -> aws_route_table.public
  -> aws_route_table_association.public
```

## VPC

The module creates one VPC:

```hcl
resource "aws_vpc" "this"
```

Important settings:

- `cidr_block` comes from `var.cidr_block`.
- DNS hostnames are enabled.
- DNS support is enabled.
- Tags include `Name` and `Environment`.

DNS support matters because later services often need DNS names to resolve correctly inside the VPC.

## Subnets

The module creates subnets with:

```hcl
resource "aws_subnet" "this" {
  count = var.subnet_count
}
```

If `subnet_count = 2`, Terraform creates:

```text
aws_subnet.this[0]
aws_subnet.this[1]
```

Each subnet gets:

- The VPC ID from `aws_vpc.this.id`.
- A calculated CIDR block using `cidrsubnet(...)`.
- An availability zone selected by index.
- Public IP behavior from `var.map_public_ip_on_launch`.

## CIDR Behavior

The subnet CIDR is calculated with:

```hcl
cidrsubnet(var.cidr_block, 8, count.index + 1)
```

This means Terraform divides the VPC CIDR into smaller subnet CIDRs.

For example, if the VPC CIDR is:

```text
10.10.0.0/16
```

then the module creates smaller subnet ranges from that network.

The important idea:

```text
VPC CIDR = large network range
Subnet CIDR = smaller range inside the VPC
```

## Availability Zone Behavior

The module reads available availability zones:

```hcl
data "aws_availability_zones" "available"
```

Then each subnet uses:

```hcl
availability_zone = data.aws_availability_zones.available.names[count.index]
```

This spreads subnets by index across available zones.

Example:

```text
subnet 1 -> first available AZ
subnet 2 -> second available AZ
```

## Public IP And Internet Behavior

Public subnet behavior is controlled by:

```hcl
map_public_ip_on_launch
```

When `map_public_ip_on_launch = true`, the module also creates:

- Internet gateway.
- Public route table.
- Route to `0.0.0.0/0`.
- Route table associations for each subnet.

The route:

```hcl
cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.this[0].id
```

means outbound internet traffic can leave through the internet gateway.

When `map_public_ip_on_launch = false`, the internet gateway, public route table, and route table associations are not created because their `count` values become `0`.

## Outputs

The module exposes:

| Output | Purpose |
| --- | --- |
| `vpc_id` | Lets other modules attach resources to this VPC. |
| `subnet_ids` | Lets other modules place resources into the created subnets. |

These outputs are used by environment-level code such as `envs/dev/main.tf`:

```hcl
vpc_id     = var.enable_vpc ? module.vpc[0].vpc_id : var.existing_vpc_id
subnet_ids = var.enable_vpc ? module.vpc[0].subnet_ids : var.existing_subnet_ids
```

## How Other Modules Use It

The VPC module is a foundation for:

- EC2: needs VPC ID and subnet ID.
- ALB: needs VPC ID and subnet IDs.
- RDS: needs VPC ID and subnet IDs.

Current dev flow:

```text
module.vpc
  -> vpc_id
  -> subnet_ids
  -> module.ec2
```

## Important Observations

- This is a simple public-subnet VPC module.
- Private subnets are not implemented yet.
- NAT gateway support is not implemented yet.
- `subnet_count` should not be higher than the number of available AZs used by index.
- `map_public_ip_on_launch = true` is useful for demos, but production designs usually separate public and private subnets.

## My Understanding

The VPC module creates the network base. It takes a large CIDR block, creates smaller subnet CIDRs, places those subnets across availability zones, and optionally makes them public by adding an internet gateway and route table.

## Next Improvement

For Day 10, inspect the EC2 module and document AMI, instance type, key pair, security group, SSH CIDR rules, and how EC2 receives VPC/subnet values.
