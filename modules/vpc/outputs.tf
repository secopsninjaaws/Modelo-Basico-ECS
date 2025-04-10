output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  # This output will return a list of subnet IDs
  description = "The IDs of the public subnets"
  value       = aws_subnet.public_subnets[*].id

}

output "private_subnet_ids" {
  # This output will return a list of subnet IDs
  description = "The IDs of the private subnets"
  value       = aws_subnet.private_subnets[*].id

}

output "public_listiner_arn" {
  description = "The ARN of the load balancer listiner_80"
  value       = var.alb_internal == "false" ? aws_alb_listener.listiner_80[0].arn : "[0]"
}

output "internal_listiner_arn" {
  description = "The ARN of the load balancer internal_listiner_80"
  value       = var.alb_internal == "true" ? aws_alb_listener.internal_listiner_80[0].arn : ""

}
output "cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.main.name

}