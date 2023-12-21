resource "aws_route53_record" "commercedataservice-rr-as2-on-prem" {
zone_id = aws_route53_zone.primary.zone_id
name    = "commercedataservice-rr"
type    = "CNAME"
ttl     = "60"

weighted_routing_policy {
weight = 22
}

set_identifier = "commercedataservice-rr-as2-on-prem"
records        = ["prod-fo-as2.test.com"]

lifecycle {
prevent_destroy = true
}
}

resource "aws_route53_record" "commercedataservice-rr-ch2-on-prem" {
zone_id = aws_route53_zone.primary.zone_id
name    = "commercedataservice-rr"
type    = "CNAME"
ttl     = "60"

weighted_routing_policy {
weight = 11
}

set_identifier = "commercedataservice-rr-ch2-on-prem"
records        = ["prod-fo-ch2.test.com"]

lifecycle {
prevent_destroy = true
}
}

resource "aws_route53_record" "commercedataservice-rr-ho2-on-prem" {
zone_id = aws_route53_zone.primary.zone_id
name    = "commercedataservice-rr"
type    = "CNAME"
ttl     = "60"

weighted_routing_policy {
weight = 34
}

set_identifier = "commercedataservice-rr-ho2-on-prem"
records        = ["prod-fo-ho2.test.com"]

lifecycle {
prevent_destroy = true
}
}

resource "aws_route53_record" "commercedataservice-rr-us-west-2a" {
  zone_id = aws_route53_zone.primary.zone_id
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


  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "commercedataservice-rr-us-east-1-eks" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "commercedataservice-rr"
  type    = "CNAME"
  ttl     = "60"

  weighted_routing_policy {
    weight = 0
  }

  set_identifier = "commercedataservice-rr-us-east-1-eks"
  records        = ["prod-fo-us-east-1.test.com"]

  lifecycle {
    prevent_destroy = true
  }
}
