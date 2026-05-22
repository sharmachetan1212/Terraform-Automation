# RDS Module

Creates a private MySQL RDS database instance.

## Creates

- RDS security group allowing MySQL from the VPC CIDR.
- DB subnet group.
- MySQL RDS instance.

## Common Use

Use this module when the client needs a managed relational database.

## Important Notes

- Current configuration is non-HA by default because Multi-AZ is not enabled.
- The database is not publicly accessible.
- `skip_final_snapshot = true` is convenient for demos but should be reviewed before production use.
- Store real passwords in a secret manager workflow instead of plain tfvars.
