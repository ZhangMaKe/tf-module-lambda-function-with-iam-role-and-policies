module "iam_role_and_policy" {
  source = "git::https://github.com/ZhangMaKe/tf-module-iam-role-and-policy.git?ref=v1.1.1"
  role_name = "${var.role_name}"
  service_assuming_role = "lambda.amazonaws.com"
  role_policies = var.role_policies
  precreated_policy_arns = var.precreated_policy_arns
}

module "lambda_function" {
  source = "git::https://github.com/ZhangMaKe/tf-module-lambda-function.git?ref=v1.3.0"
  source_file = var.source_file != null ? var.source_file : null
  source_dir = var.source_dir != null ? var.source_dir : null
  output_path = var.output_path
  function_name = var.function_name
  role_arn = module.iam_role_and_policy.role_arn
  environment_variables = var.environment_variables
  use_sqs_dlq = var.use_sqs_dlq
}