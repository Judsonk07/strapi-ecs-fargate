########################################
# VPC Endpoints for ECR (so tasks in private subnets can pull images)
########################################

resource "aws_security_group" "vpce_sg" {
  name   = "${var.project_name}-vpce-sg"
  vpc_id = var.vpc_id

  # Allow ECS tasks (ecs_sg) to connect to the interface endpoints on 443
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ECR API endpoint (GetAuthorizationToken)
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.private_subnets
  security_group_ids = [aws_security_group.vpce_sg.id]

  private_dns_enabled = true
}

# ECR DKR endpoint (image pull)
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.private_subnets
  security_group_ids = [aws_security_group.vpce_sg.id]

  private_dns_enabled = true
}

# (Optional) STS endpoint can help with authentication in some setups
resource "aws_vpc_endpoint" "sts" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.sts"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.private_subnets
  security_group_ids = [aws_security_group.vpce_sg.id]

  private_dns_enabled = true
}
