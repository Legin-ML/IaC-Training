resource "aws_vpc" "app-vpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = "${var.prefix}-vpc"
  }
}

resource "aws_subnet" "private-subnets" {
  for_each                = var.private_subnets
  vpc_id                  = aws_vpc.app-vpc.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.prefix}-private-subnet-${each.key}"
  }

}

resource "aws_subnet" "public-subnets" {
  for_each                = var.public_subnets
  vpc_id                  = aws_vpc.app-vpc.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.prefix}-public-subnet-${each.key}"
  }

}

resource "aws_internet_gateway" "app-igw" {
  count  = var.enable_igw ? 1 : 0
  vpc_id = aws_vpc.app-vpc.id
  tags = {
    Name = "${var.prefix}-igw"
  }
}

resource "aws_eip" "app-nat-eip" {
  count  = var.enable_nat_gateway ? 1 : 0
  domain = "vpc"
  tags = {
    Name = "${var.prefix}-nat-eip"
  }
}

resource "aws_nat_gateway" "app-nat-gw" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.app-nat-eip[count.index].id
  subnet_id     = values(aws_subnet.public-subnets)[0].id
  tags = {
    Name = "${var.prefix}-nat-gw"
  }
}

resource "aws_route_table" "app-private-rt" {
  vpc_id = aws_vpc.app-vpc.id
  tags = {
    Name = "${var.prefix}-private-rt"
  }

}

resource "aws_route" "app-private-rt" {
  count                  = var.enable_nat_gateway ? 1 : 0
  route_table_id         = aws_route_table.app-private-rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.enable_nat_gateway ? aws_nat_gateway.app-nat-gw[0].id : null

}

resource "aws_route_table" "app-public-rt" {
  vpc_id = aws_vpc.app-vpc.id

  tags = {
    Name = "${var.prefix}-public-rt"
  }

}

resource "aws_route" "app-public-route" {
  count                  = var.enable_igw ? 1 : 0
  route_table_id         = aws_route_table.app-public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.enable_igw ? aws_internet_gateway.app-igw[0].id : null

}

resource "aws_route_table_association" "app-rt-assoc-public" {
  for_each       = aws_subnet.public-subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.app-public-rt.id

}

resource "aws_route_table_association" "app-rt-assoc-private" {
  for_each       = aws_subnet.private-subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.app-private-rt.id

}