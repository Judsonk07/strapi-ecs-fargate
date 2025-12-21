resource "aws_security_group" "ecs_sg" {
  name   = "strapi-ecs-sg"
  vpc_id = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds_sg" {
  name   = "strapi-rds-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port       = 5432
    to_port         = 5432
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

resource "aws_db_subnet_group" "strapi" {
  name       = "strapi-db-subnet-group"
  subnet_ids = data.aws_subnets.default.ids
}

resource "aws_db_instance" "strapi_db" {
  identifier              = "strapi-postgres-db"
  engine                  = "postgres"
  engine_version          = "14"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20

  db_name                 = var.db_name
  username                = var.db_user
  password                = var.db_password

  db_subnet_group_name    = aws_db_subnet_group.strapi.name
  vpc_security_group_ids  = [aws_security_group.rds.id]

  publicly_accessible     = false
  skip_final_snapshot     = true
}

# output "rds_endpoint" {
#   value = aws_db_instance.strapi_db.endpoint
# }
