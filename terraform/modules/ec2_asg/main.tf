data "aws_region" "current" {}

locals {
  name                        = replace(var.name, "_", "-")
}

resource "aws_launch_configuration" "default" {
  associate_public_ip_address = false
  ebs_optimized               = var.tf_vars.ec2_asg['launch_config']["ebs_optimized"]
  enable_monitoring           = tobool(var.tf_vars.ec2_asg['launch_config']["enable_monitoring"])
  iam_instance_profile        = var.iam_instance_profile.arn
  image_id                    = var.ami_id
  instance_type               = var.tf_vars.ec2_asg['launch_config']["instance_type"]
  key_name                    = var.key_pair.key_name
  name_prefix                 = "${local.name}-"
  security_groups             = var.security_group_ids
  user_data                   = var.user_data

  root_block_device {
    volume_type               = "gp2"
    volume_size               = tonumber(var.tf_vars.launch_config["root_volume_size"])
    delete_on_termination     = true
  }
}

resource "aws_autoscaling_group" "default" {
  depends_on                  = [aws_launch_configuration.default]
  name                        = "${aws_launch_configuration.default.name}-asg"
  max_size                    = var.tf_vars.ec2_asg['autoscale_group']["max_capacity"]
  min_size                    = var.tf_vars.ec2_asg['autoscale_group']["min_capacity"]
  health_check_grace_period   = var.tf_vars.ec2_asg['autoscale_group']["health_check_grace_period"]
  health_check_type           = var.tf_vars.ec2_asg['autoscale_group']["health_check_type"]
  desired_capacity            = var.tf_vars.ec2_asg['autoscale_group']["desired_capacity"]
  force_delete                = true
  launch_configuration        = aws_launch_configuration.default.name
  # target_group_arns           = ""
  vpc_zone_identifier         = var.subnet_ids

  enabled_metrics             = [
    "GroupDesiredCapacity",
    "GroupInServiceCapacity",
    "GroupPendingCapacity",
    "GroupMinSize",
    "GroupMaxSize",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyCapacity",
    "GroupTerminatingCapacity",
    "GroupTerminatingInstances",
    "GroupTotalCapacity",
    "GroupTotalInstances"
  ]

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy     = true
  }

  timeouts {
    delete                    = "15m"
  }

  # TODO: How to Make Custom Tags Dynamic?
  tag {
    key                       = "Environment"
    value                     = local.aws_tags.Environment
    propagate_at_launch       = true
  }
  tag {
    key                       = "Name"
    value                     = local.name
    propagate_at_launch       = true
  }
  tag {
    key                       = "Orchestrator_Version"
    value                     = local.aws_tags.Orchestrator_Version
    propagate_at_launch       = true
  }
  # TODO: How to Make Custom Tags Dynamic?
  tag {
    key                       = "Owner"
    value                     = local.aws_tags.Owner
    propagate_at_launch       = true
  }
  tag {
    key                       = "Terraform_Environment"
    value                     = local.aws_tags.Terraform_Environment
    propagate_at_launch       = true
  }
  tag {
    key                       = "Terraform_Module"
    value                     = local.aws_tags.Terraform_Module
    propagate_at_launch       = true
  }
  tag {
    key                       = "Terraform_Role"
    value                     = local.aws_tags.Terraform_Role
    propagate_at_launch       = true
  }
  tag {
    key                       = "Terraform_Version"
    value                     = local.aws_tags.Terraform_Version
    propagate_at_launch       = true
  }
  tag {
    key                       = "Terraform_Workspace"
    value                     = terraform.workspace
    propagate_at_launch       = true
  }
}

resource "aws_autoscaling_notification" "default" {
  group_names                 = [aws_autoscaling_group.default.name]

  notifications               = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn                   = var.sns_topic.arn
}

# Scale UP Alarm
resource "aws_autoscaling_policy" "policy_scale_up" {
  adjustment_type             = var.tf_vars.ec2_asg["policy_scale_up"]["adjustment_type"]
  autoscaling_group_name      = aws_autoscaling_group.default.name
  cooldown                    = var.tf_vars.ec2_asg["policy_scale_up"]["cooldown"]
  count                       = var.tf_vars.ec2_asg.autoscaling ? 1 : 0
  depends_on                  = [aws_autoscaling_group.default]
  name                        = "${local.name}-scale-up-policy"
  policy_type                 = var.tf_vars.ec2_asg["policy_scale_up"]["policy_type"]
  scaling_adjustment          = var.tf_vars.ec2_asg["policy_scale_up"]["scaling_adjustment"]
}

resource "aws_cloudwatch_metric_alarm" "cpu_high_alarm" {
  actions_enabled             = true
  alarm_actions               = [aws_autoscaling_policy.policy_scale_up[0].arn]
  alarm_description           = "High CPU Alarm"
  alarm_name                  = "${local.name}-cpu-high-alarm"
  comparison_operator         = "GreaterThanOrEqualToThreshold"
  count                       = var.tf_vars.ec2_asg.autoscaling ? 1 : 0
  depends_on                  = [aws_autoscaling_policy.policy_scale_up, aws_autoscaling_group.default]
  dimensions                  = {"AutoScalingGroupName" = aws_autoscaling_group.default.name}
  evaluation_periods          = var.tf_vars.ec2_asg["cpu_high_alarm"]["evaluation_periods"]
  metric_name                 = "CPUUtilization"
  namespace                   = "AWS/EC2"
  period                      = var.tf_vars.ec2_asg["cpu_high_alarm"]["period"]
  statistic                   = var.tf_vars.ec2_asg["cpu_high_alarm"]["statistic"]
  threshold                   = var.tf_vars.ec2_asg["cpu_high_alarm"]["threshold"]
}

# Scale Down Alarm
resource "aws_autoscaling_policy" "policy_scale_down" {
  adjustment_type             = var.tf_vars.ec2_asg["policy_scale_down"]["adjustment_type"]
  autoscaling_group_name      = aws_autoscaling_group.default.name
  cooldown                    = var.tf_vars.ec2_asg["policy_scale_down"]["cooldown"]
  count                       = var.tf_vars.ec2_asg.autoscaling ? 1 : 0
  depends_on                  = [aws_autoscaling_group.default]
  name                        = "${local.name}-scale-down-policy"
  policy_type                 = var.tf_vars.ec2_asg["policy_scale_down"]["policy_type"]
  scaling_adjustment          = var.tf_vars.ec2_asg["policy_scale_down"]["scaling_adjustment"]
}

resource "aws_cloudwatch_metric_alarm" "cpu_low_alarm" {
  actions_enabled             = true
  alarm_actions               = [aws_autoscaling_policy.policy_scale_down[0].arn]
  alarm_description           = "Low CPU Alarm"
  alarm_name                  = "${local.name}-cpu-low-alarm"
  comparison_operator         = "LessThanOrEqualToThreshold"
  count                       = var.tf_vars.ec2_asg.autoscaling ? 1 : 0
  depends_on                  = [aws_autoscaling_policy.policy_scale_down, aws_autoscaling_group.default]
  dimensions                  = {"AutoScalingGroupName" = aws_autoscaling_group.default.name}
  evaluation_periods          = var.tf_vars.ec2_asg["cpu_low_alarm"]["evaluation_periods"]
  metric_name                 = "CPUUtilization"
  namespace                   = "AWS/EC2"
  period                      = var.tf_vars.ec2_asg["cpu_low_alarm"]["period"]
  statistic                   = var.tf_vars.ec2_asg["cpu_low_alarm"]["statistic"]
  threshold                   = var.tf_vars.ec2_asg["cpu_low_alarm"]["threshold"]
}
