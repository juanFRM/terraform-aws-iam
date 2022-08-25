resource "aws_iam_role" "crossaccount_role" {
  count               = var.environment != "dev" ? 1 : 0
  name                = "${var.project_main_prefix}-codebuild-${var.environment}"
  assume_role_policy  = data.aws_iam_policy_document.assume_crossaccount_role.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

data "aws_iam_policy_document" "assume_crossaccount_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com", "cloudformation.amazonaws.com", "codebuild.amazonaws.com", "codepipeline.amazonaws.com"]
    }

    principals {
      type        = "AWS"
      identifiers = [var.codepipeline_dev_role]
    }
  }
}