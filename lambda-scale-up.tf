

resource "aws_lambda_function" "function_scale_up" {
  function_name = "scale-up-${var.env_name}"
  handler       = local.function_handler
  runtime       = local.function_runtime
  timeout       = local.function_timeout_in_seconds

  filename         = "${path.module}/lambda/scale-up.zip"
  source_code_hash = data.archive_file.function_scale_up_zip.output_base64sha256

  role = aws_iam_role.scale_role_lambda.arn

  logging_config {
    application_log_level = var.log_level
    log_format            = var.log_format
    log_group             = aws_cloudwatch_log_group.lambda_scale_up_log_group.name
    system_log_level      = var.log_level
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

data "archive_file" "function_scale_up_zip" {
  source_dir  = "${path.module}/lambda/scale-up"
  type        = "zip"
  output_path = "${path.module}/lambda/scale-up.zip"
}


resource "aws_lambda_alias" "scale_up_alias" {
  name             = "scale-up-${var.cluster_name}"
  description      = "Scale up EKS cluster"
  function_name    = aws_lambda_function.function_scale_up.function_name
  function_version = "$LATEST"
}

resource "aws_lambda_permission" "allow_cloudwatch_scale_up" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function_scale_up.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scale_up_event.arn
  # qualifier     = aws_lambda_alias.scale_up_alias.name
}
