variable "service_name" {
  type        = string
  description = "O nome do serviço ECS"

}

variable "service_cpu" {
  type        = number
  description = "As unidades de CPU para o serviço ECS"

}

variable "service_memory" {
  type        = number
  description = "A memória (em MiB) para o serviço ECS"
}

variable "service_desired_count" {
  type        = number
  description = "O número desejado de tarefas para o serviço ECS"

}

variable "service_port" {
  type        = number
  description = "A porta para o serviço ECS"

}

variable "project_name" {
  type        = string
  description = "O nome do projeto"

}

variable "task_role_policy_actions" {
  description = "valores para as ações da política da role da task"
  type        = list(string)
  default = [
    "ssmmessages:CreateControlChannel",
    "ssmmessages:CreateDataChannel",
    "ssmmessages:OpenControlChannel",
    "ssmmessages:OpenDataChannel"
  ]
}

variable "task_execution_role_policy_actions" {
  description = "valores para as ações da política da role de execução da task"
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
  description = "O tipo de inicialização que a definição da task deve usar"
  type        = list(string)
  default     = ["FARGATE"]

}

variable "region" {
  description = "A região da AWS para implantar o serviço ECS"
  type        = string
  default     = "us-east-1"

}

variable "path_health_check" {
  description = "O caminho para o health check"
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
  description = "O ID da VPC onde o serviço ECS será implantado"
  type        = string

}

variable "private_subnets" {
  description = "As subnets privadas onde o serviço ECS será implantado"
  type        = list(string)

}

variable "security_group_rules" {
  description = "As regras de security group para o serviço ECS"
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

variable "listiner_arn" {
  description = "O ARN do listener do ALB"
  type        = string
}


variable "host_name" {
  description = "O nome do host para a regra do listener do ALB"
  type        = string

}

variable "cluster_name" {
  description = "O nome do cluster ECS"
  type        = string

}
variable "ecr_image_tag" {
  description = "A tag da imagem para o repositório ECR"
  type        = string
  default     = "latest"

}


################################################################ AUTO SCALING ################################################################


############## CPU SCALE OUT
variable "scale_type" {
  description = "O tipo de política de escalabilidade a ser usada"
  type        = string
}

variable "service_min_count" {
  description = "O número mínimo de tarefas para o serviço ECS"
  type        = number
}

variable "service_max_count" {
  description = "O número máximo de tarefas para o serviço ECS"
  type        = number
}

variable "scale_out_cpu_threshold" {
  description = "O limite de utilização de CPU para scale out"
  type        = number
  default     = 70
}

variable "scale_out_statistic" {
  description = "A estatística a ser usada para scale out"
  type        = string
  default     = "Average"
}


variable "scale_out_adjustment" {
  description = "O valor de ajuste para scale out"
  type        = number
  default     = 1
}

variable "scale_out_comparison_operator" {
  description = "O operador de comparação para scale out"
  type        = string
  default     = "GraterThanOrEqualToThreshold"
}

variable "scale_out_period" {
  description = "O período para scale out"
  type        = number
  default     = 60
}
variable "scale_out_evaluation_periods" {
  description = "O número de períodos de avaliação para scale out"
  type        = number
  default     = 1
}


variable "scale_out_cooldown" {
  description = "O período de cooldown para scale out"
  type        = number
  default     = 120
}

variable "capacity_provider_strategy" {
  description = "A estratégia de capacidade para o serviço ECS"
  type = list(object({
    capacity_provider = string
    weight            = number
  }))
  default = [
    {
      capacity_provider = "FARGATE_SPOT"
      weight            = 100
    }
  ]

}

############## CPU SCALE IN

variable "scale_in_cpu_threshold" {
  description = "O limite de utilização de CPU para scale in"
  type        = number
  default     = 60
}

variable "scale_in_adjustment" {
  description = "O valor de ajuste para scale in"
  type        = number
  default     = -1
}

variable "scale_in_comparison_operator" {
  description = "O operador de comparação para scale in"
  type        = string
  default     = "LessThanOrEqualToThreshold"

}

variable "scale_in_period" {
  description = "O período para scale in"
  type        = number
  default     = 180
}
variable "scale_in_evaluation_periods" {
  description = "O número de períodos de avaliação para scale in"
  type        = number
  default     = 2
}
variable "scale_in_statistic" {
  description = "A estatística a ser usada para scale in"
  type        = string
  default     = "Average"
}

variable "scale_in_cooldown" {
  description = "O período de cooldown para scale in"
  type        = number
  default     = 60

}
variable "placement_strategy" {
  description = "A estratégia de colocação para o serviço ECS"
  type = list(object({
    type  = string
    field = string
  }))
  default = [
    {
      type  = "binpack"
      field = "cpu"
    }
  ]

}

variable "alb_internal" {
  description = "O tipo de ALB (interno ou externo)"
  type        = string
  default     = "false"

}

variable "efs_volumes" {
  description = "Volumes EFS para o ECS"
  type = list(object({
    name            = string
    file_system_id  = string
    root_directory  = string
    transit_encryption = bool
  }))
  default = []
}