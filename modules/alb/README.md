# ALB Module

Creates an internet-facing Application Load Balancer for HTTP traffic.

## Creates

- ALB security group allowing inbound HTTP.
- Application Load Balancer across the provided subnets.
- HTTP target group.
- HTTP listener on port `80`.
- Optional EC2 target attachment when `target_instance_id` is provided.

## Common Use

Use this module when a client wants a production-style web entry point in front of EC2 or a future Auto Scaling Group.

## Important Notes

- Requires at least two subnets for a normal production ALB setup.
- For public access, the subnets need internet routing.
- This module does not create HTTPS yet. Add ACM and an HTTPS listener later.
