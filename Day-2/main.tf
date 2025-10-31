resource "aws_security_group" "webserver-sg" {
    name        = "${var.prefix}-instance-sg"
    description = "Allow HTTP traffic"
    vpc_id      = aws_vpc.app-vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.webserver-sg.id
  referenced_security_group_id = aws_security_group.alb-sg.id
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  description = "Allow HTTP from ALB"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.webserver-sg.id
  cidr_ipv4         = var.allowed_cidr
  ip_protocol = -1
  description = "Allow all outbound traffic"
  
}
resource "aws_instance" "webserver-vm-1" {
  ami           = var.ami-id
  instance_type = var.instance-type
  associate_public_ip_address = false
  subnet_id     = aws_subnet.app-private-subnet-1.id
  security_groups = [ aws_security_group.webserver-sg.id ]
  key_name = aws_key_pair.webserver-key.key_name

  tags = {
    Name = "${var.prefix}-vm-1"
  }

  user_data = file("userdata.sh")
  
}

resource "aws_instance" "webserver-vm-2" {
  ami           = var.ami-id
  instance_type = var.instance-type
  associate_public_ip_address = false
  subnet_id     = aws_subnet.app-private-subnet-2.id
  security_groups = [ aws_security_group.webserver-sg.id ]
  key_name = aws_key_pair.webserver-key.key_name

  tags = {
    Name = "${var.prefix}-vm-2"
  }

  user_data = file("userdata.sh")
  
}