variable "common_tags" {
    default = {
        Project = "roboshop"
        Environment = "dev"
        Terraform = "true"
    }

}

variable "project_name" {

    default = "roboshop"
  
}

variable "environment" {
    default = "dev"
}

variable "sg_tags" {
    default = {}
  
}

variable "sg_name" {
    
  
}

variable "mongodb_sg_ingress_rules" {

         default = [
        {
            description      = "Allow all port number 80"
            from_port        = 80# 0 means all ports
            to_port          = 80
            protocol         = "tcp"
            cidr_blocks      = ["0.0.0.0/0"]
        },
        {
            description      = "Allow all port number 443"
            from_port        = 443# 0 means all ports
            to_port          = 443
            protocol         = "tcp"
            cidr_blocks      = ["0.0.0.0/0"]
        # ipv6_cidr_blocks = ["::/0"]
        },

    ]
  
}

 