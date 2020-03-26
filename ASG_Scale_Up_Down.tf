resource "aws_autoscaling_group" "autoscaling-group-app" {
  name                      = "autoscaling-group-app"
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 30
  health_check_type         = "ELB"
  desired_capacity          = 3
  force_delete              = true
  default_cooldown = 30

  load_balancers = ["${aws_elb.app-elb.name}"]
 #placement_group           = "${aws_placement_group.test.id}"
 #launch_configuration      = "${aws_launch_configuration.foobar.name}"
 #count = "${length(var.subnet_cidr)}"

  vpc_zone_identifier       = "${aws_subnet.public.*.id}"
#availability_zones = "${element(var.avlzone,count.index)}"
launch_configuration = "${aws_launch_configuration.ec2-config.name}"
#vpc_id = "${aws_vpc.app_vpc.id}"

 }

resource "aws_launch_configuration" "ec2-config" {
  name_prefix   = "ec2-config"
  image_id      = "${var.webservers_ami}"
  instance_type = "${var.instance_type}"
  key_name      = "asg_up_down_test"
  security_groups = ["${aws_security_group.secgp-webservers.id}"]
associate_public_ip_address = true
#vpc_id = "${aws_vpc.app_vpc.id}"
user_data       = "${file("shell.sh")}"
}



#Defining ASG Policy to scale in

resource "aws_autoscaling_policy" "avg_cpu_alert_70" {
  name = "avg_cpu_alert_70"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 30
  autoscaling_group_name = "${aws_autoscaling_group.autoscaling-group-app.name}"
}

resource "aws_cloudwatch_metric_alarm" "CW_avg_cpu_alert_70" {
  alarm_name = "avg_cpu_alert_70"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "60"
  statistic = "Average"
  threshold = "70"

dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.autoscaling-group-app.name}"
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = ["${aws_autoscaling_policy.avg_cpu_alert_70.arn}"]
}

#Defining ASG Policy to scale down

resource "aws_autoscaling_policy" "avg_cpu_alert_60" {
  name = "avg_cpu_alert_60"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 30
  autoscaling_group_name = "${aws_autoscaling_group.autoscaling-group-app.name}"
}

resource "aws_cloudwatch_metric_alarm" "CW_avg_cpu_alert_60" {
  alarm_name = "avg_cpu_alert_60"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "60"
  statistic = "Average"
  threshold = "60"
dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.autoscaling-group-app.name}"
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = ["${aws_autoscaling_policy.avg_cpu_alert_60.arn}"]
}

