# VPC Outputs
output "vpc_id" {
  description = "ID of the main VPC"
  value       = aws_vpc.main.id
}

output "vpc_arn" {
  description = "ARN of the main VPC"
  value       = aws_vpc.main.arn
}

output "vpc_cidr_block" {
  description = "CIDR block of the main VPC"
  value       = aws_vpc.main.cidr_block
}

output "vpc_default_route_table_id" {
  description = "ID of the default route table for the VPC"
  value       = aws_vpc.main.default_route_table_id
}

output "vpc_main_route_table_id" {
  description = "ID of the main route table for the VPC"
  value       = aws_vpc.main.main_route_table_id
}

# Internet Gateway Outputs
output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "internet_gateway_arn" {
  description = "ARN of the Internet Gateway"
  value       = aws_internet_gateway.main.arn
}

# Public Subnet Outputs
output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = aws_subnet.public[*].arn
}

output "public_subnet_cidr_blocks" {
  description = "List of CIDR blocks of public subnets"
  value       = aws_subnet.public[*].cidr_block
}

output "public_subnet_availability_zones" {
  description = "List of availability zones of public subnets"
  value       = aws_subnet.public[*].availability_zone
}

# Private Subnet Outputs
output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = aws_subnet.private[*].arn
}

output "private_subnet_cidr_blocks" {
  description = "List of CIDR blocks of private subnets"
  value       = aws_subnet.private[*].cidr_block
}

output "private_subnet_availability_zones" {
  description = "List of availability zones of private subnets"
  value       = aws_subnet.private[*].availability_zone
}

# Route Table Outputs
output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "public_route_table_arn" {
  description = "ARN of the public route table"
  value       = aws_route_table.public.arn
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value = concat(
    aws_route_table.private_single_nat[*].id,
    aws_route_table.private_multi_nat[*].id,
    aws_route_table.private_no_nat[*].id
  )
}

output "private_route_table_arns" {
  description = "List of ARNs of private route tables"
  value = concat(
    aws_route_table.private_single_nat[*].arn,
    aws_route_table.private_multi_nat[*].arn,
    aws_route_table.private_no_nat[*].arn
  )
}

# NAT Gateway Outputs
output "nat_gateway_ids" {
  description = "List of IDs of NAT Gateways"
  value       = aws_nat_gateway.main[*].id
}

output "nat_gateway_arns" {
  description = "List of ARNs of NAT Gateways"
  value       = aws_nat_gateway.main[*].arn
}

output "nat_gateway_public_ips" {
  description = "List of public IP addresses of NAT Gateways"
  value       = aws_nat_gateway.main[*].public_ip
}

output "nat_gateway_private_ips" {
  description = "List of private IP addresses of NAT Gateways"
  value       = aws_nat_gateway.main[*].private_ip
}

# Elastic IP Outputs (for NAT Gateways)
output "nat_eip_ids" {
  description = "List of IDs of Elastic IPs for NAT Gateways"
  value       = aws_eip.nat[*].id
}

output "nat_eip_public_ips" {
  description = "List of public IP addresses of Elastic IPs for NAT Gateways"
  value       = aws_eip.nat[*].public_ip
}

# Route Table Association Outputs
output "public_route_table_association_ids" {
  description = "List of IDs of public route table associations"
  value       = aws_route_table_association.public[*].id
}

output "private_route_table_association_ids" {
  description = "List of IDs of private route table associations"
  value = concat(
    aws_route_table_association.private_single_nat_assoc[*].id,
    aws_route_table_association.private_multi_nat_assoc[*].id,
    aws_route_table_association.private_no_nat_assoc[*].id
  )
}

# Configuration Summary Outputs
output "availability_zones" {
  description = "List of availability zones used in the VPC"
  value       = var.availability_zones
}

output "vpc_name" {
  description = "Name of the VPC"
  value       = var.vpc_name
}

output "nat_gateway_configuration" {
  description = "Summary of NAT Gateway configuration"
  value = {
    enabled        = var.enable_nat_gateway
    count          = var.nat_gateway_count
    single_nat     = var.single_nat_gateway
    actual_created = length(aws_nat_gateway.main)
  }
}

output "subnet_summary" {
  description = "Summary of subnet configuration"
  value = {
    public_subnets  = length(aws_subnet.public)
    private_subnets = length(aws_subnet.private)
    total_subnets   = length(aws_subnet.public) + length(aws_subnet.private)
  }
}

output "vpc_complete" {
  description = "Indicates if the VPC infrastructure is complete"
  value       = length(aws_vpc.main.id) > 0
}

# Network Information Outputs
output "network_info" {
  description = "Complete network information"
  value = {
    vpc_id          = aws_vpc.main.id
    vpc_cidr        = aws_vpc.main.cidr_block
    public_subnets  = { for i, subnet in aws_subnet.public : i => { id = subnet.id, cidr = subnet.cidr_block, az = subnet.availability_zone } }
    private_subnets = { for i, subnet in aws_subnet.private : i => { id = subnet.id, cidr = subnet.cidr_block, az = subnet.availability_zone } }
    nat_gateways    = { for i, nat in aws_nat_gateway.main : i => { id = nat.id, public_ip = nat.public_ip, private_ip = nat.private_ip } }
  }
}

# Security Group Default Output
output "default_security_group_id" {
  description = "ID of the default security group for the VPC"
  value       = aws_vpc.main.default_security_group_id
}