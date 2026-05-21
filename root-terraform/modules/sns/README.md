# SNS Module

Creates an SNS topic and optionally connects it to SQS.

## Creates

- SNS topic.
- Optional SQS subscription.
- Optional SQS queue policy that allows SNS to send messages.

## Common Use

Use this module for fan-out messaging and event notifications.

## Important Notes

- The SNS-to-SQS subscription is created only when `enable_sqs_subscription = true`.
- The environment root passes SQS queue ARN and URL into this module.
