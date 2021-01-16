resource "aws_security_group" "alb" {
  name        = "ecs_test_alb"
  description = "ecs_test alb"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs_test"
  }
}

resource "aws_security_group_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_lb" "main" {
  name               = "ecs-test"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.public_1a.id, aws_subnet.public_1c.id]
}

resource "aws_alb_listener" "main" {
  port              = 80
  protocol          = "HTTP"
  load_balancer_arn = aws_lb.main.arn
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = 200
      message_body = "ok"
    }
  }
}
