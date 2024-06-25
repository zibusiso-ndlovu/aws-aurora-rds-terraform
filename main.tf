provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source = "./modules/vpc"
}

module "bastion" {
  source = "./modules/bastion"
  vpc_id = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_id
}

module "rds" {
  source = "./modules/rds"
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  bastion_security_group_id = module.bastion.security_group_id
}
