resource "aws_codedeploy_app" "deployment" {
  compute_platform = "ECS"
  name             = "${local.secretariat}-${local.agency}-codedeploy_app-${local.environment}-${local.application}"

  tags  = {
    Name = "${local.secretariat}-${local.agency}-codedeploy_app-${local.environment}-${local.application}"
    application   = local.application
    agency        = local.agency
    secretariat   = local.secretariat
    environment   = local.environment
    businessowner = local.businessowner
    itowner       = local.itowner
    createdby     = local.createdby
    terraform_managed = "yes"
    tftemplatepath = "https://github.com/executive-office-of-education/CloudAdministration/tree/templates-terraform/${local.relative_path}"
  }
}

resource "aws_codedeploy_deployment_group" "ecs" {  ####CHEKC THIS BLOCK for naming
  app_name               = aws_codedeploy_app.deployment.name
  deployment_config_name = local.deployment_config_name
  deployment_group_name  = "${local.secretariat}-${local.agency}-deployment-group-${local.ecs_service_name}"
  service_role_arn       = aws_iam_role.deployment.arn
  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }
    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = local.termination_wait_time_in_minutes
    }
  }
  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }
  ecs_service {
    cluster_name = local.ecs_cluster_name
    service_name = local.ecs_service_name
  }
###Veriy if LB needs to be created or EOE provided 
  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [
        local.main_listener]
      }

      target_group {
        name = local.main_target_group
      }

      target_group {
        name = local.test_target_group
      }

      test_traffic_route {
        listener_arns = [
        local.test_listener]
      }
    }
  }
  tags  = {
    Name = "${local.agency}-${local.environment}-aws_codedeploy_deployment_group-${local.application}"
    application   = local.application
    agency        = local.agency
    secretariat   = local.secretariat
    environment   = local.environment
    businessowner = local.businessowner
    itowner       = local.itowner
    createdby     = local.createdby
    terraform_managed = "yes"
    tftemplatepath = "https://github.com/executive-office-of-education/CloudAdministration/tree/templates-terraform/${local.relative_path}"
  }

}
