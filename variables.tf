variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr_block" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "private_subnet_cidr_block" {
  description = "CIDR block for the private subnet"
  type        = string
}

variable "map_public_ip_on_launch" {
  description = "Whether to map public IP on launch for public subnet"
  type        = bool
}


variable "infra_region" {
  description = "Whether to map public IP on launch for public subnet"
  type        = string
}

variable "notification_email" {
  description = "Email address for statefile update notifications"
  type        = string
}

variable "s3_bucket_id" {
  description = "ID of the S3 bucket for statefile storage"
  type        = string
}
