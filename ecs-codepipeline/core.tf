provider "aws" {
region  = "${data.aws_region.current.name}"
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}




resource "aws_iam_role" "codepipeline_role" {
  name ="${secretariat}-${agency}-iam_role-${environment}-codepipeline_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
tags  = {
    Name = "${secretariat}-${agency}-iam-role-${environment}-codepipeline_role"
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



resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "${secretariat}-${agency}-iam-role-policy-${environment}-codepipeline-policy"
  role = aws_iam_role.codepipeline_role.id

   
  

  policy = <<EOF
  
  
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObjectAcl",
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::${secretariat}-${agency}-s3-${environment}-*",
        "arn:aws:s3:::${secretariat}-${agency}-s3-${environment}-/*"  
      ]
      
    },
	  
	   {
		"Effect": "Allow",
		"Action": [
			"codedeploy:PutLifecycleEventHookExecutionStatus",
			"codedeploy:DeleteGitHubAccountToken",
			"codedeploy:BatchGetDeploymentTargets",
			"codedeploy:DeleteResourcesByExternalId",
			"codedeploy:GetDeploymentTarget",
			"codedeploy:StopDeployment",
			"codedeploy:ContinueDeployment",
			"codedeploy:ListDeploymentTargets",
			"codedeploy:ListApplications",
			"codedeploy:CreateCloudFormationDeployment",
			"codedeploy:ListOnPremisesInstances",
			"codedeploy:ListGitHubAccountTokenNames",
			"codedeploy:ListDeploymentConfigs",
			"codedeploy:SkipWaitTimeForInstanceTermination"
		],
		"Resource": [
			  "arn:aws:codedeploy:${data.aws_region.current}:${aws_account_id}:deploymentconfig:${secretariat}-${agency}-codedeploy_deploymentconfig-${environment}-*",
        "arn:aws:codedeploy:${data.aws_region.current}:${aws_account_id}:instance:${secretariat}-${agency}-codedeploy-instance-${environment}-*",
        "arn:aws:codedeploy:${data.aws_region.current}:${aws_account_id}:application:${secretariat}-${agency}-$codedeploy-application-${environment}-*",
        "arn:aws:codedeploy:${data.aws_region.current}:${aws_account_id}:deploymentgroup:*/${secretariat}-${agency}-codedeploy-deploymentgroup-${environment}-*"
		]
	},
	{
		"Effect": "Allow",
		"Action": [
			"codebuild:StartBuildBatch",
			"codebuild:StartBuild",
			"codebuild:BatchGetBuilds"
		],
		"Resource": [
			"arn:aws:codebuild:${data.aws_region.current.name}:${local.aws_account_id}:report-group/${secretariat}-${agency}-codebuild-report-group-${environment}-*",
			"arn:aws:codebuild:${data.aws_region.current.name}:${local.aws_account_id}:project/${secretariat}-${agency}-codebuild-project-${environment}-*"
		]
	},
	{  
      "Action": [
        "iam:PassRole"
      ],
      "Resource": "*",
      "Effect": "Allow",
      "Condition": {
            "StringEqualsIfExists": {
                "iam:PassedToService": [
                    "ecs-tasks.amazonaws.com"
                ]
            }
        }
	  }
  ]
} 
EOF


}

