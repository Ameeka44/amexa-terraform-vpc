#Define external IP
resource "aws_eip" "ameeka-nat" {
  vpc = true
}

#Create NAT gateway
resource "aws_nat_gateway" "ameeka-nat-gw" {
  allocation_id = aws_eip.ameeka-nat.id
  subnet_id     = aws_subnet.ameeka-public-subnet1.id
  depends_on = [aws_internet_gateway.ameeka-igw]
  tags = {
    Name = "ameeka-nat-gw"
  }
}

#Create private route table
resource "aws_route_table" "ameeka-private-RT" {
  vpc_id = aws_vpc.ameeka-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ameeka-nat-gw.id
  }
 tags = {
    Name = "ameeka-private-RT"
  }
}

resource "aws_route_table_association" "ameeka-private-RT-asso-a" {
  subnet_id      = aws_subnet.ameeka-private-subnet1.id
  route_table_id = aws_route_table.ameeka-private-RT.id
}

resource "aws_route_table_association" "ameeka-private-RT-asso-b" {
  subnet_id      = aws_subnet.ameeka-private-subnet2.id
  route_table_id = aws_route_table.ameeka-private-RT.id
}

