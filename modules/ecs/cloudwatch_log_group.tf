resource "aws_cloudwatch_log_group" "main" {
  name              = "${var.service_name}-log-group"
  retention_in_days = 7
  tags = {
    Name = "${var.service_name}-log-group"
  }
  lifecycle {
    prevent_destroy = false
  }
  depends_on = [aws_iam_policy_attachment.task_execution_policy_attachment]

}