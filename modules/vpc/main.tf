locals {
  prefix              = "${var.config.environment}-${var.config.context}"
  vpc_cidr            = var.config.vpc_cidr
  public_subnet_cidr  = var.config.public_subnet_cidr
  private_subnet_cidr = var.config.private_subnet_cidr
  availability_zones  = var.config.availability_zones
  tags = merge({
    Name = local.prefix
  }, var.config.tags)
}
# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = local.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = local.tags
}
# Subnet
## Internet Gateway for public subnet
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
  tags = local.tags
}
## Elastic IP for NAT
resource "aws_eip" "nat_eip" {
  vpc = true
  depends_on = [
    aws_internet_gateway.ig
  ]
}
## NAT
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)
  depends_on    = [aws_internet_gateway.ig]
  tags          = local.tags
}
## Public Subnet
resource "aws_subnet" "public_subnet" {
  count                   = length(local.public_subnet_cidr)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(local.public_subnet_cidr, count.index)
  availability_zone       = element(local.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = merge(var.config.tags, {
    Name = "${local.prefix}-public"
  })
}
## Private Subnet
resource "aws_subnet" "private_subnet" {
  count                   = length(local.private_subnet_cidr)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(local.private_subnet_cidr, count.index)
  availability_zone       = element(local.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = merge(var.config.tags, {
    Name = "${local.prefix}-private"
  })
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  tags   = local.tags
}
# Routing table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags   = local.tags
}
## Public Internet gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}
## Private Internet Gateway
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
# table associations
resource "aws_route_table_association" "public" {
  count          = length(local.public_subnet_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private" {
  count          = length(local.private_subnet_cidr)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private.id
}
/*====
VPC's Default Security Group
======*/
resource "aws_security_group" "default" {
  name        = "${local.prefix}-default-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_vpc.vpc]
  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }
  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }
  tags = local.tags
}
