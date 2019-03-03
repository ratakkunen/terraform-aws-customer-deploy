# InfoLease
resource "aws_security_group" "infolease" {
  vpc_id = "${var.vpc_id}"
  name   = "${var.customer_name}_IL"

  tags {
    Customer    = "${var.customer_name}"
    Application = "InfoLease"
  }
}

resource "aws_security_group_rule" "infolease_application" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "6"
  source_security_group_id = "${var.lb_security_group_id}"
  description              = "Application port from Load Balancer"
  security_group_id        = "${aws_security_group.infolease.id}"
}

resource "aws_security_group_rule" "infolease_application_from_reporting" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "6"
  source_security_group_id = "${aws_security_group.reporting.id}"
  description              = "Application port from Reporting"
  security_group_id        = "${aws_security_group.infolease.id}"
}

resource "aws_security_group_rule" "infolease_application_from_rapport" {
  type                     = "ingress"
  from_port                = 32457
  to_port                  = 32457
  protocol                 = "6"
  source_security_group_id = "${aws_security_group.rapport.id}"
  description              = "From Rapport"
  security_group_id        = "${aws_security_group.infolease.id}"
}

# TODO: Admin access, fix this later
resource "aws_security_group_rule" "infolease_admin" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "6"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Administrative SSH"
  security_group_id = "${aws_security_group.infolease.id}"
}

resource "aws_security_group_rule" "infolease_ids" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["${var.internal_ips}"]
  description       = "All traffic from IDS"
  security_group_id = "${aws_security_group.infolease.id}"
}

resource "aws_security_group_rule" "infolease_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Outbound traffic"
  security_group_id = "${aws_security_group.infolease.id}"
}

# Reporting
resource "aws_security_group" "reporting" {
  vpc_id = "${var.vpc_id}"
  name   = "${var.customer_name}_Reporting"

  tags {
    Customer    = "${var.customer_name}"
    Application = "Reporting"
  }
}

resource "aws_security_group_rule" "reporting_application" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "6"
  source_security_group_id = "${aws_security_group.infolease.id}"
  description              = "Application port from InfoLease"
  security_group_id        = "${aws_security_group.reporting.id}"
}

resource "aws_security_group_rule" "reporting_from_rapport" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "6"
  source_security_group_id = "${aws_security_group.rapport.id}"
  description              = "Application port from Rapport"
  security_group_id        = "${aws_security_group.reporting.id}"
}

# TODO: Admin access, fix this later
resource "aws_security_group_rule" "reporting_admin" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "6"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Administrative SSH"
  security_group_id = "${aws_security_group.reporting.id}"
}

resource "aws_security_group_rule" "reporting_ids" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["${var.internal_ips}"]
  description       = "All traffic from IDS"
  security_group_id = "${aws_security_group.reporting.id}"
}

resource "aws_security_group_rule" "reporting_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Outbound traffic"
  security_group_id = "${aws_security_group.reporting.id}"
}

# Rapport
resource "aws_security_group" "rapport" {
  vpc_id = "${var.vpc_id}"
  name   = "${var.customer_name}_Rapport"

  tags {
    Customer    = "${var.customer_name}"
    Application = "Rapport"
  }
}

resource "aws_security_group_rule" "rapport_application" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "6"
  source_security_group_id = "${var.lb_security_group_id}"
  description              = "Application port from Load Balancer"
  security_group_id        = "${aws_security_group.rapport.id}"
}

resource "aws_security_group_rule" "rapport_application_from_reporting" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "6"
  source_security_group_id = "${aws_security_group.reporting.id}"
  description              = "Application port from Reporting"
  security_group_id        = "${aws_security_group.rapport.id}"
}

# TODO: Admin access, fix this later
resource "aws_security_group_rule" "rapport_admin" {
  type              = "ingress"
  from_port         = 3389
  to_port           = 3389
  protocol          = "6"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Administrative RDP"
  security_group_id = "${aws_security_group.rapport.id}"
}

resource "aws_security_group_rule" "rapport_ids" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["${var.internal_ips}"]
  description       = "All traffic from IDS"
  security_group_id = "${aws_security_group.rapport.id}"
}

resource "aws_security_group_rule" "rapport_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Outbound traffic"
  security_group_id = "${aws_security_group.rapport.id}"
}

# EFS
resource "aws_security_group" "efs" {
  vpc_id = "${var.vpc_id}"
  name   = "${var.customer_name}_EFS"

  tags {
    Customer    = "${var.customer_name}"
    Application = "EFS"
  }
}

resource "aws_security_group_rule" "nfs_infolease" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "6"
  source_security_group_id = "${aws_security_group.infolease.id}"
  description              = "NFS traffic from InfoLease"
  security_group_id        = "${aws_security_group.efs.id}"
}

resource "aws_security_group_rule" "nfs_reporting" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "6"
  source_security_group_id = "${aws_security_group.reporting.id}"
  description              = "NFS traffic from Reporting"
  security_group_id        = "${aws_security_group.efs.id}"
}

resource "aws_security_group_rule" "reporting_application_from_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "6"
  source_security_group_id = "${var.lb_security_group_id}"
  description              = "Application port from Load Balancer for health check"
  security_group_id        = "${aws_security_group.reporting.id}"
}
