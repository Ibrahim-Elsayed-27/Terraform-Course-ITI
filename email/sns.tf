
resource "aws_sns_topic" "terraform_state_updates" {
  name   = "terraform-state-updates-topic"
  policy = data.aws_iam_policy_document.topic.json
}

resource "aws_sqs_queue" "sns_dlq" {
  name = "terraform-state-updates-dlq"
}

data "aws_iam_policy_document" "topic" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    actions   = ["SNS:Publish"]
    resources = ["arn:aws:sns:*:*:terraform-state-updates-topic"]
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:s3:::${var.s3_bucket_id}"]
    }
  }
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.s3_bucket_id
  topic {
    topic_arn     = aws_sns_topic.terraform_state_updates.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".tfstate"
  }
  depends_on = [aws_sns_topic.terraform_state_updates]
}

resource "aws_sns_topic_subscription" "lambda_subscription" {
  topic_arn = aws_sns_topic.terraform_state_updates.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.state_update_notifier.arn
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.sns_dlq.arn
  })
}

resource "aws_lambda_permission" "sns_invoke" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.state_update_notifier.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.terraform_state_updates.arn
}

