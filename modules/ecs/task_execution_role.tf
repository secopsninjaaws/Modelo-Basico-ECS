resource "aws_iam_role" "task_execution_role" {
  name = "${var.service_name}-ecs-task-execution-role"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ecs-tasks.amazonaws.com"
          }
        }
      ]
    }
  )
}

resource "aws_iam_policy" "task_execution_policy" {
  name        = "${var.service_name}-task-execution-policy"
  description = "Policy for ECS task execution role"
  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = var.task_execution_role_policy_actions
          Resource = "*"
        }
      ]
    }
  )

}

resource "aws_iam_policy_attachment" "task_execution_policy_attachment" {
  name       = "${var.service_name}-task-execution-policy-attachment"
  roles      = [aws_iam_role.task_execution_role.name]
  policy_arn = aws_iam_policy.task_execution_policy.arn

}