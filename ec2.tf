resource "aws_instance" "bastion" {
  ami                    = "ami-09fc5668766215f32"
  instance_type          = "t3.micro"
  subnet_id              = module.network.public_subnet_id
  vpc_security_group_ids = [aws_security_group.allow_ssh_only.id]


}
resource "null_resource" "bastion_ip" {
  provisioner "local-exec" {
    command = "echo ${aws_instance.bastion.public_ip}"
  }
}


resource "aws_instance" "application" {
  ami                    = "ami-09fc5668766215f32"
  instance_type          = "t3.micro"
  subnet_id              = module.network.private_subnet_id
  vpc_security_group_ids = [aws_security_group.allow_ssh_and_3000_local.id]
}

