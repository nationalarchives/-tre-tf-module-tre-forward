# TRE-Forward Lambda

resource "aws_lambda_function" "tre_forward" {
  image_uri     = "${var.ecr_uri_host}${var.ecr_uri_repo_prefix}${var.prefix}-forward:${var.forward_image_versions.tre_forward}"
  package_type  = "Image"
  function_name = "${var.env}-${var.prefix}-forward"
  role          = aws_iam_role.tre_forward_lambda_role.arn
  timeout       = 30
  environment {
    variables = {
      "TRE_OUT_TOPIC_ARN" = var.tre_out_topic_arn
    }
  }
  tracing_config {
    mode = "Active"
  }

  tags = {
    "ApplicationType" = "Python"
  }
}

resource "aws_lambda_event_source_mapping" "tre_forward_sqs" {
  batch_size                         = 1
  function_name                      = aws_lambda_function.tre_forward.function_name
  event_source_arn                   = aws_sqs_queue.tre_forward.arn
  maximum_batching_window_in_seconds = 0
}
