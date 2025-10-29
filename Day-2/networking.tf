resource "aws_vpc" "app-vpc" {
    cidr_block = var.vpc-cidr

    tags = {
        Name = "${var.prefix}-vpc"
    }
}

resource "aws_subnet" "app-public-subnet-1" {
    vpc_id            = aws_vpc.app-vpc.id
    cidr_block        = local.subnet-cidrs[0]
    availability_zone = var.azs[0]
    map_public_ip_on_launch = true

    tags = {
      Name = "${var.prefix}-public-subnet-1"
    }
}

resource "aws_subnet" "app-private-subnet-1" {
    vpc_id            = aws_vpc.app-vpc.id
    cidr_block        = local.subnet-cidrs[1]
    availability_zone = var.azs[0]
    map_public_ip_on_launch = false

    tags = {
      Name = "${var.prefix}-private-subnet-1"
    }
  
}

resource "aws_subnet" "app-public-subnet-2" {
    vpc_id            = aws_vpc.app-vpc.id
    cidr_block        = local.subnet-cidrs[2]
    availability_zone = var.azs[1]
    map_public_ip_on_launch = true

    tags = {
      Name = "${var.prefix}-public-subnet-2"
    }
}

resource "aws_subnet" "app-private-subnet-2" {
    vpc_id            = aws_vpc.app-vpc.id
    cidr_block        = local.subnet-cidrs[3]
    availability_zone = var.azs[1]
    map_public_ip_on_launch = false

    tags = {
        Name = "${var.prefix}-private-subnet-2"
    }
  
}
resource "aws_internet_gateway" "app-igw" {
    vpc_id = aws_vpc.app-vpc.id
}

resource "aws_nat_gateway" "app-nat-gw-1" {
    allocation_id = aws_eip.app-nat-eip-1.id
    subnet_id     = aws_subnet.app-public-subnet-1.id

    tags = {
        Name = "${var.prefix}-nat-gw-1"
    }
}

resource "aws_nat_gateway" "app-nat-gw-2" {
    allocation_id = aws_eip.app-nat-eip-2.id
    subnet_id     = aws_subnet.app-public-subnet-2.id

    tags = {
        Name = "${var.prefix}-nat-gw-2"
    }
}

resource "aws_route_table" "app-public-rt" {
    vpc_id = aws_vpc.app-vpc.id

    route {
        cidr_block = var.all_cidr
        gateway_id = aws_internet_gateway.app-igw.id
    }

    depends_on = [ aws_internet_gateway.app-igw ]

    tags = {
        Name = "${var.prefix}-public-rt"
    }
}

resource "aws_route_table" "app-private-1-rt" {
    vpc_id = aws_vpc.app-vpc.id

    route {
        cidr_block = var.all_cidr
        nat_gateway_id = aws_nat_gateway.app-nat-gw-1.id
    }

    depends_on = [ aws_nat_gateway.app-nat-gw-1 ]

    tags = {
        Name = "${var.prefix}-private-1-rt"
    }
  
}

resource "aws_route_table" "app-private-2-rt" {
    vpc_id = aws_vpc.app-vpc.id

    route {
        cidr_block = var.all_cidr
        nat_gateway_id = aws_nat_gateway.app-nat-gw-2.id
    }
    depends_on = [ aws_nat_gateway.app-nat-gw-2 ]
    tags = {
        Name = "${var.prefix}-private-2-rt"
    }
  
}

resource "aws_route_table_association" "app-rt-assoc-public-1" {
    subnet_id      = aws_subnet.app-public-subnet-1.id
    route_table_id = aws_route_table.app-public-rt.id
}

resource "aws_route_table_association" "app-rt-assoc-public-2" {
    subnet_id      = aws_subnet.app-public-subnet-2.id
    route_table_id = aws_route_table.app-public-rt.id
}

resource "aws_route_table_association" "app-rt-assoc-private-1" {
    subnet_id      = aws_subnet.app-private-subnet-1.id
    route_table_id = aws_route_table.app-private-1-rt.id
}

resource "aws_route_table_association" "app-rt-assoc-private-2" {
    subnet_id      = aws_subnet.app-private-subnet-2.id
    route_table_id = aws_route_table.app-private-2-rt.id
}