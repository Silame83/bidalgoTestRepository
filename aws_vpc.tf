provider "aws" {
  profile = "default"
  region = "us-east-1"
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "bidalgo_vpc" {
  cidr_block = "10.100.0.0/16"

  tags = {
    Name = "Bidalgo VPC"
  }
}

resource "aws_subnet" "bidalgo_subnet" {
  cidr_block = "10.100.100.0/24"
  vpc_id = aws_vpc.bidalgo_vpc.id
  availability_zone = data.aws_availability_zones.available.names[0]
  depends_on = [
    aws_internet_gateway.igw]
  tags = {
    Name = "Public subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.bidalgo_vpc.id

  tags = {
    Name = "Internet Gateway"
  }
}

resource "aws_security_group" "sg_bidalgo" {
  name = "SG-Bidalgo"
  description = "SG Bidalgo VPC"
  vpc_id = aws_vpc.bidalgo_vpc.id

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  tags = {
    Name = "SG Bidalgo"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.bidalgo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Public RT"
  }
}

resource "aws_route_table_association" "public_rt_assign" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id = aws_subnet.bidalgo_subnet.id
}