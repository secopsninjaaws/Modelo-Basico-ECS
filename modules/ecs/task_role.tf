resource "aws_iam_role" "task_role" {
  name = "${var.service_name}-ecs-task-role"
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

resource "aws_iam_policy" "task_role_policy" {
  name        = "${var.service_name}-task-role-policy"
  description = "Policy for ECS task role"
  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = var.task_role_policy_actions
          Resource = "*"
        }
      ]
    }
  )
}
resource "aws_iam_role_policy_attachment" "task_role_policy_attachment" {
  role       = aws_iam_role.task_role.name
  policy_arn = aws_iam_policy.task_role_policy.arn
}