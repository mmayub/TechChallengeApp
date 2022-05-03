resource "aws_route53_zone" "private-zone" {
  name = "aws.servian.com"
  comment = "private dns for techchallengeapp"
  vpc {
    vpc_id = module.vpc.vpc_id
  }
}

resource "aws_route53_record" "private-db-record" {
  zone_id = aws_route53_zone.private-zone.zone_id
  name    = "techchallengeapprds.aws.servian.com"
  type    = "CNAME"
  ttl     = "300"
  records = [module.rds.rds_instance_address]
}