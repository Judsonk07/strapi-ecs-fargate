resource "aws_ecs_cluster" "this" {
  name = "strapi-cluster"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "strapi-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name  = "strapi"
      image = var.image_url
      essential = true

      portMappings = [{
        containerPort = 1337
      }]

      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:1337 || exit 1"]
        interval    = 30
        timeout     = 10
        retries     = 3
        startPeriod = 90
      }

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.strapi.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }

      environment = [
        { name = "NODE_ENV", value = "production" },
        { name = "HOST", value = "0.0.0.0" },
        { name = "PORT", value = "1337" },

        { name = "DATABASE_CLIENT", value = "postgres" },
        { name = "DATABASE_HOST", value = aws_db_instance.strapi_db.address },
        { name = "DATABASE_PORT", value = "5432" },
        { name = "DATABASE_NAME", value = var.db_name },
        { name = "DATABASE_USERNAME", value = var.db_user },
        { name = "DATABASE_PASSWORD", value = var.db_password },

        { name = "APP_KEYS", value = var.app_keys },
        { name = "API_TOKEN_SALT", value = var.api_token_salt },
        { name = "ADMIN_JWT_SECRET", value = var.admin_jwt_secret },
        { name = "TRANSFER_TOKEN_SALT", value = var.transfer_token_salt },
        { name = "ENCRYPTION_KEY", value = var.encryption_key },
        { name = "JWT_SECRET", value = var.jwt_secret }
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

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  health_check_grace_period_seconds = 360

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.blue.arn
    container_name   = "strapi"
    container_port   = 1337
  }
  depends_on = [
    aws_lb_listener.http,
    aws_lb_listener.test
  ]
}



# ##################################
# # ECS Cluster
# ##################################

# resource "aws_ecs_cluster" "this" {
#   name = "strapi-cluster"
# }

# resource "aws_ecs_cluster_capacity_providers" "this" {
#   cluster_name = aws_ecs_cluster.this.name

#   # capacity_providers = ["FARGATE"]

#   # default_capacity_provider_strategy {
#   #   capacity_provider = "FARGATE"
#   #   weight            = 1
#   # }
# }

# ##################################
# # ECS Task Definition
# ##################################

# resource "aws_ecs_task_definition" "this" {
#   family                   = "strapi-task"
#   requires_compatibilities = ["FARGATE"]
#   network_mode             = "awsvpc"
#   cpu                      = "512"
#   memory                   = "1024"

#   execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
#   task_role_arn      = aws_iam_role.ecs_task_execution_role.arn

#   container_definitions = jsonencode([
#     {
#       name      = "strapi"
#       image     = var.image_url
#       essential = true

#       portMappings = [
#         {
#           containerPort = 1337
#           protocol      = "tcp"
#         }
#       ]

#       # logConfiguration = {
#       #   logDriver = "awslogs"
#       #   options = {
#       #     awslogs-group         = aws_cloudwatch_log_group.strapi.name
#       #     awslogs-region        = var.aws_region
#       #     awslogs-stream-prefix = "ecs"
#       #   }
#       # }

#       environment = [
#         { name = "HOST", value = "0.0.0.0" },
#         { name = "PORT", value = "1337" },

#         { name = "DATABASE_CLIENT", value = "postgres" },
#         { name = "DATABASE_HOST", value = aws_db_instance.strapi_db.address },
#         { name = "DATABASE_PORT", value = "5432" },
#         { name = "DATABASE_NAME", value = var.db_name },
#         { name = "DATABASE_USERNAME", value = var.db_user },
#         { name = "DATABASE_PASSWORD", value = var.db_password },
#         { name = "DATABASE_SSL", value = "false" },

#         { name = "APP_KEYS", value = var.app_keys },
#         { name = "API_TOKEN_SALT", value = var.api_token_salt },
#         { name = "ADMIN_JWT_SECRET", value = var.admin_jwt_secret },
#         { name = "TRANSFER_TOKEN_SALT", value = var.transfer_token_salt },
#         { name = "ENCRYPTION_KEY", value = var.encryption_key },
#         { name = "JWT_SECRET", value = var.jwt_secret }
#       ]
#     }
#   ])
# }

# ##################################
# # ECS Service (Blue/Green via CodeDeploy)
# ##################################

# resource "aws_ecs_service" "this" {
#   name            = "strapi-service"
#   cluster         = aws_ecs_cluster.this.id
#   task_definition = aws_ecs_task_definition.this.arn
#   desired_count   = 1
#   launch_type     = "FARGATE"

#   enable_execute_command = true

#   deployment_controller {
#     type = "CODE_DEPLOY"
#   }

#   network_configuration {
#     subnets         = var.private_subnets
#     security_groups = [aws_security_group.ecs_sg.id]
#     assign_public_ip = false
#   }

#   load_balancer {
#     target_group_arn = aws_lb_target_group.blue.arn
#     container_name   = "strapi"
#     container_port   = 1337
#   }

#   depends_on = [
#     aws_lb_listener.http,
#     # aws_ecs_cluster_capacity_providers.this
#   ]
# }
