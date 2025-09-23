module "vpc" {
  source = "./modules/vpc"

  region   = "us-east-1"
  vpc_name = "production-vpc"
  vpc_cidr = "10.0.0.0/16"

  # NAT Gateway configuration
  enable_nat_gateway = true
  nat_gateway_count  = 2
  single_nat_gateway = false

  tags = {
    Environment = "production"
    Project     = "my-app"
  }
}