output "tre_forward_queue_arn" {
  value       = aws_sqs_queue.tre_forward.arn
  description = "TRE Forward SQS Queue ARN"
}

output "tre_forward_lambda_arn" {
  value       = aws_iam_role.tre_forward_lambda_role.arn
  description = "TRE Forward Lambda Role ARN"
}
