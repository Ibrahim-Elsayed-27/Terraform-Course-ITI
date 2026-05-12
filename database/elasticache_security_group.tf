# ElastiCache Security Group
resource "aws_security_group" "elasticache_security_group" {
  name        = "elasticache-security-group"
  description = "Security group for ElastiCache Redis"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_redis_from_vpc" {
  security_group_id = aws_security_group.elasticache_security_group.id
  cidr_ipv4         = var.vpc_cidr_block
  from_port         = 6379
  ip_protocol       = "tcp"
  to_port           = 6379
  description       = "Allow Redis from VPC"
}

resource "aws_vpc_security_group_egress_rule" "elasticache_allow_all_outbound" {
  security_group_id = aws_security_group.elasticache_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic"
}
