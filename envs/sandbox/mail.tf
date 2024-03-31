provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_ses_domain_identity" "okmtdev" {
  domain = "okmtdev.com"
}

resource "aws_ses_email_identity" "okmtdev" {
  email = "okmtdev@okmtdev.com"
}

resource "aws_iam_user" "ses_smtp_user" {
  name = "ses-smtp-user"
}

resource "aws_iam_user_policy" "ses_smtp_user_policy" {
  name = "ses-smtp-user-policy"
  user = aws_iam_user.ses_smtp_user.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ses:SendEmail",
          "ses:SendRawEmail"
        ],
        Resource = "*"
      },
    ]
  })
}

# SMTP認証情報を生成
resource "aws_iam_access_key" "ses_smtp_user_key" {
  user = aws_iam_user.ses_smtp_user.name
}

# 出力
output "smtp_username" {
  value     = aws_iam_access_key.ses_smtp_user_key.id
  sensitive = true
}

output "smtp_password" {
  value     = aws_iam_access_key.ses_smtp_user_key.secret
  sensitive = true
}

resource "aws_route53_record" "ses_domain_verification" {
  zone_id = var.zone_id
  name    = aws_ses_domain_identity.okmtdev.domain
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.okmtdev.verification_token]
}

# terraform apply -target=aws_ses_domain_dkim.okmtdev
resource "aws_ses_domain_dkim" "okmtdev" {
  domain = aws_ses_domain_identity.okmtdev.domain
}

resource "aws_route53_record" "dkim" {
  count   = length(aws_ses_domain_dkim.okmtdev.dkim_tokens)
  zone_id = var.zone_id
  name    = "${element(aws_ses_domain_dkim.okmtdev.dkim_tokens, count.index)}._domainkey.okmtdev.com"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.okmtdev.dkim_tokens, count.index)}.dkim.amazonses.com"]
}
