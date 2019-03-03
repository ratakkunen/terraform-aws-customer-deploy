# Locate the AMI
data "aws_ami" "rapport" {
  most_recent = true
  owners      = ["${var.ami_owners}"]

  filter {
    name   = "tag:Application"
    values = ["Rapport"]
  }

  filter {
    name   = "tag:Version"
    values = ["${var.rapport_version}"]
  }
}

# User data template
data "template_file" "rapport_userdata_script" {
  template = "${file("${path.module}/include/rapport-userdata.cmd.tpl")}"

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
    s3fs_iam_role           = "${aws_iam_role.rapport_instance_role.name}"
    aws_region              = "${data.aws_region.current.name}"
    ids_product             = "Rapport"
    ids_product_version     = "${var.rapport_version}"
    ids_environment         = "${var.environment}"

    #nfs_hostname            = "${aws_efs_file_system.main.dns_name}"
    log_group_name   = "${var.customer_name}/rapport"
    service_hostname = "rapport"
    rapport_hostname = "${var.rapport_hostname}"
  }
}

# Launch Configuration
resource "aws_launch_configuration" "rapport" {
  name_prefix          = "${var.customer_name}_Rapport_"
  instance_type        = "${var.rapport_instance_type}"
  image_id             = "${data.aws_ami.rapport.id}"
  enable_monitoring    = false
  security_groups      = ["${concat(list(aws_security_group.rapport.id), var.additional_security_groups)}"]
  iam_instance_profile = "${aws_iam_instance_profile.rapport_instance_profile.name}"
  key_name             = "${var.key_name}"

  user_data = "${data.template_file.rapport_userdata_script.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "rapport" {
  name_prefix               = "${var.customer_name}_Rapport_"
  min_size                  = "${var.min_rapport_servers}"
  max_size                  = "${var.max_rapport_servers}"
  desired_capacity          = "${var.desired_rapport_servers}"
  health_check_grace_period = 300
  health_check_type         = "ELB"                                      # TODO: change to ELB
  launch_configuration      = "${aws_launch_configuration.rapport.name}"
  vpc_zone_identifier       = ["${var.private_subnets}"]
  suspended_processes       = "${var.asg_suspended_processes}"

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.customer_name}_Rapport"
    propagate_at_launch = true
  }

  tag {
    key                 = "Customer"
    value               = "${var.customer_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Application"
    value               = "Rapport"
    propagate_at_launch = true
  }

  tag {
    key                 = "Customer-Application"
    value               = "${var.customer_name}-Rapport"
    propagate_at_launch = true
  }
}
