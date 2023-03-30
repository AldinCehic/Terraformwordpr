# Resources for VPC setup

# Creates a VPC with networkmask /16 and DNS support
resource "aws_vpc" "nf_vpc" {
  cidr_block            = "10.0.0.0/16"
  enable_dns_hostnames  = true
  enable_dns_support    = true

  tags = {
    Name = "nf_vpc"
  }
}
 
# Creates first subnet, public due to association with internet gateway(see network.tf). 
# CIDR range /24 for 256 IPs 
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.nf_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "nf_public"
  }
}

# Creates second subnet, private due to association with NAT (see network.tf). 
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.nf_vpc.id
  cidr_block        = "10.0.2.0/26"
  availability_zone = "us-west-2a"

  tags = {
    Name = "nf_private_1"
  }
}

# Creates third subnet, required for aurora db since its setting up in two AZs. 
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.nf_vpc.id
  cidr_block        = "10.0.3.0/26"
  availability_zone = "us-west-2b"

  tags = {
    Name = "nf_private_2"
  }
}

# assign both private subnets to aurora to enable two db instances to set up in it
resource "aws_db_subnet_group" "db_subnet" {
  name        = "db_subnet_group"
  subnet_ids  = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

  tags = {
    Name = "nf_aurora_db"
  }
}