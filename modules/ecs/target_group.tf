resource "aws_alb_target_group" "main" {
  name        = "${var.service_name}-target-group"
  port        = var.service_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path                = var.path_health_check["path"]
    port                = var.path_health_check["port"]
    protocol            = var.path_health_check["protocol"]
    interval            = var.path_health_check["interval"]
    timeout             = var.path_health_check["timeout"]
    healthy_threshold   = var.path_health_check["healthy_threshold"]
    unhealthy_threshold = var.path_health_check["unhealthy_threshold"]
    matcher             = var.path_health_check["matcher"]
  }

  tags = {
    Name = "${var.service_name}-target-group"
  }

  lifecycle {
    create_before_destroy = false
  }
}