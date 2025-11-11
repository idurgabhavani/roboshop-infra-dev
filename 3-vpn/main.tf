module "vpn" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  ami                    = "ami-052064a798f08f0d3"
  name                   = "${local.ec2_name}-vpn"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  key_name               = "bhavani"
  subnet_id              = data.aws_subnet.selected.id
  user_data = <<-EOF
        #!/bin/bash
        sudo su
        yum install git -y
        yum install ansible -y
      EOF
  
  tags = merge(
    var.common_tags,
    {
      Component = "vpn"
    },
    {
      Name = "${local.ec2_name}-vpn"
    }
  )

 


 
}






