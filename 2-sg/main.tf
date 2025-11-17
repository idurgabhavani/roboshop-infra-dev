
module "vpn" {
    source = "../../terraform-aws-security-group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "Security group for mongodb"
    vpc_id     = data.aws_vpc.default.id
    sg_name = "vpn"
    #sg_ingress_rules = var.mongodb_sg_ingress_rules
    

}


module "mongodb" {
    source = "../../terraform-aws-security-group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "Security group for mongodb"
    vpc_id     = data.aws_ssm_parameter.vpc_id.value
    sg_name = "mongodb"
    #sg_ingress_rules = var.mongodb_sg_ingress_rules
    

}

module "redis" {
    source = "../../terraform-aws-security-group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "Security group for redis"
    vpc_id     = data.aws_ssm_parameter.vpc_id.value
    sg_name = "redis"
    #sg_ingress_rules = var.mongodb_sg_ingress_rules
    

}

module "mysql" {
    source = "../../terraform-aws-security-group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "Security group for mysql"
    vpc_id     = data.aws_ssm_parameter.vpc_id.value
    sg_name = "mysql"
    #sg_ingress_rules = var.mongodb_sg_ingress_rules
    

}


module "rabbitmq" {
    source = "../../terraform-aws-security-group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "Security group for rabbitmq"
    vpc_id     = data.aws_ssm_parameter.vpc_id.value
    sg_name = "rabbitmq"
    #sg_ingress_rules = var.mongodb_sg_ingress_rules
    

}

module "catalogue" {
    source = "../../terraform-aws-security-group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "Security group for catalogue"
    vpc_id     = data.aws_ssm_parameter.vpc_id.value
    sg_name = "catalogue"
    #sg_ingress_rules = var.mongodb_sg_ingress_rules


  
}

module "user" {
    source = "../../terraform-aws-security-group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "Security group for user"
    vpc_id     = data.aws_ssm_parameter.vpc_id.value
    sg_name = "user"
    #sg_ingress_rules = var.mongodb_sg_ingress_rules


  
}

module "cart" {
    source = "../../terraform-aws-security-group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "Security group for cart"
    vpc_id     = data.aws_ssm_parameter.vpc_id.value
    sg_name = "cart"
    #sg_ingress_rules = var.mongodb_sg_ingress_rules


  
}

module "shipping" {
    source = "../../terraform-aws-security-group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "Security group for shipping"
    vpc_id     = data.aws_ssm_parameter.vpc_id.value
    sg_name = "shipping"
    #sg_ingress_rules = var.mongodb_sg_ingress_rules


  
}

module "payment" {
    source = "../../terraform-aws-security-group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "Security group for payment"
    vpc_id     = data.aws_ssm_parameter.vpc_id.value
    sg_name = "payment"
    #sg_ingress_rules = var.mongodb_sg_ingress_rules

}

module "web" {
    source = "../../terraform-aws-security-group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "Security group for web"
    vpc_id     = data.aws_ssm_parameter.vpc_id.value
    sg_name = "web"
    #sg_ingress_rules = var.mongodb_sg_ingress_rules

}


module "app_alb" {
    source = "../../terraform-aws-security-group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "Security group for app_alb"
    vpc_id     = data.aws_ssm_parameter.vpc_id.value
    sg_name = "app_alb"
    #sg_ingress_rules = var.mongodb_sg_ingress_rules

}


module "web_alb" {
    source = "../../terraform-aws-security-group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "Security group for web_alb"
    vpc_id     = data.aws_ssm_parameter.vpc_id.value
    sg_name = "web_alb"
    #sg_ingress_rules = var.mongodb_sg_ingress_rules

}


## Rule for openvpn

resource "aws_security_group_rule" "vpn_home" {
    security_group_id = module.vpn.sg_id
    type = "ingress"
    from_port = 0
    to_port = 65535
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Ideally your home public IP address, but it freqently changes

}

## APP ALB ONLY accept connections from VPN since it is internal


resource "aws_security_group_rule" "app_alb-vpn" {
    source_security_group_id = module.vpn.sg_id
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_group_id = module.app_alb.sg_id

  
}



resource "aws_security_group_rule" "app_alb-web" {
    source_security_group_id = module.web.sg_id
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_group_id = module.app_alb.sg_id

  
}


resource "aws_security_group_rule" "web_alb-internet" {
    cidr_blocks = ["0.0.0.0/0"]
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_group_id = module.web_alb.sg_id

  
}


