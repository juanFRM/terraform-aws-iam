output "codebuild_role" {
  value = one(aws_iam_role.codebuild_role.*.arn)
}

output "apigw_role" {
  value = aws_iam_role.apigateway_role.arn
}

output "lambda_role" {
  value = aws_iam_role.lambda_role.arn
}

output "crossaccount_codebuild_role" {
  value = var.environment != "dev" ? one(aws_iam_role.crossaccount_role.*.arn) : ""
}
