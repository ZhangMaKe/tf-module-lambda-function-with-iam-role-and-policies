# tf-module-lambda-function-with-iam

## Overview

This Terraform module creates an IAM Role (and associated policies) and a Lambda function that uses that role. It is intended to simplify creating a Lambda with the exact IAM permissions you need by combining an IAM role+policy module with a Lambda function packaging/deployment module.

Key features:
- Create an IAM role with one or more inline policies (defined by name, actions and resources).
- Create a Lambda function (packaged from a local source directory) and attach the created role.
- Optional SQS Dead-Letter Queue (DLQ) configuration for failed events.
- Attaches any IAM policies provided in input variable precreated_policy_arns to the created role.

## Usage

A minimal example using local variables in your root module:

```hcl
module "lambda_with_iam" {
  source = "./" # or the git URL for this module

  role_name = "my-lambda-role"

  role_policies = [
    {
      name = "lambda-logs"
      actions = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
      resources = ["arn:aws:logs:*:*:*"]
    }
  ]

  source_file = "./lambda-src/main.py"
  output_path = "./build/function.zip"
  function_name = "my-function"
  environment_variables = {
    ENV = "prod"
  }
  use_sqs_dlq = false

  precreated_policy_arns = [dynamo_read_policy = "arn:aws:iam::12345:policy/dynamo-read-policy", dynamo_write_policy = "arn:aws:iam::12345:policy/dynamo-write-policy"]
}
```

## Input Variables

The following input variables are defined for this module:

- `role_name` (string) - The name of the IAM role to create.
- `role_policies` (list(object)) - A list of IAM policy objects. Each object should contain:
  - `name` (string) — policy name
  - `actions` (list(string)) — allowed actions (e.g., ["s3:GetObject", "s3:PutObject"]).
  - `resources` (list(string)) — resource ARNs the policy applies to.
- `source_file` (string) - Path to the file containing the Lambda source code. (optional, either source_file or source_dir must be provided.)
- `source_dir` (string) - Path to the directory containing the Lambda source code. (optional, either source_file or source_dir must be provided.)
- `output_path` (string) - Path to the output ZIP file that will be created when packaging the function.
- `function_name` (string) - Name of the Lambda function.
- `environment_variables` (map(string), default = {}) - Environment variables to set for the Lambda.
- `use_sqs_dlq` (bool, default = false) - When true, creates an SQS queue and configures the Lambda to send failed events to it.
- `precreated_policy_arns` (map(string), default = {}) - A list of existing IAM policy ARNs to attach to the role.

Example `role_policies` value:

```hcl
role_policies = [
  {
    name = "example-policy"
    actions = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["arn:aws:logs:*:*:*"]
  }
]
```

## Outputs

The module exposes these outputs:

- `role_arn` - The ARN of the created IAM role.
- `policy_arns` - A list of ARNs for the created IAM policies.
- `policy_ids` - A list of IDs for the created IAM policies.
- `function_arn` - The ARN of the created Lambda function.
- `invoke_arn` - The invoke ARN of the Lambda function.
- `function_name` - The name of the Lambda function.
- `sqs_dlq_arn` - ARN of the SQS Dead Letter Queue (if created).
- `sqs_dlq_url` - URL of the SQS Dead Letter Queue (if created).

## Requirements

- Terraform 0.12+ (or newer). Ensure provider versions are pinned in your root module as needed.

## Authors

- ZhangMaKe (repository owner)

## Notes

- This module delegates IAM policy and Lambda packaging/deployment to submodules. Review both submodules to understand how they package code, handle state, and create policies.
- Before using in production, review policies carefully and restrict resources and actions to the minimum required (principle of least privilege).
