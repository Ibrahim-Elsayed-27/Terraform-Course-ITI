module "network" {
  source = "./network"

  vpc_cidr_block            = var.vpc_cidr_block
  public_subnet_cidr_block  = var.public_subnet_cidr_block
  private_subnet_cidr_block = var.private_subnet_cidr_block
  map_public_ip_on_launch   = var.map_public_ip_on_launch
}

module "database" {
  source = "./database"

  vpc_id                = module.network.vpc_id
  vpc_cidr_block        = var.vpc_cidr_block
  private_subnet_id     = module.network.private_subnet_id
  rds_username          = var.rds_username
  rds_password          = var.rds_password
  rds_allocated_storage = var.rds_allocated_storage
  rds_instance_class    = var.rds_instance_class
  elasticache_node_type = var.elasticache_node_type
}

module "email" {
  source = "./email"

  notification_email = var.notification_email
  s3_bucket_id       = var.s3_bucket_id
  aws_region         = var.infra_region
}
