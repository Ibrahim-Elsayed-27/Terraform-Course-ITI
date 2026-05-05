output "rds_endpoint" {
  description = "RDS database endpoint"
  value       = aws_db_instance.default.endpoint
}

output "rds_address" {
  description = "RDS database address (hostname)"
  value       = aws_db_instance.default.address
}

output "rds_port" {
  description = "RDS database port"
  value       = aws_db_instance.default.port
}

output "rds_database_name" {
  description = "RDS database name"
  value       = aws_db_instance.default.db_name
}

output "rds_username" {
  description = "RDS master username"
  value       = aws_db_instance.default.username
  sensitive   = true
}

output "rds_security_group_id" {
  description = "RDS security group ID"
  value       = aws_security_group.rds_security_group.id
}

output "elasticache_endpoint" {
  description = "ElastiCache cluster endpoint"
  value       = aws_elasticache_cluster.elasticache_cluster.cache_nodes[0].address
}

output "elasticache_port" {
  description = "ElastiCache cluster port"
  value       = aws_elasticache_cluster.elasticache_cluster.port
}

output "elasticache_cluster_id" {
  description = "ElastiCache cluster ID"
  value       = aws_elasticache_cluster.elasticache_cluster.cluster_id
}

output "elasticache_security_group_id" {
  description = "ElastiCache security group ID"
  value       = aws_security_group.elasticache_security_group.id
}
