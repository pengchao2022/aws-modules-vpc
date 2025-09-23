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
```
## notice

- for a production env , you should give each private subnet one nat gatway
- for a development env , there is no need to give each private subnet one nat gateway, just 1 is okay to save money.

