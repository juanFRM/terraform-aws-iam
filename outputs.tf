output "codebuild_role" {
  value = one(aws_iam_role.codebuild_role.*.arn)
}

output "crossaccount_codebuild_role" {
  value = var.environment != "dev" ? one(aws_iam_role.crossaccount_role.*.arn) : ""
}
