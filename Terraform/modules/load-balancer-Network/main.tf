locals {
  name           = "${var.config.environment}-${var.config.context}-albredirect"
  listener_types = slice(["HTTP", "HTTPS"], 0, var.https_enabled ? 2 : 1)
}

resource "aws_security_group" "this" {
  name        = local.name
  description = "Allow inbound 80/443 traffic alb redirect"
  vpc_id      = var.config.vpc_id
  ingress {
    # TLS (change to whatever ports you need)
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = var.ipv6_networking_enabled ? ["::/0"] : []
  }
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = var.ipv6_networking_enabled ? ["::/0"] : []
  }
}
# -------------------------------------------------------------------------------------------------
# LB
# -------------------------------------------------------------------------------------------------
resource "aws_lb" "this" {
  load_balancer_type               = "network"
  name                             = local.name
  security_groups                  = [aws_security_group.this.id]
  subnets                          = var.config.subnet_ids
  enable_cross_zone_load_balancing = false
  enable_deletion_protection       = false
  enable_http2                     = true
  ip_address_type                  = var.lb_ip_address_type
  tags = merge(
    var.config.tags,
    {
      "Name" = local.name
    },
  )
}
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = var.response_message_body
      status_code  = var.response_code
    }
  }
}
resource "aws_lb_listener" "https" {
  count = var.https_enabled ? 1 : 0
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn
  ssl_policy        = var.ssl_policy
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = var.response_message_body
      status_code  = var.response_code
    }
  }
}
