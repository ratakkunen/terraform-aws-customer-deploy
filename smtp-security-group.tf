resource "aws_security_group_rule" "infolease_smtp_from_reporting" {
  type                     = "ingress"
  from_port                = 25
  to_port                  = 25
  protocol                 = "6"
  source_security_group_id = "${aws_security_group.reporting.id}"
  description              = "SMTP from Reporting"
  security_group_id        = "${aws_security_group.infolease.id}"
}

resource "aws_security_group_rule" "infolease_smtp_from_rapport" {
  type                     = "ingress"
  from_port                = 25
  to_port                  = 25
  protocol                 = "6"
  source_security_group_id = "${aws_security_group.rapport.id}"
  description              = "SMTP from Rapport"
  security_group_id        = "${aws_security_group.infolease.id}"
}
