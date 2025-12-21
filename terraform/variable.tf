variable "aws_region" {
  type    = string
  default = "ap-south-1"
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
