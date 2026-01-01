#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "Starting setup..."

# 1. Install Docker and AWS CLI
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg awscli unzip

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu

# 2. Log in to AWS ECR
echo "Logging in to ECR in region ${aws_region}..."
aws ecr get-login-password --region ${aws_region} | sudo docker login --username AWS --password-stdin $(echo ${docker_image} | cut -d'/' -f1)

# 3. Pull and Run Strapi
echo "Pulling image: ${docker_image}:${docker_tag}"
sudo docker pull ${docker_image}:${docker_tag}

echo "Running container..."
# Passing Secrets as Environment Variables
# These variables match the keys defined in the templatefile block in ec2.tf
sudo docker run -d \
  --name strapi \
  --restart unless-stopped \
  -p 1337:1337 \
  -e NODE_ENV=production \
  -e HOST=0.0.0.0 \
  -e PORT=1337 \
  -e APP_KEYS="${app_keys}" \
  -e API_TOKEN_SALT="${api_token_salt}" \
  -e ADMIN_JWT_SECRET="${admin_jwt_secret}" \
  -e JWT_SECRET="${jwt_secret}" \
  -e TRANSFER_TOKEN_SALT="${transfer_token_salt}" \
  -e ENCRYPTION_KEY="${encryption_key}" \
  ${docker_image}:${docker_tag}

echo "Setup complete!"