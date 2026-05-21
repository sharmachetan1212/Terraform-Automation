# CloudWatch Module

Creates a CloudWatch log group.

## Creates

- CloudWatch log group with configurable retention.

## Common Use

Use this module when a client wants explicit log group creation and retention control.

## Important Notes

- Lambda can create log groups automatically, but this module lets Terraform manage retention.
