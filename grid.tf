provider "aws" {
    region = "ap-south-1"
  }
resource "aws_route53_zone" "primary" {
    name = "example.com"
  }
resource "aws_route53_record" "grid-us-west-2a" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = 5

  weighted_routing_policy {
    weight = 200
  }

  set_identifier = "grid-us-west-2a"
  records        = ["dev.example.com"]
}

resource "aws_route53_record" "grid-us-east-1" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = 5

  weighted_routing_policy {
    weight = 100
  }

  set_identifier = "grid-us-east-1"
  records        = ["live.example.com"]
}
