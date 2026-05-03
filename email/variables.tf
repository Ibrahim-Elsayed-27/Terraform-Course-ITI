variable "notification_email" {
  description = "Email address to send notifications to"
  type        = string
}

variable "s3_bucket_id" {
  description = "ID of the S3 bucket for statefile storage"
  type        = string
}

variable "aws_region" {
  description = "AWS region for SES and other services"
  type        = string
}
