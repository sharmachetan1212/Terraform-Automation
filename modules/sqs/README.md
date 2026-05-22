# SQS Module

Creates an SQS queue.

## Creates

- SQS queue with configurable message retention.

## Common Use

Use this module for decoupling services, background jobs, and asynchronous processing.

## Important Notes

- Dead-letter queue support is not implemented yet.
- SNS can publish to this queue when the SNS-to-SQS integration is enabled.
