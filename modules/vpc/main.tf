provider "aws" {
  region = var.region
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  
  tags = merge(
    var.tags,
    {
      Name = var.vpc_name
    }
  )
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-igw"
    }
  )
}

# Create Public Subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  
  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-public-${count.index + 1}"
      Type = "public"
    }
  )
}

# Create Private Subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  
  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-private-${count.index + 1}"
      Type = "private"
    }
  )
}

# Create Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  
  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-public-rt"
    }
  )
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)
  
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Create Elastic IPs for NAT Gateways
resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? var.nat_gateway_count : 0
  
  domain = "vpc"
  
  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-nat-eip-${count.index + 1}"
    }
  )
}

# Create NAT Gateways
resource "aws_nat_gateway" "main" {
  count = var.enable_nat_gateway ? var.nat_gateway_count : 0
  
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  
  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-nat-${count.index + 1}"
    }
  )
  
  depends_on = [aws_internet_gateway.main]
}

# Create Private Route Tables
resource "aws_route_table" "private" {
  count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : var.nat_gateway_count) : 1
  
  vpc_id = aws_vpc.main.id
  
  # Add route to NAT Gateway if enabled
  dynamic "route" {
    for_each = var.enable_nat_gateway ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = var.single_nat_gateway ? aws_nat_gateway.main[0].id : aws_nat_gateway.main[count.index].id
    }
  }
  
  tags = merge(
    var.tags,
    {
      Name = var.single_nat_gateway ? "${var.vpc_name}-private-rt" : "${var.vpc_name}-private-rt-${count.index + 1}"
    }
  )
}

# Associate Private Subnets with Private Route Tables
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)
  
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = var.enable_nat_gateway ? (
    var.single_nat_gateway ? aws_route_table.private[0].id : aws_route_table.private[count.index % var.nat_gateway_count].id
  ) : aws_route_table.private[0].id
}