resource "aws_vpc" "iac_lab_vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = {
    Name = format("%s-vpc", var.prefix)
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.iac_lab_vpc.id
  cidr_block              = var.subnet1_cidr
  availability_zone       = format("%sa", var.region)
  map_public_ip_on_launch = true

  tags = {
    Name = format("%s-public-subnet-1", var.prefix)
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.iac_lab_vpc.id
  cidr_block              = var.subnet2_cidr
  availability_zone       = format("%sb", var.region)
  map_public_ip_on_launch = true

  tags = {
    Name = format("%s-public-subnet-2", var.prefix)
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.iac_lab_vpc.id
  cidr_block        = var.subnet3_cidr
  availability_zone = format("%sa", var.region)

  tags = {
    Name = format("%s-private-subnet-1", var.prefix)
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.iac_lab_vpc.id
  cidr_block        = var.subnet4_cidr
  availability_zone = format("%sb", var.region)

  tags = {
    Name = format("%s-private-subnet-2", var.prefix)
  }
}

resource "aws_subnet" "secure_subnet_1" {
  vpc_id            = aws_vpc.iac_lab_vpc.id
  cidr_block        = var.subnet5_cidr
  availability_zone = format("%sa", var.region)

  tags = {
    Name = format("%s-secure-subnet-1", var.prefix)
  }
}

resource "aws_subnet" "secure_subnet_2" {
  vpc_id            = aws_vpc.iac_lab_vpc.id
  cidr_block        = var.subnet6_cidr
  availability_zone = format("%sb", var.region)

  tags = {
    Name = format("%s-secure-subnet-2", var.prefix)
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.iac_lab_vpc.id

  tags = {
    Name = format("%s-igw", var.prefix)
  }
}

resource "aws_eip" "nat_gateway_eip" {
  domain = "vpc"

  tags = {
    Name = format("%s-nat-eip", var.prefix)
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = format("%s-nat", var.prefix)
  }

  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.iac_lab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = format("%s-public-rt", var.prefix)
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.iac_lab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = format("%s-private-rt", var.prefix)
  }
}

resource "aws_route_table_association" "public_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}