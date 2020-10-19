provider "aws" { 
  region = "us-west-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"	
  tags = {
    Name = "my amazing vpc"
    Engineer = var.engineer
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public_subnet1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-west-1a"
  tags = {
    Name = "Amazing VPC Public Subnet 1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-1c"
  tags = {
    Name = "Amazing VPC Public Subnet 1"
  }
}

resource "aws_route_table" "default" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.default.id
}

resource "aws_route_table_association" "public2" {
  subnet_id = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.default.id
}


resource "aws_network_acl" "allowall" {
  vpc_id = aws_vpc.main.id

  egress {
    protocol = "-1" #all protocols (tcp/udp etc)
    rule_no = 100 #where it is in the stack
    action = "allow" #allows all 
    cidr_block = "0.0.0.0/0"
    from_port = 0 #from all port ranges
    to_port = 0 #to all port ranges

  }
  ingress {
    from_port = 0 #from all port ranges 
    to_port = 0 #to all port rangers
    protocol = "-1"
    action = "allow" #allows all
    rule_no = 200 #where it is in the stack
    cidr_block = "0.0.0.0/0" #
  } 
}
