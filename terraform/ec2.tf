data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "strapi_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.strapi_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  # Pass secrets and configuration to the user_data script
  user_data = templatefile("${path.module}/user_data.sh", {
    docker_image = var.docker_image
    docker_tag   = var.docker_tag
    aws_region   = var.aws_region
    
    # Passing Strapi Secrets to the template using the variable names from variables.tf
    app_keys            = var.app_keys
    api_token_salt      = var.api_token_salt
    admin_jwt_secret    = var.admin_jwt_secret
    jwt_secret          = var.jwt_secret
    transfer_token_salt = var.transfer_token_salt
    encryption_key      = var.encryption_key
  })

  # Forces replacement if user_data changes (ensures new secrets apply on re-deploy)
  user_data_replace_on_change = true

  tags = {
    Name = "Strapi-Server-${var.docker_tag}"
  }
}