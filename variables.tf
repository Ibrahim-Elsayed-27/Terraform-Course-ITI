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

variable "rds_username" {
  description = "Master username for RDS database"
  type        = string
  sensitive   = true
}

variable "rds_password" {
  description = "Master password for RDS database"
  type        = string
  sensitive   = true
}

variable "rds_allocated_storage" {
  description = "Allocated storage for RDS instance in GB"
  type        = number
  default     = 10
}

variable "rds_instance_class" {
  description = "Instance class for RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "elasticache_node_type" {
  description = "Node type for ElastiCache cluster"
  type        = string
  default     = "cache.t3.micro"
}
