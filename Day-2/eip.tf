resource "aws_eip" "app-nat-eip-1" {
    domain = "vpc"
    tags = {
        Name = "${var.prefix}-nat-eip-1"
    }
  
}

resource "aws_eip" "app-nat-eip-2" {
    domain = "vpc"
    tags = {
        Name = "${var.prefix}-nat-eip-2"
    }
  
}