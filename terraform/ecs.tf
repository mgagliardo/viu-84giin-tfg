# local-exec for build and push of docker image
resource "null_resource" "build_push_docker_img" {

  triggers = {
    detect_docker_source_changes = var.force_image_rebuild == true ? timestamp() : local.dkr_img_src_sha256
  }

  provisioner "local-exec" {
    command = local.dkr_build_cmd
  }

}

resource "aws_cloudwatch_log_group" "microblog" {
  name = "${var.environment}-${var.service}"
  tags = local.tags
}

resource "aws_ecs_cluster" "microblog" {
  name       = "${var.environment}-${var.service}-cluster"
  depends_on = [null_resource.build_push_docker_img]
}

resource "aws_ecs_task_definition" "microblog" {
  family                   = "${var.environment}-${var.service}-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = var.task_cpu
  memory = var.task_memory

  container_definitions = jsonencode([
    {
      name      = "${var.environment}-${var.service}-app"
      image     = local.ecr_docker_image
      cpu       = var.task_cpu
      memory    = var.task_memory
      essential = true
      portMappings = [

        {
          containerPort = var.application_port
          hostPort      = var.application_port
        }
      ]
      secrets = [
        {
          name      = "DATABASE_URL"
          valueFrom = "${aws_secretsmanager_secret.db_secret.arn}:database_url::"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-region        = var.region
          awslogs-group         = aws_cloudwatch_log_group.microblog.id
          awslogs-stream-prefix = "${var.environment}-${var.service}"
          awslogs-create-group  = "true"
        }
      },
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  depends_on = [null_resource.build_push_docker_img]
}

resource "aws_ecs_service" "microblog" {
  name                 = "${var.environment}-${var.service}-service"
  cluster              = aws_ecs_cluster.microblog.id
  task_definition      = aws_ecs_task_definition.microblog.arn
  desired_count        = 2
  force_new_deployment = true
  launch_type          = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.microblog_fargate_sg.id]
    subnets          = module.vpc.private_subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.microblog.id
    container_name   = "${var.environment}-${var.service}-app"
    container_port   = var.application_port
  }

  depends_on = [
    aws_alb.main,
    aws_alb_target_group.microblog,
    aws_alb_listener.http_listener_id
  ]
}

resource "aws_security_group" "microblog_fargate_sg" {
  name        = "${var.environment}-${var.service}-fargate-sg"
  description = "SG for ${var.environment}-${var.service}-fargate service"
  vpc_id      = module.vpc.vpc_id
  tags        = local.tags
}

resource "aws_security_group_rule" "microblog_fargate_allow_alb" {
  type                     = "ingress"
  description              = "Allow traffic from ${var.environment}-${var.service}-alb"
  from_port                = var.application_port
  to_port                  = var.application_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.microblog_alb_sg.id
  security_group_id        = aws_security_group.microblog_fargate_sg.id
}

resource "aws_security_group_rule" "microblog_fargate_sg_allow_outbound_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.microblog_fargate_sg.id
}
