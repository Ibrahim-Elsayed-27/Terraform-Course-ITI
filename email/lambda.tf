data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda_function.zip"
  source {
    content  = <<EOF
import json
import boto3
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    # Parse the SNS message containing S3 event
    for record in event['Records']:
        sns_message = json.loads(record['Sns']['Message'])
        # S3 event structure
        if 'Records' in sns_message:
            for s3_record in sns_message['Records']:
                event_name = s3_record['eventName']
                bucket_name = s3_record['s3']['bucket']['name']
                object_key = s3_record['s3']['object']['key']
                object_size = s3_record['s3']['object']['size']
                
                change_details = f"Event: {event_name}, Bucket: {bucket_name}, Key: {object_key}, Size: {object_size} bytes"
        else:
            change_details = sns_message.get('change_details', 'No details provided')
        
        # Send email
        ses_client = boto3.client('ses', region_name='${var.aws_region}')
        try:
            response = ses_client.send_email(
                Source='${var.notification_email}',
                Destination={
                    'ToAddresses': ['${var.notification_email}']
                },
                Message={
                    'Subject': {
                        'Data': 'Terraform Statefile Update Notification'
                    },
                    'Body': {
                        'Text': {
                            'Data': f'An update has happened to the statefile. Details: {change_details}'
                        }
                    }
                }
            )
        except ClientError as e:
            print(e.response['Error']['Message'])
        else:
            print("Email sent! Message ID:", response['MessageId'])
EOF
    filename = "lambda_function.py"
  }
}

resource "aws_lambda_function" "state_update_notifier" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "state-update-notifier"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-ses-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda-ses-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ses:SendEmail"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogItems"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}
