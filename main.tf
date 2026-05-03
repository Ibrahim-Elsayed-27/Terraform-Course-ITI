module "network" {
  source = "./network"

  vpc_cidr_block            = var.vpc_cidr_block
  public_subnet_cidr_block  = var.public_subnet_cidr_block
  private_subnet_cidr_block = var.private_subnet_cidr_block
  map_public_ip_on_launch   = var.map_public_ip_on_launch
}

module "email" {
  source = "./email"

  notification_email = var.notification_email
  s3_bucket_id       = var.s3_bucket_id
  aws_region         = var.infra_region
}
