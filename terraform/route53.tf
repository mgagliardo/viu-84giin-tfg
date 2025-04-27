resource "aws_route53_zone" "dns" {
  name = local.dns_zone_name

  vpc {
    vpc_id = module.vpc.vpc_id
  }

  lifecycle {
    ignore_changes = [vpc]
  }

  tags = local.tags
}

