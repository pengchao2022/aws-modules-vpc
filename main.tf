module "vpc" {
  source = "./modules/vpc"

  region               = var.region
  vpc_name             = var.vpc_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  enable_nat_gateway   = var.enable_nat_gateway
  nat_gateway_count    = var.nat_gateway_count
  single_nat_gateway   = var.single_nat_gateway
  tags                 = var.tags
}