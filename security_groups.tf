resource "aws_security_group" "allow_ssh_only" {
  name        = "allow_ssh_only"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main_vpc.id

}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_ssh_only.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}



resource "aws_security_group" "allow_ssh_and_3000_local" {
  name        = "allow_ssh_and_3000_local"
  description = "allow_ssh_and_3000_local"
  vpc_id      = aws_vpc.main_vpc.id

}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4_local" {
  security_group_id = aws_security_group.allow_ssh_and_3000_local.id
  cidr_ipv4         = aws_vpc.main_vpc.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}



resource "aws_vpc_security_group_ingress_rule" "allow_port_3000_ipv4_local" {
  security_group_id = aws_security_group.allow_ssh_and_3000_local.id
  cidr_ipv4         = aws_vpc.main_vpc.cidr_block
  from_port         = 3000
  ip_protocol       = "tcp"
  to_port           = 3000
}
