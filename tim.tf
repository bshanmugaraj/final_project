resource "aws_route53_record" "tim-us-west-2a" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www-rr"
  type    = "CNAME"
  ttl     = 5

  weighted_routing_policy {
    weight = 0
  }

  set_identifier = "tim-us-west-2a"
  records        = ["prod.example.com"]
}

resource "aws_route53_record" "tim-us-east-1" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www-rr"
  type    = "CNAME"
  ttl     = 5

  weighted_routing_policy {
    weight = 20
  }

  set_identifier = "tim-us-east-1"
  records        = ["nonprod.example.com"]
}
