# ElastiCache Subnet Group
resource "aws_elasticache_subnet_group" "elasticache_subnet" {
  name       = "my-cache-subnet"
  subnet_ids = [var.private_subnet_id]
}

# ElastiCache Cluster
resource "aws_elasticache_cluster" "elasticache_cluster" {
  cluster_id           = "cluster-example"
  engine               = "redis"
  node_type            = var.elasticache_node_type
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.elasticache_subnet.name
  security_group_ids   = [aws_security_group.elasticache_security_group.id]
}
