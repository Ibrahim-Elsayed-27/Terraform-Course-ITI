output "rds_endpoint" {
  description = "RDS database endpoint"
  value       = module.database.rds_endpoint
}

output "rds_address" {
  description = "RDS database address (hostname)"
  value       = module.database.rds_address
}

output "rds_port" {
  description = "RDS database port"
  value       = module.database.rds_port
}

output "rds_database_name" {
  description = "RDS database name"
  value       = module.database.rds_database_name
}

output "rds_username" {
  description = "RDS master username"
  value       = module.database.rds_username
  sensitive   = true
}

output "elasticache_endpoint" {
  description = "ElastiCache cluster endpoint"
  value       = module.database.elasticache_endpoint
}

output "elasticache_port" {
  description = "ElastiCache cluster port"
  value       = module.database.elasticache_port
}

output "elasticache_cluster_id" {
  description = "ElastiCache cluster ID"
  value       = module.database.elasticache_cluster_id
}

output "rds_security_group_id" {
  description = "RDS security group ID"
  value       = module.database.rds_security_group_id
}

output "elasticache_security_group_id" {
  description = "ElastiCache security group ID"
  value       = module.database.elasticache_security_group_id
}
