variable "vpc_id" {
  description = "VPC ID for database resources"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block of the VPC for security group rules"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID for database subnet groups"
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
