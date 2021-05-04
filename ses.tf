resource "aws_ses_domain_identity" "main" {
  domain = var.domain
}
resource "aws_ses_domain_dkim" "main" {
  domain = aws_ses_domain_identity.main.domain
}
resource "aws_route53_record" "ses" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "_amazonses.${aws_route53_zone.main.name}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.main.verification_token]
}
resource "aws_route53_record" "ses_dkim" {
  # https://docs.aws.amazon.com/ses/latest/dg/send-email-authentication-dkim-easy-setup-domain.html
  # > Copy the three CNAME records that appear in this section
  count   = 3
  zone_id = aws_route53_zone.main.zone_id
  name    = "${element(aws_ses_domain_dkim.main.dkim_tokens, count.index)}._domainkey"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.main.dkim_tokens, count.index)}.dkim.amazonses.com"]
}