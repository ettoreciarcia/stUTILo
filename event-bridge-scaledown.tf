resource "aws_cloudwatch_event_rule" "scale_down_event" {
  name        = "scale_down_cron"
  description = "Scale down the EKS cluster"

  schedule_expression = var.scale_down_schedule

  depends_on = [
    aws_lambda_function.function_scale_down
  ]
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule      = aws_cloudwatch_event_rule.scale_down_event.name
  target_id = aws_lambda_function.function_scale_down.function_name
  arn       = aws_lambda_function.function_scale_down.arn
}
