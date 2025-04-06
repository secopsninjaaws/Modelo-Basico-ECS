resource "aws_cloudwatch_log_group" "main" {
  name              = "/ecs/${var.service_name}"
  retention_in_days = 90
  tags = {
    Name = "${var.service_name}-log-group"
  }

}