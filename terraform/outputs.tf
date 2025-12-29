output "alb_url" {

  value = aws_lb.alb.dns_name

  description = "ALB DNS name for accessing Strapi"

}

output "alb_arn" {

  value = aws_lb.alb.arn

  description = "ALB ARN"

}

output "rds_endpoint" {

  value = aws_db_instance.strapi_db.endpoint

  description = "RDS PostgreSQL endpoint"

}

output "rds_address" {

  value = aws_db_instance.strapi_db.address

  description = "RDS PostgreSQL address"

}

output "ecs_cluster_name" {

  value = aws_ecs_cluster.this.name

  description = "ECS Cluster name"

}

output "ecs_service_name" {

  value = aws_ecs_service.this.name

  description = "ECS Service name"

}

output "codedeploy_app_name" {

  value = aws_codedeploy_app.this.name

  description = "CodeDeploy application name"

}

output "codedeploy_deployment_group" {

  value = aws_codedeploy_deployment_group.dg.deployment_group_name

  description = "CodeDeploy Deployment Group name"

}

output "alb_listener_http_arn" {

  value = aws_lb_listener.http.arn

  description = "ARN for ALB HTTP listener"

}

