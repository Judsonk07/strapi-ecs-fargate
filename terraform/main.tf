terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # CRITICAL: Create this bucket manually in AWS S3 before running
  backend "s3" {
    bucket = "my-strapi-state-bucket" # CHANGE THIS to your bucket name
    key    = "strapi/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}
