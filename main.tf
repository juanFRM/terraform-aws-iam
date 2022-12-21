resource "aws_iam_role" "codebuild_role" {
  name               = "${var.project_main_prefix}-codebuild"
  assume_role_policy = data.aws_iam_policy_document.codebuild_role_assume.json
}

data "aws_iam_policy_document" "codebuild_role_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com", "codepipeline.amazonaws.com", "ec2.amazonaws.com", "codedeploy.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "codebuild_role_policy" {
  name   = "access_aws_services"
  policy = data.aws_iam_policy_document.codebuild_role_policy_document.json
  role   = aws_iam_role.codebuild_role.id
}

data "aws_iam_policy_document" "codebuild_role_policy_document" {
  statement {
    actions = [
      "s3:*"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]

    resources = ["*"]
  }


  statement {
    actions = [
      "logs:*"
    ]

    resources = ["*"]
  }



  statement {
    actions = [
      "ssm:GetParameter",
      "ssm:PutParameter",
      "ssm:GetParameters",
      "ssm:AddTagsToResource"
    ]

    resources = ["*"]
  }


  statement {
    actions = [
      "cloudformation:*",
      "lambda:*",
      "apigateway:*",
      "apigateway:PUT",
      "apigateway:PATCH",
      "apigateway:DELETE",
      "apigateway:UpdateRestApiPolicy",
      "events:DescribeRule",
      "events:DeleteRule",
      "events:ListRuleNamesByTarget",
      "events:ListTargetsByRule",
      "events:PutRule",
      "events:PutTargets",
      "events:RemoveTargets",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfiles",
      "iam:ListRoles",
      "ec2:*",
      "elasticloadbalancing:*"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "iam:GetRole",
      "iam:PassRole"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "kms:*"
    ]

    resources = [
      "*"
    ]
  }
  statement {
    actions = [
      "eks:*",
      "ecr:*",
      "ecs:*"

    ]

    resources = [
      "*"
    ]
  }
  statement {
    actions = [
      "cloudfront:CreateInvalidation",
    ]

    resources = [
      "*"
    ]
  }
  statement {
    actions = [
      "codestar-connections:*",
      "cloudwatch:*"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "appsync:*"
    ]
    resources = ["*"]
  }


  statement {
    actions = [
      "dynamodb:Create*",
      "dynamodb:Restore*",
      "dynamodb:Update*",
      "dynamodb:Describe*",
      "dynamodb:List*",
      "dynamodb:Get",
      "dynamodb:Put*",
      "dynamodb:Import*",
      "dynamodb:Export*",
      "dynamodb:Batch*",
      "dynamodb:PartiQL*",
      "dynamodb:Query",
      "dynamodb:StartAwsBackupJob",
      "dynamodb:TagResource",
      "dynamodb:UntagResource",
      "dynamodb:Scan",
      "dynamodb:EnableKinesisStreamingDestination",
      "dynamodb:DisableKinesisStreamingDestination",
      "dynamodb:ConditionCheckItem",
    ]
    resources = [
      "*"
    ]
  }

  statement {
    actions   = ["sts:AssumeRole"]
    resources = var.crossaccount_roles
  }

  statement {
    actions = [
      "codecommit:*"
    ]
    resources = ["*"]
  }
}

