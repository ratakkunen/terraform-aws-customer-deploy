resource "aws_efs_file_system" "main" {
  encrypted = true

  tags {
    Name      = "${var.customer_name}"
    terraform = "true"
  }
}

resource "aws_efs_mount_target" "main" {
  count = "3"

  file_system_id  = "${aws_efs_file_system.main.id}"
  subnet_id       = "${element(var.private_subnets, count.index)}"
  security_groups = ["${aws_security_group.efs.id}"]
}
