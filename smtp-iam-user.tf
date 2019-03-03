# Policy: SMTP user for Postfix
data "aws_iam_policy_document" "smtp_user" {
  statement {
    sid     = "SmtpAccess"
    effect  = "Allow"
    actions = ["ses:SendEmail", "ses:SendRawEmail"]

    resources = ["*"]
  }
}

# Policy for SMTP user
resource "aws_iam_policy" "smtp_user" {
  name_prefix = "cust_${var.customer_name}_smtp_user_"
  description = "SES access for Postfix to send email through SES"
  policy      = "${data.aws_iam_policy_document.smtp_user.json}"
}

resource "aws_iam_user" "smtp_user" {
  name = "cust_${var.customer_name}_smtp_user"
}

resource "aws_iam_user_policy_attachment" "smtp_user" {
  user       = "${aws_iam_user.smtp_user.name}"
  policy_arn = "${aws_iam_policy.smtp_user.arn}"
}

resource "aws_iam_access_key" "smtp_access_key" {
  user = "${aws_iam_user.smtp_user.name}"
}
