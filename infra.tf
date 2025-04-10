module "vpc" {
  source        = "./modules/vpc"
  project_name  = var.project_name
  subnets_count = var.subnets_count
  vpc_cidr      = var.vpc_cidr
  cluster_name  = var.cluster_name
  alb_internal  = false
}


