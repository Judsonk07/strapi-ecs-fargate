terraform {
  backend "s3" {
    bucket  = "YOUR_TERRAFORM_STATE_BUCKET"
    key     = "task7/terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}
