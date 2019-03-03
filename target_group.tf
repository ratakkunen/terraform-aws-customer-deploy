# InfoLease

resource "aws_autoscaling_attachment" "infolease_asg" {
  autoscaling_group_name = "${aws_autoscaling_group.infolease.name}"
  alb_target_group_arn   = "${aws_lb_target_group.infolease.arn}"
}

resource "aws_lb_listener_rule" "il_http" {
  #  count = "${length(var.alb_http_listener_arn) > 0 ? 1 : 0}"
  count        = "1"
  listener_arn = "${var.alb_http_listener_arn}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.infolease.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${var.infolease_hostname}"]
  }
}

resource "aws_lb_listener_rule" "il_https" {
  #  count = "${length(var.alb_https_listener_arn) > 0 ? 1 : 0}"
  count        = "1"
  listener_arn = "${var.alb_https_listener_arn}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.infolease.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${var.infolease_hostname}"]
  }
}

resource "aws_lb_target_group" "infolease" {
  port        = 8080
  protocol    = "HTTP"
  name        = "${replace(var.customer_name, "/[ _]/", "-")}-IL"
  vpc_id      = "${var.vpc_id}"
  target_type = "instance"

  tags {
    Customer    = "${var.customer_name}"
    Application = "InfoLease"
  }

  health_check {
    interval            = "30"
    path                = "/demoserver.html"
    healthy_threshold   = "3"
    unhealthy_threshold = "5"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Rapport

resource "aws_autoscaling_attachment" "rapport_asg" {
  autoscaling_group_name = "${aws_autoscaling_group.rapport.name}"
  alb_target_group_arn   = "${aws_lb_target_group.rapport.arn}"
}

resource "aws_lb_listener_rule" "rapport_http" {
  #  count = "${length(var.alb_http_listener_arn) > 0 ? 1 : 0}"
  count        = "1"
  listener_arn = "${var.alb_http_listener_arn}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.rapport.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${var.rapport_hostname}"]
  }
}

resource "aws_lb_listener_rule" "rapport_https" {
  #  count = "${length(var.alb_https_listener_arn) > 0 ? 1 : 0}"
  count        = "1"
  listener_arn = "${var.alb_https_listener_arn}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.rapport.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${var.rapport_hostname}"]
  }
}

resource "aws_lb_target_group" "rapport" {
  port        = 80
  protocol    = "HTTP"
  name        = "${replace(var.customer_name, "/[ _]/", "-")}-Rapport"
  vpc_id      = "${var.vpc_id}"
  target_type = "instance"

  tags {
    Customer    = "${var.customer_name}"
    Application = "Rapport"
  }

  health_check {
    interval            = "30"
    path                = "/demoserver.html"
    healthy_threshold   = "3"
    unhealthy_threshold = "5"
  }
}

# Reporting

resource "aws_autoscaling_attachment" "reporting_asg" {
  autoscaling_group_name = "${aws_autoscaling_group.reporting.name}"
  alb_target_group_arn   = "${aws_lb_target_group.reporting.arn}"
}

resource "aws_lb_listener_rule" "reporting_http" {
  #  count = "${length(var.alb_http_listener_arn) > 0 ? 1 : 0}"
  count        = "1"
  listener_arn = "${var.alb_http_listener_arn}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.reporting.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${random_string.rand_hostname.result}.do-not-use.local"]
  }

  depends_on = ["random_string.rand_hostname"]
}

resource "aws_lb_listener_rule" "reporting_https" {
  #  count = "${length(var.alb_https_listener_arn) > 0 ? 1 : 0}"
  count        = "1"
  listener_arn = "${var.alb_https_listener_arn}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.reporting.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${random_string.rand_hostname.result}.do-not-use.local"]
  }

  depends_on = ["random_string.rand_hostname"]
}

resource "aws_lb_target_group" "reporting" {
  port        = 8080
  protocol    = "HTTP"
  name        = "${replace(var.customer_name, "/[ _]/", "-")}-Reporting"
  vpc_id      = "${var.vpc_id}"
  target_type = "instance"

  tags {
    Customer    = "${var.customer_name}"
    Application = "Reporting"
  }

  health_check {
    interval            = "30"
    path                = "/demoserver.html"
    healthy_threshold   = "3"
    unhealthy_threshold = "5"
  }
}
