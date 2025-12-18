resource "aws_ecs_cluster" "this" {
  name = "strapi-cluster"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "strapi-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = "arn:aws:iam::ACCOUNT_ID:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name  = "strapi"
      image = var.image_url
      essential = true
      portMappings = [{
        containerPort = 1337
      }]
      environment = [
        { name = "DATABASE_HOST", value = var.db_host },
        { name = "DATABASE_NAME", value = var.db_name },
        { name = "DATABASE_USERNAME", value = var.db_user },
        { name = "DATABASE_PASSWORD", value = var.db_password }
      ]
    }
  ])
}

resource "aws_ecs_service" "this" {
  name            = "strapi-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = data.aws_subnets.default.ids
    security_groups = [aws_security_group.strapi.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = "strapi"
    container_port   = 1337
  }

  depends_on = [aws_lb_listener.this]
}
