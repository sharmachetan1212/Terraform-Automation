# Security group for public HTTP traffic into the load balancer.
resource "aws_security_group" "this" {
  name        = "${var.name_prefix}-alb-sg"
  description = "Allow HTTP access to the application load balancer"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_http_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name_prefix}-alb-sg"
    Environment = var.environment
    Service     = "alb"
  }
}

# Internet-facing Application Load Balancer across the supplied subnets.
resource "aws_lb" "this" {
  name               = "${var.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.this.id]
  subnets            = var.subnet_ids

  tags = {
    Name        = "${var.name_prefix}-alb"
    Environment = var.environment
    Service     = "alb"
  }
}

# Backend target group. EC2 or future Auto Scaling targets register here.
resource "aws_lb_target_group" "this" {
  name     = "${var.name_prefix}-tg"
  port     = var.target_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled = true
    path    = var.health_check_path
  }

  tags = {
    Name        = "${var.name_prefix}-tg"
    Environment = var.environment
    Service     = "alb"
  }
}

# Public HTTP listener that forwards all requests to the target group.
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

# Optional single-instance attachment used by the current EC2 module.
resource "aws_lb_target_group_attachment" "instance" {
  count = var.target_instance_id == null ? 0 : 1

  target_group_arn = aws_lb_target_group.this.arn
  target_id        = var.target_instance_id
  port             = var.target_port
}
