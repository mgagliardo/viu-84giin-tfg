module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.19.0"

  name = "${var.environment}-${var.service}-vpc"

  cidr            = var.cidr_block
  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  map_public_ip_on_launch       = true
  manage_default_network_acl    = false
  manage_default_route_table    = false
  manage_default_security_group = false
  manage_default_vpc            = false

  enable_dhcp_options              = true
  enable_dns_hostnames             = true
  enable_dns_support               = true
  dhcp_options_domain_name         = local.dns_zone_name
  dhcp_options_domain_name_servers = ["AmazonProvidedDNS", "8.8.8.8"]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  reuse_nat_ips          = false

  tags = local.tags
}
