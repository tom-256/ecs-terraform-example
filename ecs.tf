resource "aws_security_group" "ecs" {
  name        = "ecs_test"
  description = "ecs_test"
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

resource "aws_security_group_rule" "ecs" {
  security_group_id = aws_security_group.ecs.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/16"]
}

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

resource "aws_ecs_task_definition" "service_a" {
  family                   = "service"
  container_definitions    = <<DEFINITIONS
  [
    {
      "name": "service-a",
      "image": "${aws_ecr_repository.main.repository_url}",
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        }
      ]
    }
  ]
  DEFINITIONS
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  depends_on               = [aws_ecr_repository.main]
  execution_role_arn       = "${data.aws_iam_role.ecs_task_execution_role.arn}"
}

resource "aws_ecs_cluster" "main" {
  name = "ecs-test"
}

resource "aws_ecs_service" "service_a" {
  name            = "ecs-test-service-a"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.service_a.arn
  desired_count   = 1
  depends_on      = [aws_lb_listener_rule.main]
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.private_1a.id, aws_subnet.private_1c.id]
    security_groups = [aws_security_group.ecs.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "service-a"
    container_port   = 80
  }
}
