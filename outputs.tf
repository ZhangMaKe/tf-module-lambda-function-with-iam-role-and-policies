output "role_arn" {
  description = "The arn of the created IAM role."
  value = module.iam_role_and_policy.role_arn
}

output "policy_arns" {
  description = "A list of the ARNs of the created IAM policies."
  value = module.iam_role_and_policy.policy_arns
}

output "policy_ids" {
  description = "A list of the IDs of the created IAM policies."
  value = module.iam_role_and_policy.policy_ids
}

output "function_arn" {
  value = module.lambda_function.function_arn
  description = "The ARN of the Lambda function"
}

output "invoke_arn" {
  value = module.lambda_function.invoke_arn
  description = "The Invoke ARN of the Lambda function"
}

output "function_name" {
  value = module.lambda_function.function_name
  description = "The name of the function"
}

output "sqs_dlq_arn" {
  value = module.lambda_function.sqs_dlq_arn
  description = "ARN of the SQS Dead Letter Queue for failed events, if created."
}

output "sqs_dlq_url" {
  value = module.lambda_function.sqs_dlq_url
  description = "URL of the SQS Dead Letter Queue for failed events, if created."
}
