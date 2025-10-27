resource "aws_security_group" "legin-sg" {
    name        = "legin-test-sg"
    description = "Allow HTTP traffic"
    vpc_id      = aws_vpc.legin-test-vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.legin-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.legin-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol = -1
  
}
resource "aws_instance" "legin-test-vm" {
  ami           = "ami-07d1f1c6865c6b0e7"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id     = aws_subnet.legin-test-subnet.id
  security_groups = [ aws_security_group.legin-sg.id ]

  tags = {
    Name = "legin-test-vm"
  }

  user_data = file("userdata.sh")
  
}