module "mongodb" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  ami                    = "ami-052064a798f08f0d3"
  name                   = "${local.ec2_name}-mongodb"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.mongodb_sg_id.value]
  key_name               = "bhavani"
  subnet_id              = local.database_subnet_id


  tags = merge(
    var.common_tags,
    {
      Component = "mongodb"
    },
    {
      Name = "${local.ec2_name}-mongodb"
    }
  )
}

resource "null_resource" "mongodb" {

    triggers = {
        instance_id = module.mongodb.id
    }

    connection {
      host = module.mongodb.private_ip
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
            "/tmp/bootstrap.sh mongodb dev",
         ]
      
    }


  
}
# through remote exec the copied file will be exceuted in the ec2 instance 
# if any changes in the mongodb instance then this trigger will trigger

module "redis" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  ami                    = "ami-052064a798f08f0d3"
  name                   = "${local.ec2_name}-redis"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.redis_sg_id.value]
  key_name               = "bhavani"
  subnet_id              = local.database_subnet_id


  tags = merge(
    var.common_tags,
    {
      Component = "redis"
    },
    {
      Name = "${local.ec2_name}-redis"
    }
  )
}

resource "null_resource" "redis" {

    triggers = {
        instance_id = module.redis.id
    }

    connection {
      host = module.redis.private_ip
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
        # through remote exec the copied file will be exceuted in the ec2 instance 
        inline = [ 
            "chmod +x /tmp/bootstrap.sh",
            "sudo sh /tmp/bootstrap.sh redis dev"
         ]
      
    }


  
}

module "mysql" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  ami                    = "ami-052064a798f08f0d3"
  name                   = "${local.ec2_name}-mysql"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.mysql_sg_id.value]
  key_name               = "bhavani"
  subnet_id              = local.database_subnet_id
  iam_instance_profile = "Ec2role"


  tags = merge(
    var.common_tags,
    {
      Component = "mysql"
    },
    {
      Name = "${local.ec2_name}-mysql"
    }
  )
}

resource "null_resource" "mysql" {

    triggers = {
        instance_id = module.mysql.id
    }

    connection {
      host = module.mysql.private_ip
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
        # through remote exec the copied file will be exceuted in the ec2 instance 
        inline = [ 
            "chmod +x /tmp/bootstrap.sh",
            "sudo sh /tmp/bootstrap.sh mysql dev"
         ]
      
    }


  
}

module "rabbitmq" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  ami                    = "ami-052064a798f08f0d3"
  name                   = "${local.ec2_name}-rabbitmq"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.rabbitmq_sg_id.value]
  key_name               = "bhavani"
  subnet_id              = local.database_subnet_id
  iam_instance_profile = "Ec2role"


  tags = merge(
    var.common_tags,
    {
      Component = "rabbitmq"
    },
    {
      Name = "${local.ec2_name}-rabbitmq"
    }
  )
}

resource "null_resource" "rabbitmq" {

    triggers = {
        instance_id = module.rabbitmq.id
    }

    connection {
      host = module.rabbitmq.private_ip
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
        # through remote exec the copied file will be exceuted in the ec2 instance 
        inline = [ 
            "chmod +x /tmp/bootstrap.sh",
            "sudo sh /tmp/bootstrap.sh rabbitmq dev"
         ]
      
    }


  
}

# module "records" {
#   source  = "terraform-aws-modules/route53/aws//modules/records"

#   zone_name = var.zone_name

#   records = [
#     {
#       name    = "mongodb-dev"
#       type    = "A"
#       ttl     = 1
#       records = [
#         module.mongodb.private_ip,
#       ]
#     },
#     {
#       name    = "redis-dev"
#       type    = "A"
#       ttl     = 1
#       records = [
#         module.redis.private_ip,
#       ]
#     },
#     {
#       name    = "mysql-dev"
#       type    = "A"
#       ttl     = 1
#       records = [
#         module.mysql.private_ip,
#       ]
#     },
#     {
#       name    = "rabbitmq-dev"
#       type    = "A"
#       ttl     = 1
#       records = [
#         module.rabbitmq.private_ip,
#       ]
#     },
#   ]
# }