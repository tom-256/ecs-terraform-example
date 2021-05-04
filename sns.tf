resource "aws_sns_topic" "ses_bounce" {
  name = "${var.env}-ses-bounce"
}

resource "aws_sns_topic" "ses_complaint" {
  name = "${var.env}-ses-complaint"
}
