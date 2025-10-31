resource "aws_db_subnet_group" "app-db-subnet-group" {
  name       = "${var.prefix}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.prefix}-db-subnet-group"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "${var.prefix}-db-sg"
  description = "Security group for RDS ${var.prefix}"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_cidr_blocks
    content {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  dynamic "ingress" {
    for_each = var.allowed_security_groups
    content {
      from_port       = 3306
      to_port         = 3306
      protocol        = "tcp"
      security_groups = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}-db-sg"
  }
}

resource "aws_db_instance" "app-db" {
  identifier             = "${var.prefix}-db"
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  db_name                = "${var.prefix}_db"
  username               = var.username
  password               = var.password
  db_subnet_group_name   = aws_db_subnet_group.app-db-subnet-group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = var.publicly_accessible
  parameter_group_name   = var.parameter_group_name
  skip_final_snapshot    = true
  multi_az               = false

  tags = {
    Name = "${var.prefix}-db"
  }
}
