# Basic VPC configuration with default values
region   = "us-east-1"
vpc_name = "prod-vpc-1"
vpc_cidr = "10.0.0.0/16"

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24",
  "10.0.3.0/24"
]

private_subnet_cidrs = [
  "10.0.11.0/24",
  "10.0.12.0/24",
  "10.0.13.0/24"
]

enable_nat_gateway = true
nat_gateway_count  = 1
single_nat_gateway = true

tags = {
  Environment = "production"
  Project     = "CMS payment"
  Team        = "devops"
}
