resource "aws_launch_template" "vault" {
  name_prefix = "${var.component_name}${var.environment}"

  image_id      = var.user_supplied_ami_id != null ? var.user_supplied_ami_id : data.aws_ami.ubuntu_ami[0].id
  instance_type = var.instance_type
  key_name      = var.key_name != null ? var.key_name : null
  user_data     = base64encode(local.vault_user_data)

  vpc_security_group_ids = [
    data.terraform_remote_state.vault_resources.outputs.vault_cluster_sg
  ]

  instance_market_options {
    market_type = "spot"

    spot_options {
      max_price = var.max_price
    }
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_type           = "gp3"
      volume_size           = 40
      throughput            = 150
      iops                  = 3000
      delete_on_termination = true
    }
  }

  iam_instance_profile {
    name = data.terraform_remote_state.vault_resources.outputs.vault_instance_profile
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags          = merge(local.common_tags, map("project", "vault-cluster"))
  }
}


resource "aws_autoscaling_group" "vault" {
  name_prefix = "${var.component_name}-asg-${var.environment}"

  min_size            = var.node_count
  max_size            = var.node_count
  desired_capacity    = var.node_count
  vpc_zone_identifier = data.terraform_remote_state.vpc.outputs.vault_consul_subnets
  target_group_arns   = [data.terraform_remote_state.vault_resources.outputs.vault_lb_target_group_arn]

  launch_template {
    id      = aws_launch_template.vault.id
    version = aws_launch_template.vault.latest_version
  }

  termination_policies      = var.termination_policies
  health_check_grace_period = var.asg_health_check_grace_period
  health_check_type         = var.health_check_type
  wait_for_elb_capacity     = var.asg_wait_for_elb_capacity
  wait_for_capacity_timeout = var.wait_for_capacity_timeout

  default_cooldown = var.default_cooldown

  lifecycle {
    create_before_destroy = true
  }


  dynamic "tag" {
    for_each = var.custom_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
