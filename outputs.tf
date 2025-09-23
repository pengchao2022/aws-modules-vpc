# Core Resources
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr_block
}

# Subnets
output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

# Gateways
output "internet_gateway_id" {
  value = module.vpc.internet_gateway_id
}

output "nat_gateway_ids" {
  value = module.vpc.nat_gateway_ids
}

# Route Tables
output "public_route_table_id" {
  value = module.vpc.public_route_table_id
}

output "private_route_table_ids" {
  value = module.vpc.private_route_table_ids
}

# Summary Outputs
output "network_summary" {
  value = {
    vpc_id   = module.vpc.vpc_id
    vpc_cidr = module.vpc.vpc_cidr_block
    subnets = {
      public  = length(module.vpc.public_subnet_ids)
      private = length(module.vpc.private_subnet_ids)
    }
    nat_gateways = length(module.vpc.nat_gateway_ids)
    azs_used     = module.vpc.availability_zones_used
  }
}

output "subnet_details" {
  value = {
    public_subnets = zipmap(
      module.vpc.public_subnet_ids,
      module.vpc.public_subnet_cidr_blocks
    )
    private_subnets = zipmap(
      module.vpc.private_subnet_ids,
      module.vpc.private_subnet_cidr_blocks
    )
  }
}

# Remove the problematic output or replace with available outputs
output "nat_configuration" {
  value = module.vpc.nat_gateway_configuration
}