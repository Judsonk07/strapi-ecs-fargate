terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "my-strapi-terraform-state-bucket"
    # UPDATED: Changed key to 'prod' to start a fresh state and ignore locked resources
    key    = "strapi/prod.tfstate" 
    region = "ap-southeast-1"
  }
}

provider "aws" {
  region = var.aws_region
}