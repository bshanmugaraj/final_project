resource "aws_route53_zone" "primary" {
    name = "example.com"
  }

resource "aws_route53_record" "commercedataservice-rr-as2-on-prem" {
zone_id = data.aws_route53_zone.r53-example-com.zone_id
name    = "commercedataservice-rr"
type    = "CNAME"
ttl     = "60"

weighted_routing_policy {
weight = 22
}

set_identifier = "commercedataservice-rr-as2-on-prem"
records        = ["prod-fo-as2.test.com"]

health_check_id = module.commercedataservice_as2_alive_check.health_check_id

lifecycle {
prevent_destroy = true
}
}

resource "aws_route53_record" "commercedataservice-rr-ch2-on-prem" {
zone_id = data.aws_route53_zone.r53-example-com.zone_id
name    = "commercedataservice-rr"
type    = "CNAME"
ttl     = "60"

weighted_routing_policy {
weight = 11
}

set_identifier = "commercedataservice-rr-ch2-on-prem"
records        = ["prod-fo-ch2.test.com"]

health_check_id = module.commercedataservice_ch2_alive_check.health_check_id

lifecycle {
prevent_destroy = true
}
}

resource "aws_route53_record" "commercedataservice-rr-ho2-on-prem" {
zone_id = data.aws_route53_zone.r53-example-com.zone_id
name    = "commercedataservice-rr"
type    = "CNAME"
ttl     = "60"

weighted_routing_policy {
weight = 34
}

set_identifier = "commercedataservice-rr-ho2-on-prem"
records        = ["prod-fo-ho2.test.com"]

health_check_id = module.commercedataservice_ho2_alive_check.health_check_id

lifecycle {
prevent_destroy = true
}
}

resource "aws_route53_record" "commercedataservice-rr-us-west-2a" {
  zone_id = data.aws_route53_zone.r53-example-com.zone_id
  name    = "commercedataservice-rr"
  type    = "CNAME"
  ttl     = "60"

  weighted_routing_policy {
    weight = 0
  }

  set_identifier = "commercedataservice-rr-us-west-2a"
  records = [
    "commercedataservice-prod-fo-us-west-2a.r53.test.com",
  ]

  health_check_id = module.commercedataservice_west_2a_elb_alive_check.health_check_id

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "commercedataservice-rr-us-east-1-eks" {
  zone_id = data.aws_route53_zone.r53-example-com.zone_id
  name    = "commercedataservice-rr"
  type    = "CNAME"
  ttl     = "60"

  weighted_routing_policy {
    weight = 0
  }

  set_identifier = "commercedataservice-rr-us-east-1-eks"
  records        = ["prod-fo-us-east-1.test.com"]

  health_check_id = module.commercedataservice_east_1_eks_alive_check.health_check_id

  lifecycle {
    prevent_destroy = true
  }
}