## Mongodb accepting connections from catalogue instance

resource "aws_security_group_rule" "mongodb-vpn" {
    source_security_group_id = module.vpn.sg_id
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = module.mongodb.sg_id

  
}

resource "aws_security_group_rule" "mongodb-catalogue" {
    source_security_group_id = module.catalogue.sg_id
    type = "ingress"
    from_port = 27017
    to_port = 27017
    protocol = "tcp"
    security_group_id = module.mongodb.sg_id

  
}


resource "aws_security_group_rule" "mongodb-user" {
    source_security_group_id = module.user.sg_id
    type = "ingress"
    from_port = 27017
    to_port = 27017
    protocol = "tcp"
    security_group_id = module.mongodb.sg_id

  
}


resource "aws_security_group_rule" "redis-vpn" {
    source_security_group_id = module.vpn.sg_id
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = module.redis.sg_id

  
}

resource "aws_security_group_rule" "redis-user" {
    source_security_group_id = module.user.sg_id
    type = "ingress"
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
    security_group_id = module.redis.sg_id

  
}

resource "aws_security_group_rule" "redis-cart" {
    source_security_group_id = module.cart.sg_id
    type = "ingress"
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
    security_group_id = module.redis.sg_id

  
}

resource "aws_security_group_rule" "mysql_vpn" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.mysql.sg_id
}

resource "aws_security_group_rule" "mysql_shipping" {
  source_security_group_id = module.shipping.sg_id
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = module.mysql.sg_id
}


resource "aws_security_group_rule" "rabbitmq_vpn" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.rabbitmq.sg_id
}

resource "aws_security_group_rule" "rabbitmq_payment" {
  source_security_group_id = module.payment.sg_id
  type                     = "ingress"
  from_port                = 5672
  to_port                  = 5672
  protocol                 = "tcp"
  security_group_id        = module.rabbitmq.sg_id
}

resource "aws_security_group_rule" "catalogue_vpn" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.catalogue.sg_id
}

resource "aws_security_group_rule" "catalogue_vpn_http" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.catalogue.sg_id
}


# resource "aws_security_group_rule" "catalogue_web" {
#   source_security_group_id = module.web.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.catalogue.sg_id
# }

resource "aws_security_group_rule" "catalogue_app_alb" {
  source_security_group_id = module.app_alb.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.catalogue.sg_id
}


# resource "aws_security_group_rule" "catalogue_cart" {
#   source_security_group_id = module.cart.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.catalogue.sg_id
# }

resource "aws_security_group_rule" "user_vpn" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.user.sg_id
}


resource "aws_security_group_rule" "user_app_alb" {
  source_security_group_id = module.app_alb.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.user.sg_id
}

# resource "aws_security_group_rule" "user_web" {
#   source_security_group_id = module.web.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.user.sg_id
# }

# resource "aws_security_group_rule" "user_payment" {
#   source_security_group_id = module.payment.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.user.sg_id
# }

resource "aws_security_group_rule" "cart_vpn" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.cart.sg_id
}

# resource "aws_security_group_rule" "cart_web" {
#   source_security_group_id = module.web.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.cart.sg_id
# }

resource "aws_security_group_rule" "cart_app_alb" {
  source_security_group_id = module.app_alb.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.cart.sg_id
}



resource "aws_security_group_rule" "cart_shipping" {
  source_security_group_id = module.shipping.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.cart.sg_id
}

resource "aws_security_group_rule" "cart_payment" {
  source_security_group_id = module.payment.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.cart.sg_id
}

resource "aws_security_group_rule" "shipping_vpn" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.shipping.sg_id
}

resource "aws_security_group_rule" "shipping_app_alb" {
  source_security_group_id = module.app_alb.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.shipping.sg_id
}

# resource "aws_security_group_rule" "shipping_app_alb" {
#   source_security_group_id = module.web.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.shipping.sg_id
# }

resource "aws_security_group_rule" "payment_vpn" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.payment.sg_id
}

# resource "aws_security_group_rule" "payment_web" {
#   source_security_group_id = module.web.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.payment.sg_id
# }   

#### payment , user , shipping and cart all these now accepting  connections from app alb



resource "aws_security_group_rule" "payment_app_alb" {
  source_security_group_id = module.app_alb.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.payment.sg_id
}


resource "aws_security_group_rule" "web_vpn" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.web.sg_id
}

resource "aws_security_group_rule" "web_internet" {
  cidr_blocks = ["0.0.0.0/0"]
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = module.web.sg_id
}