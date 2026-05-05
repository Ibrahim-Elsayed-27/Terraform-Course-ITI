# RDS Subnet Group
resource "aws_db_subnet_group" "db_subnet" {
  name       = "my-db-subnet"
  subnet_ids = [var.private_subnet_id]

  tags = {
    Name = "my-db-subnet-group"
  }
}

# RDS Instance
resource "aws_db_instance" "default" {
  allocated_storage      = var.rds_allocated_storage
  db_name                = "mydb"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.rds_instance_class
  username               = var.rds_username
  password               = var.rds_password
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
}
