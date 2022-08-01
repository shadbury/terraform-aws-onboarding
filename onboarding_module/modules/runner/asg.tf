resource "aws_autoscaling_group" "gitlab_runner" {
  name_prefix         = "gitlab-runner"
  max_size            = 10
  min_size            = 0
  desired_capacity    = 1
  vpc_zone_identifier = var.gitlab_runner_use_private_subnet ? data.aws_subnet_ids.private.ids : data.aws_subnet_ids.public.ids

  enabled_metrics = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]

  mixed_instances_policy {
    instances_distribution {
      on_demand_allocation_strategy            = "prioritized"
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 0
      spot_allocation_strategy                 = "lowest-price"
      spot_instance_pools                      = 10
      spot_max_price                           = ""
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.gitlab_runner.id
        version            = "$Latest"
      }
    }
  }

  tags = [
    {
      "key"                 = "Name"
      "value"               = "gitlab-runner"
      "propagate_at_launch" = "true"
    }
  ]
}

resource "aws_launch_template" "gitlab_runner" {
  name_prefix   = "gitlab-runner"
  image_id      = data.aws_ami.amazonlinux2.id
  instance_type = local.workspace.instance_type

  user_data              = base64encode(data.template_file.gitlab_runner.rendered)
  vpc_security_group_ids = [aws_security_group.gitlab_runner.id]
  iam_instance_profile { name = aws_iam_instance_profile.gitlab_runner.name }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 50
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }
  monitoring { enabled = true }
  lifecycle { create_before_destroy = true }
}

resource "aws_security_group" "gitlab_runner" {
  name        = "gitlab-runner"
  description = "Gitlab Runner"
  vpc_id      = data.aws_vpc.mainvpc.id
}

resource "aws_security_group_rule" "gitlab_runner_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  security_group_id = aws_security_group.gitlab_runner.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_iam_instance_profile" "gitlab_runner" {
  name_prefix = "gitlab_runner"
  role        = aws_iam_role.gitlab_runner.name
}

data "template_file" "gitlab_runner" {
  template = file("${path.module}/userdata.sh.tpl")
  vars = {
    aws_region    = local.workspace.aws_region
    gitlab_url    = local.workspace.gitlab_url
    concurrency   = local.workspace.concurrency
  }
}
