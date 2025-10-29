resource "aws_security_group" "alb-sg" {
  name        = "${var.prefix}-alb-sg"
  description = "Allow HTTP traffic to ALB"
  vpc_id      = aws_vpc.app-vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_to_alb" {
  security_group_id = aws_security_group.alb-sg.id
  cidr_ipv4         = var.all_cidr
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_from_alb" {
  security_group_id = aws_security_group.alb-sg.id
  cidr_ipv4         = var.all_cidr
  ip_protocol       = -1
}

resource "aws_alb" "app-alb" {
  name                        = "${var.prefix}-alb"
  internal                    = false
  security_groups             = [aws_security_group.alb-sg.id]
  subnets                     = [aws_subnet.app-public-subnet-1.id, aws_subnet.app-public-subnet-2.id]
  enable_deletion_protection  = false

  tags = {
    Name = "${var.prefix}-alb"
  }
}

resource "aws_alb_target_group" "webserver-tg" {
  name     = "alb-webserver-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.app-vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
}

resource "aws_alb_target_group_attachment" "webserver-1-attach" {
  target_group_arn = aws_alb_target_group.webserver-tg.arn
  target_id        = aws_instance.webserver-vm-1.id
  port             = 80
  depends_on       = [aws_instance.webserver-vm-1]
}

resource "aws_alb_target_group_attachment" "webserver-2-attach" {
  target_group_arn = aws_alb_target_group.webserver-tg.arn
  target_id        = aws_instance.webserver-vm-2.id
  port             = 80
  depends_on       = [aws_instance.webserver-vm-2]
}

resource "aws_alb_listener" "app-alb-listener" {
  load_balancer_arn = aws_alb.app-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.webserver-tg.arn
  }
}
