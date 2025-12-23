resource "aws_codedeploy_app" "app" {
  name             = "strapi-codedeploy"
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "dg" {
  app_name               = aws_codedeploy_app.app.name
  deployment_group_name  = "strapi-dg"
  service_role_arn       = aws_iam_role.codedeploy_role.arn

  deployment_style {
    deployment_type = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  blue_green_deployment_config {
    terminate_blue_instances_on_deployment_success {
      action = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.this.name
    service_name = aws_ecs_service.this.name
  }

  load_balancer_info {
    target_group_pair_info {
      target_group {
        name = aws_lb_target_group.blue.name
      }
      target_group {
        name = aws_lb_target_group.green.name
      }
      prod_traffic_route {
        listener_arns = [aws_lb_listener.http.arn]
      }
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}
