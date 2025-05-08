# This file contains the VPC configuration for the Tribalchief project.
resource "aws_vpc" "tribalchief_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "tribalchief_vpc"
  }
}
# This resource creates an Internet Gateway and attaches it to the VPC.
resource "aws_internet_gateway" "tribalchief_igw" {
  vpc_id = aws_vpc.tribalchief_vpc.id

  tags = {
    Name = "tribalchief_igw"
  }
}
# This resource creates a public subnet AZ 1a in the VPC.
# Ensure you name the subnet to public_subnet-az1a to match the naming convention.
resource "aws_subnet" "tribalchief_public_subnet-az1a" {
  vpc_id                  = aws_vpc.tribalchief_vpc.id
  cidr_block              = var.public_subnet_az1a_cidr
  availability_zone       = "us-east-1a" # Change this to your desired availability zone
  map_public_ip_on_launch = true

  depends_on = [aws_vpc.tribalchief_vpc,
  aws_internet_gateway.tribalchief_igw]

  tags = {
    Name = "tribalchief_public_subnet_az1a"
  }
}
# Create a Private app subnet in AZ 1a in the VPC.
# Ensure you name the subnet to private_app_subnet-az1a to match the naming convention.
resource "aws_subnet" "tribalchief_private_app_subnet-az1a" {
  vpc_id                  = aws_vpc.tribalchief_vpc.id
  cidr_block              = var.private_app_az1a_cidr
  availability_zone       = "us-east-1a" # Change this to your desired availability zone
  map_public_ip_on_launch = false        # Set to false for private subnets ( Note: Private subnets should not have public IPs assigned to instances by default.)

  depends_on = [aws_vpc.tribalchief_vpc,
    aws_internet_gateway.tribalchief_igw
  ]

  tags = {
    Name = "tribalchief_private_app_subnet-az1a"
  }
}
#Create AWS EIP for NAT Gateway in the public subnet of AZ 1a.
# Ensure you name the EIP to nat_gateway_eip-az1a to match the naming convention.
resource "aws_eip" "tribalchief_nat_gateway_eip-az1a" {
  domain = "vpc"

  tags = {
    Name = "tribalchief_nat_gateway_eip-az1a"
  }
}
# Create a NAT Gateway in the public subnet of AZ 1a.
# Ensure you name the NAT Gateway to nat_gateway-az1a to match the naming convention.
resource "aws_nat_gateway" "tribalchief_nat_gateway-az1a" {
  allocation_id = aws_eip.tribalchief_nat_gateway_eip-az1a.id
  subnet_id     = aws_subnet.tribalchief_public_subnet-az1a.id

  tags = {
    Name = "tribalchief_nat_gateway-az1a"
  }

  depends_on = [aws_internet_gateway.tribalchief_igw,
  aws_subnet.tribalchief_public_subnet-az1a]
}
# Create a Public Route Table for the public subnets in az1a
# Ensure you name the route table to public_route_table-az1a to match the naming convention.
resource "aws_route_table" "tribalchief_pub_rt" {
  vpc_id = aws_vpc.tribalchief_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tribalchief_igw.id
  }

  tags = {
    Name = "Route Table for Public Subnets"
  }
}
# associate the public route table with the public subnet in AZ 1a.
resource "aws_route_table_association" "public_subnet_association_az1a" {
  subnet_id      = aws_subnet.tribalchief_public_subnet-az1a.id
  route_table_id = aws_route_table.tribalchief_pub_rt.id
}
# Create a Private Route Table for the private app subnets in az1a
# Ensure you name the route table to private_app_route_table-az1a to match the naming convention.
resource "aws_route_table" "tribalchief_private_app_rt" {
  vpc_id = aws_vpc.tribalchief_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.tribalchief_nat_gateway-az1a.id
  }

  tags = {
    Name = "Route Table for Private App Subnets"
  }
}

# associate the private route table with the private app subnet in AZ 1a
resource "aws_route_table_association" "private_app_subnet_association_az1a" {
  subnet_id      = aws_subnet.tribalchief_private_app_subnet-az1a.id
  route_table_id = aws_route_table.tribalchief_private_app_rt.id
}