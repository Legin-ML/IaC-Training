resource "aws_vpc" "legin-test-vpc" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "legin-test-subnet" {
    vpc_id            = aws_vpc.legin-test-vpc.id
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-east-1a"
}

resource "aws_internet_gateway" "legin-igw" {
    vpc_id = aws_vpc.legin-test-vpc.id
}

resource "aws_route_table" "legin-test-rt" {
    vpc_id = aws_vpc.legin-test-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.legin-igw.id
    }
}

resource "aws_route_table_association" "legin-rt-assoc" {
    subnet_id      = aws_subnet.legin-test-subnet.id
    route_table_id = aws_route_table.legin-test-rt.id
}