resource "aws_security_group" "strapi_sg" {
  # UPDATED: Static name to avoid "random_id" changes forcing deletions
  # This ensures the security group persists across deployments without conflicts
  name        = "strapi-sg-production-v1"
  description = "Allow SSH and Strapi traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




# #####################################
# # ALB Security Group
# # Allows traffic from the internet to the Load Balancer
# #####################################
# resource "aws_security_group" "alb" {
#   name        = "strapi-alb-sg"
#   description = "Allow HTTP traffic from internet to ALB"
#   vpc_id      = data.aws_vpc.default.id
 
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
 
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
 
# #####################################
# # ECS (Strapi) Security Group
# # Allows traffic from the ALB to the ECS Task
# #####################################
# resource "aws_security_group" "strapi" {
#   name        = "strapi-ecs-sg-1"
#   description = "Allow traffic from ALB to ECS"
#   vpc_id      = data.aws_vpc.default.id
 
#   ingress {
#     from_port       = 1337
#     to_port         = 1337
#     protocol        = "tcp"
#     security_groups = [aws_security_group.alb.id]
#   }
 
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
 
# #####################################
# # RDS Security Group
# # Allows traffic ONLY from the ECS Security Group
# #####################################
# resource "aws_security_group" "rds" {
#   name        = "strapi-rds-sg-1"
#   description = "Allow traffic from ECS to RDS"
#   vpc_id      = data.aws_vpc.default.id
 
#   ingress {
#     from_port       = 5432
#     to_port         = 5432
#     protocol        = "tcp"
#     # This is the key fix: explicitly allowing the ECS SG defined above
#     security_groups = [aws_security_group.strapi.id]
#   }
 
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

