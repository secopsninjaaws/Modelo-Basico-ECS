resource "aws_ecs_task_definition" "main" {
  family                   = "${var.service_name}-task"
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = var.compatibilities
  cpu                      = var.service_cpu
  memory                   = var.service_memory
  tags = {
    Name = "${var.service_name}-task-definition"
  }

  dynamic "volume" {
    for_each = var.efs_volumes
    content {
      name = volume.value.name

      efs_volume_configuration {
        file_system_id = volume.value.file_system_id
        root_directory = volume.value.root_directory
        transit_encryption = "ENABLED"
      }
    }
  }

  container_definitions = jsonencode(
    [
      {
        name      = "${var.service_name}-container"
        image     = "${aws_ecr_repository.main.repository_url}:${var.ecr_image_tag}"
        cpu       = var.service_cpu
        memory    = var.service_memory
        essential = true

        portMappings = [
          {
            containerPort = var.service_port
            hostPort      = var.service_port
            protocol      = "tcp"
          }
        ]

        logConfiguration = {
          logDriver = "awslogs"
          options = {
            "awslogs-group"         = aws_cloudwatch_log_group.main.name
            "awslogs-region"        = var.region
            "awslogs-stream-prefix" = "${var.service_name}-stream"
          }
        }



      }
    ]
  )

}
