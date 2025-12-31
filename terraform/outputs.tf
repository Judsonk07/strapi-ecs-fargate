output "public_ip" {
  description = "Public IP of the Strapi Server"
  value       = aws_instance.strapi_server.public_ip
}

output "ssh_command" {
  description = "Command to SSH into server"
  value       = "ssh -i ${var.key_name}.pem ubuntu@${aws_instance.strapi_server.public_ip}"
}

output "strapi_url" {
  description = "URL to access Strapi"
  value       = "http://${aws_instance.strapi_server.public_ip}:1337"
}
