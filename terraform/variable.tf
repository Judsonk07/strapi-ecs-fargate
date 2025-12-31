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

# --- Strapi Secrets ---
# These names match your terraform.tfvars keys
variable "app_keys" {
  description = "Strapi APP_KEYS"
  type        = string
  sensitive   = true
}

variable "api_token_salt" {
  description = "Strapi API_TOKEN_SALT"
  type        = string
  sensitive   = true
}

variable "admin_jwt_secret" {
  description = "Strapi ADMIN_JWT_SECRET"
  type        = string
  sensitive   = true
}

variable "jwt_secret" {
  description = "Strapi JWT_SECRET"
  type        = string
  sensitive   = true
}

variable "transfer_token_salt" {
  description = "Strapi TRANSFER_TOKEN_SALT"
  type        = string
  sensitive   = true
}

variable "encryption_key" {
  description = "Strapi ENCRYPTION_KEY"
  type        = string
  sensitive   = true
}
