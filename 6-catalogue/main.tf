resource "aws_alb_target_group" "catalogue" {
    name = "${local.name}-${var.tags.Component}"
    port = 8080
    protocol = "HTTP"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    health_check {
      
      healthy_threshold = 2
      interval = 10
      unhealthy_threshold = 3
      timeout = 5
      path = "/health"
      port = 8080
      matcher = "200-299"

    }

  
}

module "catalogue" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  ami                    = "ami-0341d95f75f311023"
  name                   = "${local.name}-catalogue"
  instance_type          = "t2.small"
  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]
  key_name               = "bhavani"
  subnet_id              = element(split(",", data.aws_ssm_parameter.private_subnet_ids.value),0)
  iam_instance_profile = "Ec2role"

  tags = merge(
    var.common_tags,
    var.tags
  )
}

resource "null_resource" "catalogue" {

    triggers = {
        instance_id = module.catalogue.id
    }

    connection {
      host = module.catalogue.private_ip
      type = "ssh"
      user = "ec2-user"
      private_key = file("D:/DevOps/DurgaBhavani/newyear2025/durga.pem")
  #password = ""
    }

    provisioner "file" {  # if we want to run any script we need to copy that file to ec2 instance so through this we can copy that file to ec2 instance
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
      
    }

    provisioner "remote-exec" { 
        
        inline = [ 
            "chmod +x /tmp/bootstrap.sh",
            "sudo /tmp/bootstrap.sh",
            # "/tmp/bootstrap.sh catalogue dev",
         ]
      
    }


  
}

### TO STOP THE INSTANCE THROUGH TERRAFORM ###

resource "aws_ec2_instance_state" "catalogue" {

  instance_id = module.catalogue.id
  state = "stopped"
  depends_on = [ null_resource.catalogue ]
  
}

### TO GET THE AMI ID OF OUR CREATED INSTANCE ###

resource "aws_ami_from_instance" "catalogue" {
  name               = "${local.name}-${var.tags.Component}-${local.current_time}"
  source_instance_id = module.catalogue.id
  depends_on = [ aws_ec2_instance_state.catalogue ]
}



# ### TO TERMINATE THE INSTANCE THROUGH TERRAFORM ###

resource "null_resource" "catalogu-delete" {

    triggers = {
        instance_id = module.catalogue.id
    }



    provisioner "local-exec" {

      command = "aws ec2 terminate-instances --instance-ids ${module.catalogue.id}"

      }

      depends_on = [ aws_ami_from_instance.catalogue ]


    }

resource "aws_launch_template" "catalogue" {
  name = "${local.name}-${var.tags.Component}"

  image_id = aws_ami_from_instance.catalogue.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t2.micro"
  update_default_version = true
  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]

  tag_specifications {

    resource_type = "instance"

    tags = {

      Name ="${local.name}-${var.tags.Component}"
    }
    
  }
  
}

resource "aws_autoscaling_group" "catalogue" {
  name = "${local.name}-${var.tags.Component}"
  max_size = 10
  min_size = 1
  health_check_grace_period = 60
  health_check_type = "ELB"
  desired_capacity = 2
  vpc_zone_identifier = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
  target_group_arns = [ aws_alb_target_group.catalogue.arn ]

  launch_template {
    id = aws_launch_template.catalogue.id
    version = aws_launch_template.catalogue.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      
      min_healthy_percentage = 50
    
    }

    triggers = [ "launch_template"]
    
  }

  tag {
    key = "Name"
    value = "${local.name}-${var.tags.Component}"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

  

}

resource "aws_lb_listener_rule" "catalogue" {

  listener_arn = data.aws_ssm_parameter.app_alb_listener_arn
  priority = 10

  action {
    type = "forward"
    target_group_arn = aws_alb_target_group.catalogue.arn
  }

  condition {
    host_header {
      values = ["${var.tags.Component}.app-${var.environment}"]#.${var.zone_name}
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