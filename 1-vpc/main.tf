module "roboshop" {
    #source = "../terraform-aws-vpc"  if we need to refer the source from GIT hub please follow below steps
    source = "git::https://github.com/idurgabhavani/terraform-aws-vpc.git?ref=master"
    project_name = var.project_name
    environment = var.environment
    common_tags = var.common_tags
    vpc_tags = var.vpc_tags

    #public subnet
    public_subnets_cidr = var.public_subnets_cidr
    private_subnets_cidr = var.private_subnets_cidr
    database_subnets_cidr = var.database_subnets_cidr

    is_peering_require = var.is_peering_require

  
}

