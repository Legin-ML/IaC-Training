module "vpc" {
  source             = "./modules/vpc"
  prefix             = var.prefix
  enable_igw         = var.enable_igw
  enable_nat_gateway = var.enable_nat_gateway
  cidr_block         = var.cidr_block
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
}

module "rds" {
  source              = "./modules/rds"
  prefix              = var.prefix
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnet_ids
  username            = var.db_username
  password            = var.db_password
  allowed_security_groups = [ module.asg.app_sg_id ]
}

module "asg" {
  source           = "./modules/asg"
  prefix           = var.prefix
  db_host          = module.rds.db_endpoint
  db_username      = var.db_username
  db_password      = var.db_password
  db_port          = module.rds.db_port
  db_name          = module.rds.db_name
  private_subnets  = module.vpc.private_subnet_ids
  subnets          = module.vpc.public_subnet_ids
  vpc_id           = module.vpc.vpc_id
  desired_capacity = var.desired_capacity
}