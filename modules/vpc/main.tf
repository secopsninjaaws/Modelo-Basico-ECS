####Data
data "aws_availability_zones" "available_zones" {}


resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

#### Public Subnet

resource "aws_subnet" "public_subnets" {
  count                   = var.subnets_count
  vpc_id                  = aws_vpc.main.id
  availability_zone       = element(data.aws_availability_zones.available_zones.names, count.index)
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-public-subnet-${count.index}"
  }
}


resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_subnets_association" {
  count          = var.subnets_count
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}


#### Private Subnet

resource "aws_subnet" "private_subnets" {
  count             = var.subnets_count
  vpc_id            = aws_vpc.main.id
  availability_zone = element(data.aws_availability_zones.available_zones.names, count.index)
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + var.subnets_count)
  tags = {
    Name = "${var.project_name}-private-subnet-${count.index}"
  }
}
resource "aws_nat_gateway" "nat_gateway" {
  subnet_id     = aws_subnet.public_subnets[0].id
  allocation_id = aws_eip.eip.id
  tags = {
    Name = "${var.project_name}-nat-gateway"
  }
}

resource "aws_eip" "eip" {
  vpc = true
  tags = {
    Name = "${var.project_name}-eip"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
}

resource "aws_route_table_association" "private_subnets_association" {
  count          = var.subnets_count
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}




