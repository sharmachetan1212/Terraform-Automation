# EC2 Module

Creates a single EC2 instance for simple server workloads.

## Creates

- EC2 security group.
- EC2 instance.

## Common Use

Use this module for demos, test servers, jump hosts, or simple non-HA workloads.

## Important Notes

- This is a single instance, not an Auto Scaling Group.
- SSH access is controlled by `allowed_ssh_cidr_blocks`.
- Application traffic from ALB is allowed from the environment root when both `enable_ec2` and `enable_alb` are true.
