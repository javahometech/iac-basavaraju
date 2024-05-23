resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = "JavaHome-VPC"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "JHC-VPC-Igw"
  }

}

resource "aws_subnet" "public" {
  count             = length(var.subnet_cidrs)
  vpc_id            = aws_vpc.main.id

  cidr_block        = var.subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.azs.names[count.index]
  tags = {
    Name = "Pub-Subnet-${count.index}"
  }
}
resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Pub-Rt"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "pub-sub" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.pub-rt.id
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "Private-Sub"
  }
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "pri-sub" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private-rt.id
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.two.id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name = "Nat-Gw"
  }
}

resource "aws_eip" "two" {
  domain = "vpc"
  tags = {
    Name = "Nat-eip"
  }
}