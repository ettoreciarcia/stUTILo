# resource "aws_cloudwatch_log_group" "lambda_scale_down_log_group" {
#   name              = "/aws/eks/${var.cluster_name}/${var.}"
#   retention_in_days = 7
# }