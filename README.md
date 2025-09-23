# VPC Module for AWS

This Terraform module creates a complete VPC infrastructure with public and private subnets, Internet Gateway, and configurable NAT Gateways.

## Features

- VPC with configurable CIDR block
- 3 public subnets across different availability zones
- 3 private subnets across different availability zones
- Internet Gateway for public subnets
- Configurable number of NAT Gateways (0-3)
- Option for single NAT Gateway or multiple NAT Gateways
- Proper route tables and associations

## Usage

```hcl
module "vpc" {
  source = "./vpc-module"

  region        = "us-east-1"
  vpc_name      = "production-vpc"
  vpc_cidr      = "10.0.0.0/16"
  
  # NAT Gateway configuration
  enable_nat_gateway = true
  nat_gateway_count  = 2
  single_nat_gateway = false

  tags = {
    Environment = "production"
    Project     = "my-app"
  }
}