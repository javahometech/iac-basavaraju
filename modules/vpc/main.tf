resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
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
  count  = length(local.azs)
  vpc_id = aws_vpc.main.id

  cidr_block        = var.subnet_cidrs[count.index]
  availability_zone = local.azs[count.index]
  tags = {
    Name = "Pub-Subnet-${count.index}"
  }
}


resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Pub-Rt"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "sub_as" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.rt.id
}
  