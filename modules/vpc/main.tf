resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = "JavaHome-VPC"
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