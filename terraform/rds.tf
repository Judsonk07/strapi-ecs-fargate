resource "aws_db_subnet_group" "strapi" {
  name       = "strapi-db-subnet-group"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = "strapi-db-subnet-group"
  }
}

resource "aws_security_group" "rds" {
  name   = "strapi-rds-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.strapi.id] # ECS SG
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "strapi" {
  identifier              = "strapi-postgres-db"
  engine                  = "postgres"
  engine_version          = "14.10"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20

  db_name                 = "strapi"
  username                = "strapi"
  password                = var.db_password

  db_subnet_group_name    = aws_db_subnet_group.strapi.name
  vpc_security_group_ids  = [aws_security_group.rds.id]

  publicly_accessible     = false
  skip_final_snapshot     = true

  tags = {
    Name = "strapi-rds"
  }
}
