resource "aws_codepipeline" "ecs_pipeline" {
  name     = "${local.secretariat}-${local.agency}-${local.resource}-${local.environment}-codepipeline-${local.appliocation})"
  role_arn = aws_iam_role.codepipeline_role.arn
  tags = {
    environment = local.environment
    application   = local.application
    appdetail     = local.appdetail
    agency        = local.agency
    secretariat   = local.secretariat
    environment   = local.environment
    businessowner = local.businessowner
    itowner       = local.itowner
    createdby     = local.createdby
    terraform_managed = "yes"
    tftemplatepath = "https://github.com/executive-office-of-education/CloudAdministration/tree/templates-terraform/${local.relative_path}"

  }

  
  artifact_store {
    location = local.s3_artifact_bucket 
    type     = "S3"
  }
  ####  STAGE 1 Fetch Container Image from ECR  ####
  ####https://docs.aws.amazon.com/codepipeline/latest/userguide/action-reference-S3.html

  stage {
    name = "Source"
    action {
      name             = "Fetch_ECR_Image"
      category         = "Source"
      owner            = "AWS"
      provider         = "ECR"
      version          = "1"
      run_order        = 1
      output_artifacts = ["Image"]
      configuration = {
      RepositoryName = local.ecr_registery_name
      ImageTag       = local.ecr_registery_tag
      }
    }
  }
########STAGE 2 Build stage to consume the output artifact from previous stage to pass tp Deployment stage 
  stage {
  name = "Build"
  action {
    name             = "dev-Build"
    category         = "Build"
    owner            = "AWS"
    provider         = "CodeBuild"
    input_artifacts  = ["Image"]
    output_artifacts = ["BuildArtifact"]
    version          = "1"
    configuration = {
      ProjectName = aws_codebuild_project.eoe-dv-codebuild.name
      PrimarySource = "SourceArtifact"
    }
  }
}
 

##############STAGE 3 Deploy to ECS
stage {
  name = "Deploy"
  action {
    name      = "dev-Deploy"
    category  = "Deploy"
    owner     = "AWS"
    provider  = "CodeDeployToECS"
    version   = "1"
    run_order = 1
    input_artifacts = ["BuildArtifact"]
    configuration = {
      ApplicationName = local.ecs_service_name
      DeploymentGroupName = aws_codedeploy_deployment_group.ecs.deployment_group_name
      TaskDefinitionTemplateArtifact = "BuildArtifact"
      TaskDefinitionTemplatePath     = "taskdef.json"
      AppSpecTemplateArtifact        = "BuildArtifact"
      AppSpecTemplatePath            = "appspec.yaml"
      Image1ArtifactName             = "BuildArtifact"
      Image1ContainerName            = "IMAGE1_NAME"
    }
  }
 }
}


  # ##### STAGE 2 Use CodeBuild to build Container Image ####
  # stage {
  #   name = "Build"
  #   action {
  #     category = "Build"
  #     configuration = {
  #     "ProjectName" = join("-", ["eoe-edu",local.environment,local.repo_name,"build"])
  #     }
  #     input_artifacts = [
  #       "SourceArtifact",
  #     ]
  #     name = "Build"
  #     output_artifacts = [
  #       "ImageArtifact",
  #       "DefinitionArtifact"
  #     ]
  #     owner     = "AWS"
  #     provider  = "CodeBuild"
  #     run_order = 1
  #     version   = "1"
  #   }
  # }

  #### STAGE 3 Use CodeDeply to Deploy Image as ECSFargate container ### 
#   stage {
#     name = "Deploy"
#     action {
#       name      = "Deploy-Dev"
#       category  = "Deploy"
#       owner     = "AWS"
#       provider  = "CodeDeployToECS"
#       version   = "1"
#       run_order = 1
#       input_artifacts = [
#         "ImageArtifact",
#         "DefinitionArtifact",
#       ]
#       configuration = {
#         ApplicationName                = aws_codedeploy_app.deployment.name
#         DeploymentGroupName            = aws_codedeploy_deployment_group.ecs.deployment_group_name
#         TaskDefinitionTemplateArtifact = "DefinitionArtifact"
#         TaskDefinitionTemplatePath     = "taskdef.json"
#         AppSpecTemplateArtifact        = "DefinitionArtifact"
#         AppSpecTemplatePath            = "appspec.yaml"
#         Image1ArtifactName             = "ImageArtifact"
#         Image1ContainerName            = "IMAGE1_NAME"
#       }
#     }
#   }
# }


