# EC2 Module Review

## Focus

Week 2 Day 10 review of `root-terraform/modules/ec2`: AMI, instance type, key pair, security group, SSH CIDR rules, and VPC/subnet inputs.

## Files Reviewed

- `modules/ec2/main.tf`
- `modules/ec2/variables.tf`
- `modules/ec2/outputs.tf`
- `envs/dev/non-ha.tf`

## What The Module Creates

The EC2 module creates two AWS resources:

- `aws_security_group.this`
- `aws_instance.this`

The module is intentionally simple and non-HA. It creates one instance in one subnet and attaches one security group to that instance.

## Inputs

| Input | Purpose |
| --- | --- |
| `name` | Used for the EC2 instance name tag and security group name. |
| `environment` | Adds an environment tag to the instance and security group. |
| `ami_id` | Selects the Amazon Machine Image used to boot the instance. |
| `instance_type` | Selects the compute size, such as CPU and memory class. |
| `key_name` | Optional SSH key pair name. Defaults to `null`. |
| `vpc_id` | VPC where the security group is created. |
| `subnet_id` | Subnet where the instance is launched. Defaults to `null`. |
| `allowed_ssh_cidr_blocks` | CIDR ranges allowed to reach SSH on port 22. |

## Security Group Behavior

The security group allows inbound SSH:

```text
TCP 22 from var.allowed_ssh_cidr_blocks
```

It allows all outbound traffic:

```text
All protocols to 0.0.0.0/0
```

The default SSH CIDR is currently `0.0.0.0/0`, which is useful for a demo but too open for a real environment. For safer practice, `allowed_ssh_cidr_blocks` should be set to a trusted IP range in `terraform.tfvars`.

## Instance Behavior

The instance uses:

- `var.ami_id` for the image.
- `var.instance_type` for the size.
- `var.key_name` for SSH key access.
- `var.subnet_id` for placement.
- `aws_security_group.this.id` for network access rules.

Tags are applied for `Name`, `Environment`, and `Service`.

## Dev Environment Wiring

`envs/dev/non-ha.tf` calls the module only when `enable_ec2 = true`.

The dev environment passes:

- `ami_id = var.ami_id`
- `instance_type = var.instance_type`
- `key_name = var.key_name`
- `vpc_id = local.vpc_id`
- `subnet_id = length(local.subnet_ids) > 0 ? local.subnet_ids[0] : null`
- `allowed_ssh_cidr_blocks = var.allowed_ssh_cidr_blocks`

This means EC2 depends on the environment network selection logic. It can use a newly created VPC from `module.vpc` or an existing VPC supplied through environment variables, depending on the feature flag configuration.

## Outputs

The module exposes:

- `instance_id`
- `name`
- `public_ip`
- `private_ip`
- `security_group_id`

These outputs let other environment files connect to the EC2 instance. For example, the ALB path can use the EC2 instance ID and security group ID when both EC2 and ALB are enabled.

## Observations

- The module is clear and easy to trace.
- The security group is scoped to SSH only for ingress, but the default SSH CIDR is open to the internet.
- `subnet_id` defaults to `null`, but a real EC2 instance should receive a valid subnet from the environment.
- The module creates one instance only. Auto Scaling is not part of this module.

## Next Step

Continue Week 2 Day 11 by reviewing S3 and DynamoDB modules. Focus on naming, deletion safety, encryption, billing mode, keys, and outputs.
