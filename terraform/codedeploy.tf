resource "aws_codedeploy_app" "this" {
  name             = "${var.project_name}-codedeploy-app"
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "dg" {
  app_name              = aws_codedeploy_app.this.name
  deployment_group_name = "${var.project_name}-dg"
  service_role_arn      = aws_iam_role.codedeploy_role.arn

  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout    = "CONTINUE_DEPLOYMENT"
      wait_time_in_minutes = 0
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
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

      # ✅ PROD → PORT 80
      prod_traffic_route {
        listener_arns = [aws_lb_listener.http.arn]
      }

      # ✅ TEST → PORT 9000 (MUST BE DIFFERENT)
      test_traffic_route {
        listener_arns = [aws_lb_listener.test.arn]
      }
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}




# resource "aws_codedeploy_app" "this" {
#   name             = "${var.project_name}-codedeploy-app"
#   compute_platform = "ECS"
# }

# resource "aws_codedeploy_deployment_group" "dg" {
#   app_name              = aws_codedeploy_app.this.name
#   deployment_group_name = "${var.project_name}-dg"
#   service_role_arn      = aws_iam_role.codedeploy_role.arn

#   deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

#   deployment_style {
#     deployment_type   = "BLUE_GREEN"
#     deployment_option = "WITH_TRAFFIC_CONTROL"
#   }

#   blue_green_deployment_config {
#     deployment_ready_option {
#       action_on_timeout = "CONTINUE_DEPLOYMENT"
#     }

#     terminate_blue_instances_on_deployment_success {
#       action = "TERMINATE"
#     }
#   }

#   ecs_service {
#     cluster_name = aws_ecs_cluster.this.name
#     service_name = aws_ecs_service.this.name
#   }

#   load_balancer_info {
#     target_group_pair_info {
#       target_group { name = aws_lb_target_group.blue.name }
#       target_group { name = aws_lb_target_group.green.name }

#       prod_traffic_route {
#         listener_arns = [aws_lb_listener.http.arn]
#       }
#     }
#   }

#   auto_rollback_configuration {
#     enabled = true
#     events  = ["DEPLOYMENT_FAILURE"]
#   }
# }




# ########################################
# # CodeDeploy Application (ECS)
# ########################################

# resource "aws_codedeploy_app" "this" {
#   name             = "${var.project_name}-codedeploy-app"
#   compute_platform = "ECS"
# }

# ########################################
# # CodeDeploy Deployment Group (Blue/Green)
# ########################################

# resource "aws_codedeploy_deployment_group" "dg" {
#   app_name              = aws_codedeploy_app.this.name
#   deployment_group_name = "${var.project_name}-dg"
#   service_role_arn      = aws_iam_role.codedeploy_role.arn

#   deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

#   deployment_style {
#     deployment_type   = "BLUE_GREEN"
#     deployment_option = "WITH_TRAFFIC_CONTROL"
#   }

#   ####################################
#   # REQUIRED Blue/Green Configuration
#   ####################################

#   blue_green_deployment_config {

#     deployment_ready_option {
#       action_on_timeout = "CONTINUE_DEPLOYMENT"
#       wait_time_in_minutes = 0
#     }

#     terminate_blue_instances_on_deployment_success {
#       action                           = "TERMINATE"
#       termination_wait_time_in_minutes = 5
#     }
#   }

#   ####################################
#   # ECS Service
#   ####################################

#   ecs_service {
#     cluster_name = aws_ecs_cluster.this.name
#     service_name = aws_ecs_service.this.name
#   }

#   ####################################
#   # Load Balancer (Blue/Green)
#   ####################################

#   load_balancer_info {
#     target_group_pair_info {

#       target_group {
#         name = aws_lb_target_group.blue.name
#       }

#       target_group {
#         name = aws_lb_target_group.green.name
#       }

#       prod_traffic_route {
#         listener_arns = [aws_lb_listener.http.arn]
#       }
#     }
#   }

#   ####################################
#   # Auto Rollback
#   ####################################

#   auto_rollback_configuration {
#     enabled = true
#     events  = ["DEPLOYMENT_FAILURE"]
#   }
# }
