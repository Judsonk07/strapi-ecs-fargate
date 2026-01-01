#!/bin/bash
exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

echo "Starting EC2 setup..."

# -------------------------------
# Install Docker & AWS CLI
# -------------------------------
apt-get update -y
apt-get install -y ca-certificates curl gnupg awscli

curl -fsSL https://get.docker.com | bash
systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu

# -------------------------------
# Login to Amazon ECR
# -------------------------------
aws ecr get-login-password --region ${aws_region} \
  | docker login --username AWS --password-stdin \
  $(echo ${docker_image} | cut -d'/' -f1)

# -------------------------------
# Start PostgreSQL (LOCAL)
# -------------------------------
docker run -d \
  --name strapi-postgres \
  --restart unless-stopped \
  -e POSTGRES_DB=strapi \
  -e POSTGRES_USER=strapi \
  -e POSTGRES_PASSWORD=strapi \
  -p 5432:5432 \
  postgres:14

sleep 10

# -------------------------------
# Pull Strapi Image
# -------------------------------
docker pull ${docker_image}:${docker_tag}

# -------------------------------
# Run Strapi
# -------------------------------
docker run -d \
  --name strapi \
  --restart unless-stopped \
  -p 1337:1337 \
  -e NODE_ENV=production \
  -e HOST=0.0.0.0 \
  -e PORT=1337 \
  -e DATABASE_CLIENT=postgres \
  -e DATABASE_HOST=172.17.0.1 \
  -e DATABASE_PORT=5432 \
  -e DATABASE_NAME=strapi \
  -e DATABASE_USERNAME=strapi \
  -e DATABASE_PASSWORD=strapi \
  -e APP_KEYS="${app_keys}" \
  -e API_TOKEN_SALT="${api_token_salt}" \
  -e ADMIN_JWT_SECRET="${admin_jwt_secret}" \
  -e JWT_SECRET="${jwt_secret}" \
  -e TRANSFER_TOKEN_SALT="${transfer_token_salt}" \
  -e ENCRYPTION_KEY="${encryption_key}" \
  ${docker_image}:${docker_tag}

echo "Strapi deployment completed successfully"











# #!/bin/bash
# exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# echo "Starting setup..."

# # 1. Install Docker and AWS CLI
# sudo apt-get update
# sudo apt-get install -y ca-certificates curl gnupg awscli unzip

# sudo install -m 0755 -d /etc/apt/keyrings
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
# sudo chmod a+r /etc/apt/keyrings/docker.gpg

# echo \
#   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
#   $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
#   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# sudo apt-get update
# sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# sudo systemctl start docker
# sudo systemctl enable docker
# sudo usermod -aG docker ubuntu

# # 2. Log in to AWS ECR
# echo "Logging in to ECR in region ${aws_region}..."
# aws ecr get-login-password --region ${aws_region} | sudo docker login --username AWS --password-stdin $(echo ${docker_image} | cut -d'/' -f1)

# # 3. Pull and Run Strapi
# echo "Pulling image: ${docker_image}:${docker_tag}"
# sudo docker pull ${docker_image}:${docker_tag}

# echo "Running container..."
# # Passing Secrets as Environment Variables
# # These variables match the keys defined in the templatefile block in ec2.tf
# sudo docker run -d \
#   --name strapi \
#   --restart unless-stopped \
#   -p 1337:1337 \
#   -e NODE_ENV=production \
#   -e HOST=0.0.0.0 \
#   -e PORT=1337 \
#   -e DATABASE_CLIENT=postgres \
#   -e DATABASE_HOST=172.17.0.1 \
#   -e DATABASE_PORT=5432 \
#   -e DATABASE_NAME=strapi \
#   -e DATABASE_USERNAME=strapi \
#   -e DATABASE_PASSWORD=strapi \
#   -e APP_KEYS="${app_keys}" \
#   -e API_TOKEN_SALT="${api_token_salt}" \
#   -e ADMIN_JWT_SECRET="${admin_jwt_secret}" \
#   -e JWT_SECRET="${jwt_secret}" \
#   -e TRANSFER_TOKEN_SALT="${transfer_token_salt}" \
#   -e ENCRYPTION_KEY="${encryption_key}" \
#   ${docker_image}:${docker_tag}

# echo "Setup complete!"