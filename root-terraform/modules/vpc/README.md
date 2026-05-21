# VPC Module

Creates the base network used by compute and database services.

## Creates

- VPC with DNS support enabled.
- One or more subnets.
- Internet gateway when `map_public_ip_on_launch = true`.
- Public route table and subnet associations when public subnets are enabled.

## Common Use

Enable this module when the client does not already have a VPC.

## Important Notes

- Current subnets are simple public-style subnets when `map_public_ip_on_launch = true`.
- Private subnet and NAT gateway support are not implemented yet.
- EC2, ALB, and RDS can also use an existing VPC through environment variables.
