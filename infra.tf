module "vpc" {
  source        = "./modules/vpc"
  project_name  = var.project_name
  subnets_count = var.subnets_count
}


