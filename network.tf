resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

    tags = {
        Name = "tf-demo"
        env  = "dev"
    }
}


resource "aws_subnet" "public01" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"

    tags = {
        Name = "tf-demo"
        env  = "dev"
    }
}

resource "aws_subnet" "public02" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-1c"

    tags = {
        Name = "tf-demo"
        env  = "dev"
    }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

    tags = {
        Name = "tf-demo"
        env  = "dev"
    }
}


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
    tags = {
        Name = "tf-demo"
        env  = "dev"
    }
}


resource "aws_route_table_association" "public_assoc01" {
  subnet_id      = aws_subnet.public01.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_assoc02" {
  subnet_id      = aws_subnet.public02.id
  route_table_id = aws_route_table.public_rt.id
}