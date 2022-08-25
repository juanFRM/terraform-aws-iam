resource "aws_iam_role" "codebuild_role" {
  count              = var.environment == "dev" ? 1 : 0
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
  count  = var.environment == "dev" ? 1 : 0
  name   = "access_aws_services"
  policy = one(data.aws_iam_policy_document.codebuild_role_policy_document.*.json)
  role   = one(aws_iam_role.codebuild_role.*.id)
}

data "aws_iam_policy_document" "codebuild_role_policy_document" {
  count = var.environment == "dev" ? 1 : 0
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
    actions   = ["sts:Assume"]
    resources = var.crossaccount_roles
  }

}

# API Gateway Role
resource "aws_iam_role" "apigateway_role" {
  name               = "${var.project_main_prefix}-${var.environment}-apigw-role"
  path               = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_role_policy" "apigateway_role_policy" {
  name   = "apigw_policy"
  role   = aws_iam_role.apigateway_role.id
  policy = data.aws_iam_policy_document.apigateway_role_policy_document.json
}

data "aws_iam_policy_document" "apigateway_role_policy_document" {

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:FilterLogEvents"
    ]
    resources = [
      "*"
    ]
  }

}

#Lambda Role

resource "aws_iam_role" "lambda_role" {
  name               = "${var.project_main_prefix}-lambda"
  path               = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_role_policy" {
  name   = "lambda_policy"
  role   = aws_iam_role.lambda_role.id
  policy = data.aws_iam_policy_document.lambda_role_policy_document.json
}


data "aws_iam_policy_document" "lambda_role_policy_document" {

  statement {
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:Describe*",
      "ec2:DeleteNetworkInterface",
      "ec2:DetachNetworkInterface"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/lambda/*"
    ]
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:HeadObject",
      "s3:CopyObject",
      "s3:PutObjectAcl",
      "s3:List*",
      "s3:CreateMultipartUpload"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "ses:*",
      "logs:*"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "execute-api:Invoke"
    ]

    resources = [
      "arn:aws:lambda:${var.region}:${var.account_id}:*"
    ]
  }

  statement {
    actions = [
      "cognito-identity:Describe*",
      "cognito-identity:Get*",
      "cognito-identity:List*",
      "cognito-idp:Describe*",
      "cognito-idp:AdminGet*",

      "cognito-idp:AdminConfirmSignUp",
      "cognito-idp:AdminList*",
      "cognito-idp:List*",
      "cognito-idp:Get*",
      "cognito-sync:Describe*",
      "cognito-sync:Get*",
      "cognito-sync:List*",
      "iam:ListOpenIdConnectProviders",
      "cognito-idp:AdminInitiateAuth",
      "iam:ListRoles",
      "sns:ListPlatformApplications",
      "cognito-idp:AdminUpdateUserAttributes"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "cognito-idp:AdminCreateUser",
      "cognito-idp:AdminAddUserToGroup",
      "cognito-idp:AdminRemoveUserFromGroup",
      "cognito-idp:AdminSetUserPassword",
      "cognito-idp:AdminDeleteUser"
    ]

    resources = [
      "arn:aws:cognito-idp:${var.region}:${var.account_id}:userpool/*"
    ]
  }

  statement {
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
      "kms:CreateGrant"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "sns:Publish",
      "sns:SetSMSAttributes"
    ]
    resources = [
      "*"
    ]
  }
}