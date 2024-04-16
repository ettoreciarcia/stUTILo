resource "aws_cloudwatch_event_rule" "scale_up_event" {
  name        = "scale_up_cron"
  description = "Scale up the EKS cluster"

  schedule_expression = var.scale_up_schedule
}

resource "aws_cloudwatch_event_target" "event_scale_up" {
  rule      = aws_cloudwatch_event_rule.scale_up_event.name
  target_id = aws_lambda_function.function_scale_up.function_name
  arn       = aws_lambda_function.function_scale_up.arn
}
