# Locate the AMI
data "aws_ami" "reporting" {
  most_recent = true
  owners      = ["${var.ami_owners}"]

  filter {
    name   = "tag:Application"
    values = ["Reporting"]
  }

  filter {
    name   = "tag:PentahoVersion"
    values = ["${var.reporting_pentaho_version}"]
  }

  filter {
    name   = "tag:IDSReportingVersion"
    values = ["${var.reporting_idsreporting_version}"]
  }

  filter {
    name   = "tag:InfoLeaseReportingVersion"
    values = ["${var.reporting_infoleasereporting_version}"]
  }

  filter {
    name   = "tag:RapportReportingVersion"
    values = ["${var.reporting_rapportreporting_version}"]
  }
}

# User data template
data "template_file" "reporting_userdata_script" {
  template = "${file("${path.module}/include/reporting-userdata.sh.tpl")}"

  vars {
    customer_number         = "${var.customer_number}"
    s3_configuration_bucket = "${var.s3_configuration_bucket}"
    s3_interfaces_bucket    = "${local.s3_interfaces_bucket}"
    s3_origination_bucket   = "${local.s3_origination_bucket}"
    s3_insurance_bucket     = "${local.s3_insurance_bucket}"
    s3_bank_bucket          = "${local.s3_bank_bucket}"
    customer_name           = "${var.customer_name}"
    route53_zone_id         = "${aws_route53_zone.main.zone_id}"
    route53_zone_name       = "${aws_route53_zone.main.name}"
    s3fs_iam_role           = "${aws_iam_role.reporting_instance_role.name}"
    aws_region              = "${data.aws_region.current.name}"
    ids_product             = "Reporting"
    ids_product_version     = "${var.reporting_idsreporting_version}"
    ids_environment         = "${var.environment}"
    nfs_hostname            = "${aws_efs_file_system.main.dns_name}"
    log_group_name          = "${var.customer_name}/reporting"
    service_hostname        = "reporting"
  }
}

# Launch Configuration
resource "aws_launch_configuration" "reporting" {
  name_prefix          = "${var.customer_name}_Reporting_"
  instance_type        = "${var.reporting_instance_type}"
  image_id             = "${data.aws_ami.reporting.id}"
  enable_monitoring    = false
  security_groups      = ["${concat(list(aws_security_group.reporting.id), var.additional_security_groups)}"]
  iam_instance_profile = "${aws_iam_instance_profile.reporting_instance_profile.name}"
  key_name             = "${var.key_name}"

  user_data = "${data.template_file.reporting_userdata_script.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "reporting" {
  name_prefix               = "${var.customer_name}_Reporting_"
  min_size                  = "${var.min_reporting_servers}"
  max_size                  = "${var.max_reporting_servers}"
  desired_capacity          = "${var.desired_reporting_servers}"
  health_check_grace_period = 300
  health_check_type         = "ELB"                                        # TODO: change to ELB
  launch_configuration      = "${aws_launch_configuration.reporting.name}"
  vpc_zone_identifier       = ["${var.private_subnets}"]
  suspended_processes       = "${var.asg_suspended_processes}"

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.customer_name}_Reporting"
    propagate_at_launch = true
  }

  tag {
    key                 = "Customer"
    value               = "${var.customer_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Application"
    value               = "Reporting"
    propagate_at_launch = true
  }

  tag {
    key                 = "Customer-Application"
    value               = "${var.customer_name}-Reporting"
    propagate_at_launch = true
  }
}
