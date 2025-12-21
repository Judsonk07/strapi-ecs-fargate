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
  # FIX: Now pointing to the correct SG defined in security_groups.tf
  vpc_security_group_ids  = [aws_security_group.rds.id]
 
  publicly_accessible     = false
  skip_final_snapshot     = true
}