output "codebuild_role" {
  value = one(aws_iam_role.codebuild_role.*.arn)
}
