variable "env" {
  description = "Name of the environment to deploy"
  type        = string
}

variable "prefix" {
  description = "Transformation Engine prefix"
  type        = string
}

variable "account_id" {
  description = "Account ID where Image for the Lambda function will be"
  type        = string
}

variable "tre_out_topic_arn" {
  description = "ARN of the tre-out sns topic"
  type = string
}

variable "tre_dlq_alerts_lambda_function_name" {
  description = "TRE DLQ Alerts Lambda Function Name"
  type        = string
}

variable "forward_version" {
  description = "(Updates if Common TRE Lambda function versions change)"
  type        = string
}
variable "forward_image_versions" {
  description = "Latest version of Images for Lambda Functions"
  type = object({
    tre_forward     = string
  })
}

variable "var.tre_permission_boundary_arn" {
  description = "ARN of the TRE permission boundary policy"
  type = string
}
