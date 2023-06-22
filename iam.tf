# Lambda Roles & Policies
data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "tre_forward_lambda_role" {
  name               = "${var.env}-${var.prefix}-forward-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
  permissions_boundary = var.tre_permission_boundary_arn
}

resource "aws_iam_role_policy_attachment" "tre_forward_lambda_sqs_exec_policy" {
  role       = aws_iam_role.tre_forward_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

resource "aws_iam_role_policy_attachment" "tre_forward_lambda_xray_policy" {
  role       = aws_iam_role.tre_forward_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}

# SQS policies
data "aws_iam_policy_document" "tre_forward_queue" {
  statement {
    actions = ["sqs:SendMessage"]
    effect  = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "sns.amazonaws.com"
      ]
    }
    resources = [
      aws_sqs_queue.tre_forward.arn
    ]
  }
}

data "aws_iam_policy_document" "forward_lambda_kms_sns_policy" {
  statement {
    effect = "Allow"
    actions = [
      "kms:GenerateDataKey",
      "kms:Decrypt"
    ]
    resources = [ var.common_tre_out_topic_kms_arn ]
  }
}

resource "aws_iam_policy" "tre_out_topic_kms" {
  name        = "${var.env}-${var.prefix}-foward-sns-key"
  description = "The KMS SNS key policy for forward lambda"
  policy      = data.aws_iam_policy_document.forward_lambda_kms_sns_policy.json
}

resource "aws_iam_role_policy_attachment" "packer_lambda_key" {
  role       = aws_iam_role.tre_forward_lambda_role.name
  policy_arn = aws_iam_policy.tre_out_topic_kms
}


