resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = var.vpc_cidr_block
    gateway_id = "local" # Matches the default AWS route
  }
}
