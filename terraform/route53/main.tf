resource "aws_route53_zone" "private-zone" {
  name = "aws.techchallenge.com"
  comment = "private dns for techchallengeapp"
  vpc {
    vpc_id = var.vpc_id
  }
}
resource "aws_route53_record" "private-db-record" {
  zone_id = aws_route53_zone.private-zone.zone_id
  name    = "apprds.aws.techchallenge.com"
  type    = "CNAME"
  ttl     = "300"
  records = [var.db_instance_address]
}

output "db_record_name" {
  description = "record name for private db"
  value = aws_route53_record.private-db-record.name
}