# Base VPC used by compute, database, and load balancing modules.
resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = var.name
    Environment = var.environment
  }
}

# Reads available AZs so subnets can be spread by index.
data "aws_availability_zones" "available" {
  state = "available"
}

# Creates simple subnets. With map_public_ip_on_launch enabled, these act as public subnets.
resource "aws_subnet" "this" {
  count = var.subnet_count

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index + 1)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name        = "${var.name}-subnet-${count.index + 1}"
    Environment = var.environment
  }
}

# Public internet gateway is created only for public-subnet style deployments.
resource "aws_internet_gateway" "this" {
  count = var.map_public_ip_on_launch ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.name}-igw"
    Environment = var.environment
  }
}

# Route table that sends outbound internet traffic through the internet gateway.
resource "aws_route_table" "public" {
  count = var.map_public_ip_on_launch ? 1 : 0

  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }

  tags = {
    Name        = "${var.name}-public-rt"
    Environment = var.environment
  }
}

# Attaches each created subnet to the public route table.
resource "aws_route_table_association" "public" {
  count = var.map_public_ip_on_launch ? var.subnet_count : 0

  subnet_id      = aws_subnet.this[count.index].id
  route_table_id = aws_route_table.public[0].id
}
