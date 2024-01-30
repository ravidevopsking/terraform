resource "aws_lb_target_group" "catalogue" {
  name     = "${local.name}-${var.tags.Component}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc_id.value
  deregistration_delay = 60
  health_check {
      healthy_threshold   = 2
      interval            = 10
      unhealthy_threshold = 3
      timeout             = 5
      path                = "/health"
      port                = 8080
      matcher = "200-299"
  }
}

module "catalogue" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.centos8.id
  name                   = "${local.name}-${var.tags.Component}-ami"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]
  subnet_id              = element(split(",", data.aws_ssm_parameter.private_subnet_ids.value), 0)
  iam_instance_profile = "ShellScriptRoleForRoboshop"   #here need to give my role name, admin role in iam
  tags = merge(
    var.common_tags,
    var.tags
  )
}

#1.After any changes to catalogue server, we want to update it in next version/release in VM based approach.
#2.create new catalogue instance, apply all new sprint configurations/changes using ansible
#3.stop the instance and take the latest created ami
#4.Delete the instance
#5.create launch template using above latest ami
#6.using autoscaling group launch template, update the existing catalouge servers using rolling strategy update
#i.e one by one old catalogue instance terminates, and new catalougue instance created using launch template.
#nothing but old servers are rolling updated with new version/release in VM based approach, not containarisation approach

resource "null_resource" "catalogue" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.catalogue.id  #whenever there is a change , trigger
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host = module.catalogue.private_ip
    type = "ssh"
    user = "centos"
    password = "DevOps321"
  }

  provisioner "file" {          #copying from local to remote
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh catalogue dev"  #catalogue is $1, dev is $2, bootstrap.sh is $0
    ]
  }
}

resource "aws_ec2_instance_state" "catalogue" {
  instance_id = module.catalogue.id
  state       = "stopped"                                       #created instance stopped
  depends_on = [ null_resource.catalogue ]
}

resource "aws_ami_from_instance" "catalogue" {
  name               = "${local.name}-${var.tags.Component}-${local.current_time}"
  source_instance_id = module.catalogue.id                      #ami taken from created instance
  depends_on = [ aws_ec2_instance_state.catalogue ]
}

resource "null_resource" "catalogue_delete" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.catalogue.id
  }

  provisioner "local-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    command = "aws ec2 terminate-instances --instance-ids ${module.catalogue.id}"  #terminates the latest created instance
  }

  depends_on = [ aws_ami_from_instance.catalogue]
}

resource "aws_launch_template" "catalogue" {                    #creating launch template with latest ami
  name = "${local.name}-${var.tags.Component}"

  image_id = aws_ami_from_instance.catalogue.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t2.micro"
  update_default_version = true

  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${local.name}-${var.tags.Component}"
    }
  }

}

#using autoscaling group replace/terminates old instance with new instances which were created using launchtemplate
resource "aws_autoscaling_group" "catalogue" {                         
  name                      = "${local.name}-${var.tags.Component}"
  max_size                  = 10
  min_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 2
  vpc_zone_identifier       = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
  target_group_arns = [ aws_lb_target_group.catalogue.arn ]
  
  launch_template {
    id      = aws_launch_template.catalogue.id
    version = aws_launch_template.catalogue.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }

  tag {
    key                 = "Name"
    value               = "${local.name}-${var.tags.Component}"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }
}

resource "aws_lb_listener_rule" "catalogue" {
  listener_arn = data.aws_ssm_parameter.app_alb_listener_arn.value
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue.arn
  }


  condition {
    host_header {
      values = ["${var.tags.Component}.app-${var.environment}.${var.zone_name}"]
    }
  }
}

resource "aws_autoscaling_policy" "catalogue" {
  autoscaling_group_name = aws_autoscaling_group.catalogue.name
  name                   = "${local.name}-${var.tags.Component}"
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 5.0
  }
}