resource "aws_ecs_cluster" "this" {
  name = "strapi-cluster"
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = aws_ecs_cluster.this.name
}


resource "aws_ecs_task_definition" "this" {
  family                   = "strapi-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = data.aws_iam_role.ecs_task_execution_role.arn


  container_definitions = jsonencode([
    {
      name      = "strapi"
      image     = var.image_url
      essential = true

      portMappings = [{
        containerPort = 1337
        protocol      = "tcp"
      }]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.strapi.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }

      environment = [
        { name = "HOST", value = "0.0.0.0" },
        { name = "PORT", value = "1337" },

        { name = "DATABASE_CLIENT", value = "postgres" },
        { name = "DATABASE_HOST", value = aws_db_instance.strapi_db.address },
        { name = "DATABASE_PORT", value = "5432" },
        { name = "DATABASE_NAME", value = var.db_name },
        { name = "DATABASE_USERNAME", value = var.db_user },
        { name = "DATABASE_PASSWORD", value = var.db_password },
        { name = "DATABASE_SSL", value = "false" },

        { name = "APP_KEYS", value = var.app_keys },
        { name = "API_TOKEN_SALT", value = var.api_token_salt },
        { name = "ADMIN_JWT_SECRET", value = var.admin_jwt_secret },
        { name = "TRANSFER_TOKEN_SALT", value = var.transfer_token_salt },
        { name = "ENCRYPTION_KEY", value = var.encryption_key },
        { name = "JWT_SECRET", value = var.jwt_secret }
      ]

      # secrets = [
      #   { name = "APP_KEYS", valueFrom = "${aws_secretsmanager_secret.strapi.arn}:APP_KEYS::" },
      #   { name = "API_TOKEN_SALT", valueFrom = "${aws_secretsmanager_secret.strapi.arn}:API_TOKEN_SALT::" },
      #   { name = "ADMIN_JWT_SECRET", valueFrom = "${aws_secretsmanager_secret.strapi.arn}:ADMIN_JWT_SECRET::" },
      #   { name = "TRANSFER_TOKEN_SALT", valueFrom = "${aws_secretsmanager_secret.strapi.arn}:TRANSFER_TOKEN_SALT::" },
      #   { name = "ENCRYPTION_KEY", valueFrom = "${aws_secretsmanager_secret.strapi.arn}:ENCRYPTION_KEY::" }
      # ]
    }
  ])
}

resource "aws_ecs_service" "this" {
  name            = "strapi-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type = "FARGATE"

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.strapi.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = "strapi"
    container_port   = 1337
  }

  depends_on = [aws_lb_listener.this, aws_ecs_cluster_capacity_providers.this]
}
