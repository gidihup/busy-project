## Backend API ALB security group
resource "aws_security_group" "app-alb-sg" {
  name        = "app-alb-sg"
  description = "Allow HTTP inbound traffic to app ALB on port 8080"
  vpc_id      = aws_vpc.app-vpc.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-alb-sg"
  }
}

resource "aws_lb" "app-alb" {
  name                       = "app-alb"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = [aws_subnet.public-1.id, aws_subnet.public-2.id]
  security_groups            = [aws_security_group.app-alb-sg.id]
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "app-alb-tg" {
  name        = "app-alb-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.app-vpc.id
  target_type = "instance"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    port                = 8080
    matcher             = "200-499"
    timeout             = "10"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

resource "aws_lb_target_group_attachment" "app-alb-tga-1" {
  target_group_arn = aws_lb_target_group.app-alb-tg.arn
  target_id        = aws_instance.app-vm-1.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "app-alb-tga-2" {
  target_group_arn = aws_lb_target_group.app-alb-tg.arn
  target_id        = aws_instance.app-vm-2.id
  port             = 8080
}

resource "aws_alb_listener" "app-listener" {
  load_balancer_arn = aws_lb.app-alb.id
  port              = 8080
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.app-alb-tg.id
    type             = "forward"
  }
}