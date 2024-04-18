resource "aws_cloudwatch_log_group" "lambda_scale_down_log_group" {
  name              = "/aws/eks/${var.cluster_name}/lambda/scale-down"
  retention_in_days = var.log_retention_days
}

resource "aws_cloudwatch_log_group" "lambda_scale_up_log_group" {
  name              = "/aws/eks/${var.cluster_name}/lambda/scale-up"
  retention_in_days = var.log_retention_days
}