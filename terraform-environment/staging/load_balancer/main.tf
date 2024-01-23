
resource "aws_lb" "my_alb" {
  subnets            = aws_subnet.public_subnet[*].id
  security_groups    = aws_security_group.alb_sg[*].id
  name               = "my-alb"
  load_balancer_type = "application"
  internal           = false
}

# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  vpc_id      = aws_vpc.my_vpc.id
  name        = "alb-sg"
  description = "Security group for ALB"

  egress {
    to_port   = 0
    protocol  = "-1"
    from_port = 0
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    to_port   = 80
    protocol  = "tcp"
    from_port = 80
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    to_port   = 443
    protocol  = "tcp"
    from_port = 443
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

# Target Group for Frontend
resource "aws_lb_target_group" "frontend_target_group" {
  vpc_id                        = aws_vpc.my_vpc.id
  target_type                   = "ip"
  protocol                      = "HTTP"
  port                          = 80
  name                          = "frontend-target-group"
  load_balancing_algorithm_type = "round_robin"

  health_check {
    enabled = true
  }
}

# Target Group for Backend
resource "aws_lb_target_group" "backend_target_group" {
  vpc_id          = aws_vpc.my_vpc.id
  target_type     = "ip"
  protocol        = "HTTP"
  port            = 8080
  name            = "backend-target-group"
  health_check {
    enabled = true
  }
}

# Load Balancer Attachment for Frontend Target Group
resource "aws_lb_target_group_attachment" "frontend_lb_attachment" {
  target_id        = aws_lb.my_alb.arn
  target_group_arn = aws_lb_target_group.frontend_target_group.arn
}

# Load Balancer Attachment for Backend Target Group
resource "aws_lb_target_group_attachment" "backend_lb_attachment" {
  target_id        = aws_lb.my_alb.arn
  target_group_arn = aws_lb_target_group.backend_target_group.arn
}

# HTTP Listener for Frontend
resource "aws_lb_listener" "frontend_http_listener" {
  protocol          = "HTTP"
  port              = 80
  load_balancer_arn = aws_lb.my_alb.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_target_group.arn
  }
}


# HTTPS Listener for Frontend
resource "aws_lb_listener" "frontend_https_listener" {
  protocol          = "HTTPS"
  port              = 443
  load_balancer_arn = aws_lb.my_alb.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_target_group.arn
  }

  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = cert
}
