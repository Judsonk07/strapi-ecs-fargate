variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "project_name" {
  default = "strapi-bg"
}

variable "vpc_id" {}
variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "image_url" {
  type = string
}

variable "db_name" {
  type    = string
  default = "strapi"
}

variable "db_user" {
  type    = string
  default = "strapi"
}

variable "db_password" {
  type      = string
  sensitive = true
}
variable "app_keys" {
  description = "Strapi application keys"
  type        = string
  sensitive   = true
}

variable "api_token_salt" {
  description = "Strapi API token salt"
  type        = string
  sensitive   = true
}

variable "admin_jwt_secret" {
  description = "Strapi admin JWT secret"
  type        = string
  sensitive   = true
}

variable "transfer_token_salt" {
  description = "Strapi transfer token salt"
  type        = string
  sensitive   = true
}

variable "encryption_key" {
  description = "Strapi encryption key"
  type        = string
  sensitive   = true
}

variable "jwt_secret" {
  description = "Strapi JWT secret"
  type        = string
  sensitive   = true
}

variable "acm_certificate_arn" {
  description = "(Optional) ARN of an ACM certificate to enable HTTPS on the ALB. Leave empty to skip HTTPS listener."
  type        = string
  default     = ""
}

variable "enable_test_listener_ingress" {
  description = "Enable external ingress to ALB test listener (port 9000). Set to true to allow 0.0.0.0/0 access."
  type        = bool
  default     = false
}
