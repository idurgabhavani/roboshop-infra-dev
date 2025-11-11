module "user" {
    source = "../../terraform-roboshop-app"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    component_sg_id = data.aws_ssm_parameter.cart_sg_id.value
    private_subnet_id = split(",",data.aws_ssm_parameter.private_subnet_ids.value) # list of private subnet ids
    iam_instance_profile = "Ec2role"
    project_name = var.project_name
    environment = var.environment
    common_tags = var.common_tags
    tags = var.tags
    app_alb_listener_arn = data.aws_ssm_parameter.app_alb_listener_arn.value
}