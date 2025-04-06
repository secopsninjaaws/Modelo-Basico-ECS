locals {
  services = {
    ################################################ Service Configuration ################################################
    "service1" = {
      service_name          = "service1"
      service_cpu           = 256
      service_memory        = 512
      service_desired_count = 2
      service_max_count     = 5
      service_min_count     = 1
      service_port          = 80
      vpc_id                = module.vpc.vpc_id
      private_subnets       = module.vpc.private_subnet_ids
      alb_listener_arn      = module.vpc.listiner_arn
      host_name             = "service1.dev.selectsolucoes.com"

      ############# HEALTH CHECK
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
      ############ SECURITY GROUPS 
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
    }
    ################################################ Service Configuration ################################################
  }
}

module "service" {
  source   = "./modules/ecs"
  for_each = local.services

  service_name          = each.value.service_name
  service_cpu           = each.value.service_cpu
  service_memory        = each.value.service_memory
  service_desired_count = each.value.service_desired_count
  service_max_count     = each.value.service_max_count
  service_min_count     = each.value.service_min_count
  service_port          = each.value.service_port
  project_name          = var.project_name
  vpc_id                = each.value.vpc_id
  private_subnets       = each.value.private_subnets
  alb_listener_arn      = each.value.alb_listener_arn
  security_group_rules = {
    for k, v in each.value.security_group_rules : k => {
      type        = v.type
      from_port   = v.from_port
      to_port     = v.to_port
      protocol    = v.protocol
      cidr_blocks = v.cidr_blocks
    }
  }
  host_name = each.value.host_name

}