variable "service_name" {
  type        = string
  description = "The name of the ECS service"

}

variable "service_cpu" {
  type        = number
  description = "The CPU units for the ECS service"

}

variable "service_memory" {
  type        = number
  description = "The memory (in MiB) for the ECS service"
}

variable "service_desired_count" {
  type        = number
  description = "The desired number of tasks for the ECS service"

}
variable "service_max_count" {
  type        = number
  description = "The maximum number of tasks for the ECS service"

}
variable "service_min_count" {
  type        = number
  description = "The minimum number of tasks for the ECS service"

}

variable "service_port" {
  type        = number
  description = "The port for the ECS service"

}

variable "project_name" {
  type        = string
  description = "The name of the project"

}

variable "task_role_policy_actions" {
  description = "values for the task role policy actions"
  type        = list(string)
  default = [
    "ssmmessages:CreateControlChannel",
    "ssmmessages:CreateDataChannel",
    "ssmmessages:OpenControlChannel",
    "ssmmessages:OpenDataChannel"
  ]
}

variable "task_execution_role_policy_actions" {
  description = "values for the task execution role policy actions"
  type        = list(string)
  default = [
    "ecr:GetAuthorizationToken",
    "ecr:BatchCheckLayerAvailability",
    "ecr:GetDownloadUrlForLayer",
    "ecr:BatchGetImage",
    "logs:CreateLogStream",
    "logs:PutLogEvents",
    "s3:GetBucketLocation",
    "kms:Decrypt",
    "secretsmanager:GetSecretValue"
  ]

}

variable "compatibilities" {
  description = "The launch type the task definition should use"
  type        = list(string)
  default     = ["FARGATE"]

}

variable "region" {
  description = "The AWS region to deploy the ECS service"
  type        = string
  default     = "us-east-1"

}

variable "path_health_check" {
  description = "The path for the health check"
  type        = map(any)
  default = {
    healthy_threshold   = 2
    interval            = 30
    timeout             = 15
    unhealthy_threshold = 2
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    matcher             = "200-399"

  }
}

variable "vpc_id" {
  description = "The VPC ID where the ECS service will be deployed"
  type        = string

}

variable "private_subnets" {
  description = "The private subnets where the ECS service will be deployed"
  type        = list(string)

}

variable "security_group_rules" {
  description = "The security group rule for the ECS service"
  type = map(object({
    type        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {
    http = {
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

variable "alb_listener_arn" {
  description = "The ARN of the ALB listener"
  type        = string
}

variable "host_name" {
  description = "The host name for the ALB listener rule"
  type        = string

}