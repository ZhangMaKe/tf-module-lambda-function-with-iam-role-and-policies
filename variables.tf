variable "role_name" {
    type = string
    description = "The name of the iam role to create."
}

variable "role_policies" {
  type = list(object({
    name = string
    actions = list(string)
    resources = list(string)
  }))
  description = "A list of iam policy objects containing name, actions, and resources, specifying the permissions to be given to the role."
}

variable "source_file" {
  type = string
  description = "path to directory containing the source code (optional, either source_file or source_dir must be provided.)"
  default = null
}

variable "source_dir" {
  type = string
  description = "path to directory containing the source code and dependencies (optional, either source_file or source_dir must be provided.)"
  default = null
}

variable "output_path" {
  type = string
  description = "path to the output zip file"  
}

variable "function_name" {
  type = string
  description = "name of the Lambda function"
}

variable "environment_variables" {
  type = map(string)
  default = {}
  description = "Environment variables for the Lambda function"
}

variable "use_sqs_dlq" {
  type = bool
  default = false
  description = "boolean, if true creates an sqs queue and configures failed events to be sent to it."
}
