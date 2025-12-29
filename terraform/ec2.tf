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

  # User data script
  user_data = templatefile("${path.module}/scripts/user_data.sh", {
    docker_image = var.docker_image
    docker_tag   = var.docker_tag
    aws_region   = var.aws_region
  })

  # This forces a new instance if the Docker tag changes
  user_data_replace_on_change = true

  tags = {
    Name = "Strapi-Server-${var.docker_tag}"
  }
}