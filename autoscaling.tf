
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.owner}_asg_scale_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "SimpleScaling"
  cooldown               = 300
  autoscaling_group_name = module.eh_asg.this_autoscaling_group_name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.owner}_asg_scale_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "SimpleScaling"
  cooldown               = 600
  autoscaling_group_name = module.eh_asg.this_autoscaling_group_name
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.owner}_asg_cpu_utilization_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 90

  dimensions = {
    AutoScalingGroupName = module.eh_asg.this_autoscaling_group_name
  }

  alarm_description = "Scale up if CPU utilization is above 90 for 300 seconds"
  alarm_actions     = [aws_autoscaling_policy.scale_up.arn]

  tags = local.tags
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "${var.owner}_asg_cpu_utilization_low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 600
  statistic           = "Average"
  threshold           = 10

  dimensions = {
    AutoScalingGroupName = module.eh_asg.this_autoscaling_group_name
  }

  alarm_description = "Scale down if the CPU utilization is below 10 for 600 seconds"
  alarm_actions     = [join("", aws_autoscaling_policy.scale_down.*.arn)]

  tags = local.tags
}