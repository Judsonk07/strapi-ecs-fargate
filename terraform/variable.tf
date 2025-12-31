variable "aws_region" {
  description = "AWS region"
  default     = "ap-southeast-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.small"
}

variable "key_name" {
  description = "Name of the SSH key pair in AWS"
  type        = string
  # UPDATED: This must match the name in AWS Console > EC2 > Key Pairs
  default     = "Strapi" 
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