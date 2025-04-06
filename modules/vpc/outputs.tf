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

output "listiner_arn" {
  description = "The ARN of the load balancer listiner_80"
  value       = aws_alb_listener.listiner_80.arn

}