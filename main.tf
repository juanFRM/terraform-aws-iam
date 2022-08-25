resource "aws_iam_role" "codebuild_role" {
  name               = "${var.project_main_prefix}-codebuild"
  assume_role_policy = data.aws_iam_policy_document.codebuild_role_assume.json
}

data "aws_iam_policy_document" "codebuild_role_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com", "codepipeline.amazonaws.com", "ec2.amazonaws.com"]
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
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
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
      "ec2:*"
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
      "kms:Encrypt",
      "kms:CreateGrant",
      "kms:Decrypt"
    ]

    resources = [
      "*"
    ]
  }
  statement {
    actions = [
      "eks:*",
      "ecr:*"
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
      "codestar-connections:*"
    ]
    resources = ["*"]
  }
  statement {
    actions   = ["sts:AssumeRole"]
    resources = var.crossaccount_roles
  }

}

