data "aws_ssm_parameter" "vpc_id" {
    name = "/${var.project_name}/${var.environment}/vpc_id"
}

### here we are taking vpc id from ssm parameter store , data  sourece not only used to query the data  but also we can take the value from the data sourece

data "aws_vpc" "default" {
    default = true
}