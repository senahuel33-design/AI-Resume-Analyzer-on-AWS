output "ecs_service_name" {
  description = "The name of the running ECS Service"
  value       = aws_ecs_service.main.name
}

output "ecs_cluster_name" {
  description = "The name of the ECS Cluster"
  value       = aws_ecs_cluster.main.name
}
