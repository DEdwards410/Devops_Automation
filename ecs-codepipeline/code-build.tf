resource "aws_codebuild_project" "eoe-dv-codebuild" {
  name         = "${local.secretariat}-${local.agency}-${local.environment}-codebuild_project-${local.application}"
  description  = "Codebuild for the ECS Green/Blue ${local.service_name} app"
  service_role = aws_iam_role.codebuild.arn

  tags  = {
    Name = "${local.secretariat}-${local.agency}-${local.environment}-codebuild_project-${local.application}"
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

  artifacts { 
    encryption_disabled    = false
    name                   = "${local.secretariat}-${local.agency}-${local.environment}-artifact-${local.application}"
    override_artifact_name = true
    packaging              = "NONE"
    type                   = "CODEPIPELINE"
  }

  environment { 
    compute_type    = "BUILD_GENERAL1_SMALL" 
    image           = "aws/codebuild/windows-base:2019-2.0" #<<Latest Windows 2019 server supports dotnet versions 3.1.419 and 6.0.300 https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html
    type            = "WINDOWS_SERVER_2019_CONTAINER" 
    privileged_mode = true

    environment_localiable {
      name  = "IMAGE_REPO_NAME"
      value = "${local.service_name}"
    }

    environment_localiable {
      name  = "AWS_ACCOUNT_ID"
      value = "${local.aws_account_id}"
    }

    environment_localiable {
      name  = "AWS_DEFAULT_REGION"
      value = "${local.region}"
    }

    environment_localiable {
      name  = "IMAGE_TAG"
      value = "latest"
    }

    environment_localiable {
      name  = "SERVICE_PORT"
      value = "${local.container_port}"
    }

    environment_localiable {
      name  = "MEMORY_RESV"
      value = "${local.memory_reserv}"
    }
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }

    source { 
    type            = "NO_SOURCE"
    buildspec       = "${file("${path.module}./buildspec.yml")}"
                   
  }


}
