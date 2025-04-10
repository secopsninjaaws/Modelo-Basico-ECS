module "service1" {
  source = "./modules/ecs"

  # Container configuration
  alb_internal    = false
  service_name    = "service1"
  cluster_name    = module.vpc.cluster_name
  service_cpu     = 256
  service_memory  = 512
  service_port    = 80
  ecr_image_tag   = "latest"
  project_name    = var.project_name
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnet_ids
  listiner_arn    = module.vpc.public_listiner_arn
  host_name       = "service1.dev.selectsolucoes.com"


  # Capacity provider strategy
  capacity_provider_strategy = [
    {
      capacity_provider = "FARGATE"
      weight            = 70
    },
    {
      capacity_provider = "FARGATE_SPOT"
      weight            = 50
    }
  ]




  # Scaler configuration
  # CPU - APENAS ALTERE SE NECESSÁRIO 
  scale_type            = "StepScaling"
  service_desired_count = 1
  service_min_count     = 1
  service_max_count     = 5
  # UP
  scale_out_cpu_threshold       = 70
  scale_out_adjustment          = 1
  scale_out_comparison_operator = "GreaterThanOrEqualToThreshold"
  scale_out_period              = 60
  scale_out_evaluation_periods  = 1
  scale_out_cooldown            = 120
  scale_out_statistic           = "Average"
  # DOWN
  scale_in_cpu_threshold       = 60
  scale_in_adjustment          = -1
  scale_in_comparison_operator = "LessThanOrEqualToThreshold"
  scale_in_period              = 60
  scale_in_evaluation_periods  = 1
  scale_in_cooldown            = 60
  scale_in_statistic           = "Average"






  #  Health check configuration

  path_health_check = {
    healthy_threshold   = 2
    interval            = 30
    timeout             = 15
    unhealthy_threshold = 2
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    matcher             = "200-399"
  }
  #  Security group rules configuration

  security_group_rules = {
    HTTPS = {
      type        = "ingress"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    HTTP = {
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  depends_on = [module.vpc]
}