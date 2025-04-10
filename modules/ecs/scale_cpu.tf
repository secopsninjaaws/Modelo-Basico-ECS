############################################### SCALE OUT ###############################################

resource "aws_appautoscaling_policy" "CPU_scale_up" {
  name               = "${var.service_name}-cpu-scale-up"
  policy_type        = "StepScaling"
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = var.scale_out_cooldown
    metric_aggregation_type = var.scale_out_statistic

    step_adjustment {
      scaling_adjustment          = var.scale_out_adjustment
      metric_interval_lower_bound = 0
    }

  }

}


resource "aws_cloudwatch_metric_alarm" "CPU_scale_up" {
  alarm_name                = "${var.service_name}-cpu-scale-up"
  comparison_operator       = var.scale_out_comparison_operator
  evaluation_periods        = var.scale_out_evaluation_periods
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/ECS"
  period                    = var.scale_out_period
  statistic                 = var.scale_out_statistic
  threshold                 = var.scale_out_cpu_threshold
  alarm_description         = "Alarme para escalar o serviço ECS com base na utilização de CPU"
  insufficient_data_actions = []

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = aws_ecs_service.main.name
  }

  alarm_actions = [aws_appautoscaling_policy.CPU_scale_up.arn]
}

############################################### SCALE IN ###############################################

resource "aws_appautoscaling_policy" "CPU_scale_down" {
  name               = "${var.service_name}-cpu-scale-down"
  policy_type        = "StepScaling"
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = var.scale_in_cooldown
    metric_aggregation_type = var.scale_in_statistic

    step_adjustment {
      scaling_adjustment          = var.scale_in_adjustment
      metric_interval_lower_bound = 0
    }

  }

}

resource "aws_cloudwatch_metric_alarm" "CPU_scale_down" {
  alarm_name                = "${var.service_name}-scale-down"
  comparison_operator       = var.scale_in_comparison_operator
  evaluation_periods        = var.scale_in_evaluation_periods
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/ECS"
  period                    = var.scale_in_period
  statistic                 = var.scale_in_statistic
  threshold                 = var.scale_in_cpu_threshold
  alarm_description         = "Alarme para diminuir o serviço ECS com base na utilização de CPU"
  insufficient_data_actions = []

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = aws_ecs_service.main.name
  }

  alarm_actions = [aws_appautoscaling_policy.CPU_scale_down.arn]
}