
resource "aws_route53_zone" "primary" {
  name = var.primary
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.www
  type    = "A"
  ttl     = 100
  records = var.record
}

############# weighted  #####################
resource "aws_route53_record" "www-dev" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.www
  type    = "CNAME"
  ttl     = 5

  weighted_routing_policy {
    weight = 10
  }

  set_identifier = "dev"
  records        = ["var.record-dev"]
}

resource "aws_route53_record" "www-live" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = 5

  weighted_routing_policy {
    weight = 90
  }

  set_identifier = "live"
  records        = ["var.record-live"]
}

####################### Alias #############

resource "aws_elb" "main" {
  name               = var.main-lb
  availability_zones = ["var.zone"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

resource "aws_route53_record" "web" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.www
  type    = "A"

  alias {
    name                   = aws_elb.main.dns_name
    zone_id                = aws_elb.main.zone_id
    evaluate_target_health = true
  }
}
##########################  NS  ############


resource "aws_route53_record" "test" {
  allow_overwrite = true
  name            = var.test
  ttl             = 17280
  type            = "NS"
  zone_id         = aws_route53_zone.test.zone_id

  records = [
    aws_route53_zone.test.name_servers[0],
    aws_route53_zone.test.name_servers[1],
  ]
}


