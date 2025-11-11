resource "aws_lb" "web_alb" {
  name               = "${local.name}-${var.tags.Component}" #roboshop-dev-app-alb
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.web_alb_sg_id.value]
  subnets            = split(",", data.aws_ssm_parameter.public_subnet_ids.value)

  #enable_deletion_protection = true

  tags = merge(
    var.common_tags,
    var.tags
  )
}

### :: this is listerner for HTTPS not for HTTP ####

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "80"
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  /* # certificate_arn   = data.aws_ssm_parameter.acm_certificate_arn.value */

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "This is from WEB ALB using HTTPS"
      status_code  = "200"
    }
  }
}

# module "records" {
#   source  = "terraform-aws-modules/route53/aws//modules/records"

#   zone_name = var.zone_name

#   records = [
#     {
#       name    = "web-${var.environment}"
#       type    = "A"
#       alias   = {
#         name    = aws_lb.web_alb.dns_name
#         zone_id = aws_lb.web_alb.zone_id
#       }
#     }
#   ]
# }