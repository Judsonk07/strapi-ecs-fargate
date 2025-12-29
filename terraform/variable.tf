variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.small" # Recommended for Strapi (needs ~2GB RAM)
}

variable "key_name" {
  description = "Name of the SSH key pair in AWS"
  type        = string
  default     = "Strapi" # CHANGE THIS to your actual Key Pair name
}

variable "docker_image" {
  description = "Full ECR image URL"
  type        = string
}

variable "docker_tag" {
  description = "Tag of the image to deploy"
  type        = string
  default     = "latest"
}