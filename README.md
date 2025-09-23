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
you also need to write a variables.tf and terraform.tfvars file to put your real value or customize values.

```terraform
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
  "10.0.101.0/24",
  "10.0.102.0/24",
  "10.0.103.0/24"
]

availability_zones = [
  "us-east-1a",
  "us-east-1b",
  "us-east-1c"
]

enable_nat_gateway = true
nat_gateway_count  = 1
single_nat_gateway = true

tags = {
  Environment = "production"
  Project     = "CMS payment"
  Team        = "devops"
}

```


## notice

- for a production env , you should give each private subnet one nat gatway
- for a development env , there is no need to give each private subnet one nat gateway, just 1 is okay to save money.

