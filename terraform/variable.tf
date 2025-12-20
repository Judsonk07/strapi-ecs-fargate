variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "image_url" {
  type = string
}

# variable "db_host" {
#   type = string
# }

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