resource "aws_iam_role" "codebuild" {
  name ="${secretariat}-${agency}-iam-role${environment}-codebuild"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
tags  = {
    Name = "${secretariat}-${agency}-iam-role${environment}-codebuild"
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

resource "aws_iam_role_policy" "codebuild" {
  role = aws_iam_role.codebuild.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": "arn:aws:logs:${data.aws_region.current}:log-group:${secretariat}-${agency}-${environment}-*",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
    "Version": "2012-10-17",
    "Statement": [
          {
            "Effect": "Allow",
            "Action": [
                "ecr:PutImageTagMutability",
                "ecr:StartImageScan",
                "ecr:DescribeImageReplicationStatus",
                "ecr:ListTagsForResource",
                "ecr:UploadLayerPart",
                "ecr:BatchDeleteImage",
                "ecr:ListImages",
                "ecr:BatchGetRepositoryScanningConfiguration",
                "ecr:DeleteRepository",
                "ecr:CompleteLayerUpload",
                "ecr:TagResource",
                "ecr:DescribeRepositories",
                "ecr:BatchCheckLayerAvailability",
                "ecr:ReplicateImage",
                "ecr:GetLifecyclePolicy",
                "ecr:PutLifecyclePolicy",
                "ecr:DescribeImageScanFindings",
                "ecr:GetLifecyclePolicyPreview",
                "ecr:PutImageScanningConfiguration",
                "ecr:GetDownloadUrlForLayer",
                "ecr:DeleteLifecyclePolicy",
                "ecr:PutImage",
                "ecr:UntagResource",
                "ecr:BatchGetImage",
                "ecr:DescribeImages",
                "ecr:StartLifecyclePolicyPreview",
                "ecr:InitiateLayerUpload",
                "ecr:GetRepositoryPolicy"
                "ecr:GetRegistryPolicy",
                "ecr:BatchImportUpstreamImage",
                "ecr:CreateRepository",
                "ecr:DescribeRegistry",
                "ecr:DescribePullThroughCacheRules",
                "ecr:GetAuthorizationToken",
                "ecr:PutRegistryScanningConfiguration",
                "ecr:CreatePullThroughCacheRule",
                "ecr:DeletePullThroughCacheRule",
                "ecr:GetRegistryScanningConfiguration",
                "ecr:PutReplicationConfiguration"
            ],
            "Resource": "arn:aws:ecr:${data.aws_region.current}:${local.aws_account_id}:repository/${secretariat}-${agency}-${ecr}-${environment}-*
         }
  ]      
} 


POLICY
}

resource "aws_iam_role" "deployment" {
  name         = "${secretariat}-${agency}-iam_role${environment}-deployment"
  tags  = {
    Name = "${secretariat}-${agency}-iam_role${environment}-deployment"
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
  
  
  assume_role_policy = <<EOF
  

  
  
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.deployment.name
}

resource "aws_iam_role_policy" "codedeploy" {
  role = aws_iam_role.deployment.name

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
    
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:*",
            "Resource": [
              "arn:aws:elasticloadbalancing:${data.aws_region.current}:${aws_account_id}:listener/app/${secretariat}-${agency}-elb-${environment}-*/*/*",
              "arn:aws:elasticloadbalancing:${data.aws_region.current}:${aws_account_id}:loadbalancer/app/${secretariat}-${agency}-elb-${environment}-*/*",
              "arn:aws:elasticloadbalancing:${data.aws_region.current}:${aws_account_id}:loadbalancer/net/${secretariat}-${agency}-elb-${environment}/*",
              "arn:aws:elasticloadbalancing:${data.aws_region.current}:${aws_account_id}:listener-rule/net/${secretariat}-${agency}-elb-${environment}-*/*/*/*",
              "arn:aws:elasticloadbalancing:${data.aws_region.current}:${aws_account_id}:listener-rule/app/${secretariat}-${agency}-elb-${environment}-*/*/*/*",
              "arn:aws:elasticloadbalancing:${data.aws_region.current}:${aws_account_id}:listener/net/${secretariat}-${agency}-elb-${environment}-*/*/*",
              "arn:aws:elasticloadbalancing:${data.aws_region.current}:${aws_account_id}:targetgroup/${secretariat}-${agency}-tg-${environment}-*/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "ecs:*",
            "Resource": [
              "arn:aws:ecs:${data.aws_region.current}:${aws_account_id}:container-instance/${secretariat}-${agency}-ecs_cluster-${environment}-*/*",
              "arn:aws:ecs:${data.aws_region.current}:${aws_account_id}:task-set/${secretariat}-${agency}-ecs_cluster-${environment}-*/*/*",
              "arn:aws:ecs:${data.aws_region.current}:${aws_account_id}:task/${secretariat}-${agency}-ecs_cluster-${environment}/*",
              "arn:aws:ecs:${data.aws_region.current}:${aws_account_id}:service/${secretariat}-${agency}-ecs_cluster-${environment}-*/*",
              "arn:aws:ecs:${data.aws_region.current}:${aws_account_id}:task-definition/${secretariat}-${agency}-ecs_task-definition-${environment}-*:*",
              "arn:aws:ecs:${data.aws_region.current}:${aws_account_id}:capacity-provider/${secretariat}-${agency}-ecs_capacity-provider-${environment}-*",
              "arn:aws:ecs:${data.aws_region.current}:${aws_account_id}:cluster/${secretariat}-${agency}-ecs_cluster-${environment}-*"
            ]
        }
    ]
  }
},
{
            "Action": [
                "iam:PassRole"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Condition": {
                "StringEqualsIfExists": {
                    "iam:PassedToService": [
                        "ecs-tasks.amazonaws.com"
                    ]
                }
            }
        }
  ]
}
POLICY



}

