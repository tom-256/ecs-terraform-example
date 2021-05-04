resource "aws_cloudwatch_metric_alarm" "ses_bounce" {
  alarm_name          = "${var.env}-ses-bounce"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  period              = "300"
  statistic           = "Average"
  metric_name         = "Reputation.BounceRate"
  namespace           = "AWS/SES"
  threshold           = "0.05"
  alarm_description   = "ses bounce metorics"
  alarm_actions       = [aws_sns_topic.ses_bounce.arn]
  ok_actions          = [aws_sns_topic.ses_bounce.arn]
}

resource "aws_cloudwatch_metric_alarm" "ses_complaint" {
  alarm_name          = "${var.env}-ses-complaint"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  period              = "300"
  statistic           = "Average"
  metric_name         = "Reputation.ComplaintRate"
  namespace           = "AWS/SES"
  threshold           = "0.001"
  alarm_description   = "ses bounce metorics"
  alarm_actions       = [aws_sns_topic.ses_complaint.arn]
  ok_actions          = [aws_sns_topic.ses_complaint.arn]
}
