resource "aws_appautoscaling_policy" "memory_scale_out" {
  name               = "${var.service_name}-memory-scale-up"
  policy_type        = var.scale_type
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

resource "aws_cloudwatch_metric_alarm" "memory_scale_out_alarm" {
  alarm_name                = "${var.service_name}-memory-scale-up"
  comparison_operator       = var.scale_out_comparison_operator
  evaluation_periods        = var.scale_out_evaluation_periods
  metric_name               = "MemoryUtilization"
  namespace                 = "AWS/ECS"
  period                    = var.scale_out_period
  statistic                 = var.scale_out_statistic
  threshold                 = var.scale_out_cpu_threshold
  alarm_description         = "Alarm to scale out ECS service based on memory utilization"
  insufficient_data_actions = []

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = aws_ecs_service.main.name
  }

  alarm_actions = [aws_appautoscaling_policy.memory_scale_out.arn]

}

############################################### SCALE IN ###############################################
resource "aws_appautoscaling_policy" "memory_scale_in" {
  name               = "${var.service_name}-memory-scale-down"
  policy_type        = var.scale_type
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
resource "aws_cloudwatch_metric_alarm" "memory_scale_in_alarm" {
  alarm_name                = "${var.service_name}-memory-scale-down"
  comparison_operator       = var.scale_in_comparison_operator
  evaluation_periods        = var.scale_in_evaluation_periods
  metric_name               = "MemoryUtilization"
  namespace                 = "AWS/ECS"
  period                    = var.scale_in_period
  statistic                 = var.scale_in_statistic
  threshold                 = var.scale_in_cpu_threshold
  alarm_description         = "Alarm to scale in ECS service based on memory utilization"
  insufficient_data_actions = []

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = aws_ecs_service.main.name
  }

  alarm_actions = [aws_appautoscaling_policy.memory_scale_in.arn]

}