# S3 Module

Creates a private S3 bucket.

## Creates

- S3 bucket.
- Public access block.

## Common Use

Use this module for object storage, backups, static assets, artifacts, or data lake foundations.

## Important Notes

- Bucket names must be globally unique.
- If `bucket_name` is null, the module builds a name with the AWS account ID.
- Public access is blocked by default.
