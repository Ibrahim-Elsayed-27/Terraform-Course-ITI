resource "aws_instance" "public_instance" {
  ami                    = "ami-09fc5668766215f32"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.main_public_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ssh_only.id]
}



resource "aws_instance" "private_instance" {
  ami                    = "ami-09fc5668766215f32"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.main_private_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ssh_and_3000_local.id]
}
