# VPC Outputs
output "vpc_id" {
  description = "ID of the main VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the main VPC"
  value       = aws_vpc.main.cidr_block
}

# Subnet Outputs
output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "public_subnet_cidr_blocks" {
  description = "List of CIDR blocks of public subnets"
  value       = aws_subnet.public[*].cidr_block
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "private_subnet_cidr_blocks" {
  description = "List of CIDR blocks of private subnets"
  value       = aws_subnet.private[*].cidr_block
}

# Other Resource Outputs
output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_ids" {
  description = "List of IDs of NAT Gateways"
  value       = aws_nat_gateway.main[*].id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value = concat(
    aws_route_table.private_with_nat[*].id,
    aws_route_table.private_without_nat[*].id
  )
}

# Configuration Summary
output "subnet_configuration" {
  description = "Summary of subnet configuration"
  value = {
    vpc_cidr        = var.vpc_cidr
    public_subnets  = length(var.public_subnet_cidrs)
    private_subnets = length(var.private_subnet_cidrs)
    public_cidrs    = var.public_subnet_cidrs
    private_cidrs   = var.private_subnet_cidrs
  }
}

output "availability_zones_used" {
  description = "Availability zones actually used by subnets"
  value       = distinct(concat(aws_subnet.public[*].availability_zone, aws_subnet.private[*].availability_zone))
}

output "nat_gateway_configuration" {
  description = "NAT Gateway configuration summary"
  value = {
    enabled        = var.enable_nat_gateway
    count          = var.nat_gateway_count
    single_gateway = var.single_nat_gateway
    actual_created = length(aws_nat_gateway.main)
  }
}