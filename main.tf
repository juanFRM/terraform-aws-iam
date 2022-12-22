resource "aws_iam_role" "codebuild_role" {
  name                = "${var.project_main_prefix}-codebuild"
  assume_role_policy  = data.aws_iam_policy_document.codebuild_role_assume.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

data "aws_iam_policy_document" "codebuild_role_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com", "codebuild.amazonaws.com", "codepipeline.amazonaws.com", "ec2.amazonaws.com", "codedeploy.amazonaws.com"]
    }
  }
}

