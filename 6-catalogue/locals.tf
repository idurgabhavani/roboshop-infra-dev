locals {
  name           = "${var.project_name}-${var.environment}"
  ec2_name  = "${var.project_name}-${var.environment}-"   
#   database_subnet_id = element(split(",", data.aws_ssm_parameter.database_subnet_ids.value), 0)
 current_time = formatdate("YYYY-MM-DD-hh-mm",timestamp())
 
  }