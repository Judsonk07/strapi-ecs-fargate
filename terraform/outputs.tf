output "alb_url" {
  value = aws_lb.alb.dns_name
}

output "rds_endpoint" {
  value = aws_db_instance.strapi_db.endpoint
}
