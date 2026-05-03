resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

}


resource "aws_route_table_association" "public_route_association" {
  subnet_id      = aws_subnet.main_public_subnet.id
  route_table_id = aws_route_table.public_route.id
}
