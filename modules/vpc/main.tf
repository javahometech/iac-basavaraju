resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = "JavaHome-VPC"
  }
}

resource "aws_subnet" "my_subnets" {
  count             = var.subnet_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "Pub-Subnet-${count.index}"
  }
}