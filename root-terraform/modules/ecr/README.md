# ECR Module

Creates one private Amazon ECR repository for container images.

## Resources

- `aws_ecr_repository`

## Inputs

| Name | Description |
| --- | --- |
| `name_prefix` | Prefix used for the repository name |
| `environment` | Environment tag value |
| `image_tag_mutability` | `MUTABLE` or `IMMUTABLE` image tags |
| `scan_on_push` | Enables image vulnerability scan on push |

## Outputs

| Name | Description |
| --- | --- |
| `repository_name` | ECR repository name |
| `repository_arn` | ECR repository ARN |
| `repository_url` | ECR repository URL for Docker push/pull |

