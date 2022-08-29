#Create AWS VPC
resource "aws_vpc" "ameeka-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "ameeka-vpc"
  }
}

#Create 2 public subnets
resource "aws_subnet" "ameeka-public-subnet1" {
  vpc_id     = aws_vpc.ameeka-vpc.id
  cidr_block = "10.0.0.0/20"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"
  tags = {
    Name = "ameeka-public-subnet1"
  }
}

resource "aws_subnet" "ameeka-public-subnet2" {
  vpc_id     = aws_vpc.ameeka-vpc.id
  cidr_block = "10.0.16.0/20"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1b"
  tags = {
    Name = "ameeka-public-subnet2"
  }
}

#Create 2 private Subnets
resource "aws_subnet" "ameeka-private-subnet1" {
  vpc_id     = aws_vpc.ameeka-vpc.id
  cidr_block = "10.0.32.0/20"
  map_public_ip_on_launch = "false"
  availability_zone = "us-east-1c"
  tags = {
    Name = "ameeka-private-subnet1"
  }
}


resource "aws_subnet" "ameeka-private-subnet2" {
  vpc_id     = aws_vpc.ameeka-vpc.id
  cidr_block = "10.0.48.0/20"
  map_public_ip_on_launch = "false"
  availability_zone = "us-east-1d"
  tags = {
    Name = "ameeka-private-subnet2"
  }
}

#Create Internet Gateway
resource "aws_internet_gateway" "ameeka-igw" {
  vpc_id = aws_vpc.ameeka-vpc.id

  tags = {
    Name = "ameeka-igw"
  }
}

#Create public Route table
resource "aws_route_table" "ameeka-public-RT" {
  vpc_id = aws_vpc.ameeka-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ameeka-igw.id
  }
 tags = {
    Name = "ameeka-public-RT"
  }
}

#Route table associations
resource "aws_route_table_association" "ameeka-public-RT-asso-a" {
  subnet_id      = aws_subnet.ameeka-public-subnet1.id
  route_table_id = aws_route_table.ameeka-public-RT.id
}

resource "aws_route_table_association" "ameeka-public-RT-asso-b" {
  subnet_id      = aws_subnet.ameeka-public-subnet2.id
  route_table_id = aws_route_table.ameeka-public-RT.id
}

