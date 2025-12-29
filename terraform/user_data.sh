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
# We extract the registry ID from the full image path
echo "Logging in to ECR in region ${aws_region}..."
aws ecr get-login-password --region ${aws_region} | sudo docker login --username AWS --password-stdin $(echo ${docker_image} | cut -d'/' -f1)

# 3. Pull and Run Strapi
echo "Pulling image: ${docker_image}:${docker_tag}"
sudo docker pull ${docker_image}:${docker_tag}

echo "Running container..."
sudo docker run -d \
  --name strapi \
  --restart unless-stopped \
  -p 1337:1337 \
  -e NODE_ENV=production \
  ${docker_image}:${docker_tag}

echo "Setup complete!"