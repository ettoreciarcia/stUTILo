locals {
  function_name               = "scale-down"
  function_handler            = "main.lambda_handler"
  function_runtime            = "python3.9"
  function_timeout_in_seconds = 10

  function_source_dir = "${path.module}/lambda/${local.function_name}"
}

resource "aws_lambda_function" "function_scale_down" {
  function_name = "${local.function_name}-${var.env_name}"
  handler       = local.function_handler
  runtime       = local.function_runtime
  timeout       = local.function_timeout_in_seconds

  filename         = "${local.function_source_dir}.zip"
  source_code_hash = data.archive_file.function__scale_down_zip.output_base64sha256

  role = aws_iam_role.scale_role_lambda.arn

  logging_config {
    log_format = "Text"
    # log_group  = aws_cloudwatch_log_group.lambda_scale_down_log_group.name
  }


  environment {
    variables = {
      ENVIRONMENT    = var.env_name
      REGION         = var.region
      CLUSTER_NAME   = var.cluster_name
      ASG_GROUP_INFO = jsonencode(var.autoscaling_groups_info)
    }
  }

}

data "archive_file" "function__scale_down_zip" {
  source_dir  = local.function_source_dir
  type        = "zip"
  output_path = "${local.function_source_dir}.zip"
}

resource "aws_lambda_alias" "scale_down_alias" {
  name             = "scale-down-${var.cluster_name}"
  description      = "Scale down EKS cluster"
  function_name    = aws_lambda_function.function_scale_down.function_name
  function_version = "$LATEST"
}

resource "aws_lambda_permission" "allow_cloudwatch_scale_down" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function_scale_down.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scale_down_event.arn
  # qualifier     = aws_lambda_alias.scale_down_alias.name #comment this line resolved issue with event bridge for lambda function
}
