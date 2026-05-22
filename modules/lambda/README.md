# Lambda Module

Creates a basic Python Lambda function.

## Creates

- Inline Python source archive.
- Lambda IAM execution role.
- AWS managed basic execution policy attachment.
- Lambda function.

## Common Use

Use this module for serverless compute demos or as a base for event-driven workloads.

## Important Notes

- The function code is a small inline demo handler.
- CloudWatch logging permission is attached through `AWSLambdaBasicExecutionRole`.
- Event triggers such as SQS, SNS, API Gateway, or EventBridge are not implemented yet.
