# RDS Security Group
resource "aws_security_group" "rds_security_group" {
  name        = "rds-security-group"
  description = "Security group for RDS database"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_mysql_from_vpc" {
  security_group_id = aws_security_group.rds_security_group.id
  cidr_ipv4         = var.vpc_cidr_block
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
  description       = "Allow MySQL from VPC"
}

resource "aws_vpc_security_group_egress_rule" "rds_allow_all_outbound" {
  security_group_id = aws_security_group.rds_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic"
}
