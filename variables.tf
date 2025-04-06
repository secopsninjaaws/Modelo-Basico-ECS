variable "project_name" {
  type        = string
  description = "The name of the project"
}


variable "subnets_count" {
  type        = number
  description = "The number of subnets to create"
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC"
}