resource "aws_ses_email_identity" "notification_email" {
  email = var.notification_email
}