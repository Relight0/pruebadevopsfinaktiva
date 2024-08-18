output "alb_dns_name" {
  value       = aws_lb.main.dns_name
  description = "The DNS name of the load balancer"
}

output "ecr_repository_url_app1" {
  value       = aws_ecr_repository.app1.repository_url
  description = "The URL of the ECR repository for App1"
}

output "ecr_repository_url_app2" {
  value       = aws_ecr_repository.app2.repository_url
  description = "The URL of the ECR repository for App2"
}

output "ecs_cluster_name" {
  value       = aws_ecs_cluster.main.name
  description = "The name of the ECS cluster"
}

output "ecs_service_name_app1" {
  value       = aws_ecs_service.app1.name
  description = "The name of the ECS service for App1"
}

output "ecs_service_name_app2" {
  value       = aws_ecs_service.app2.name
  description = "The name of the ECS service for App2"
}

output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC"
}

output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "The IDs of the public subnets"
}

output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "The IDs of the private subnets"
}