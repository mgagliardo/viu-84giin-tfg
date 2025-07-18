resource "random_password" "db" {
  length           = 16
  special          = true
  override_special = "!#$&*()-_=+[]{}<>:?"
}

module "microblog_db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.12.0"

  identifier                     = "${var.environment}-${var.service}-db"
  instance_use_identifier_prefix = true

  engine         = "postgres"
  engine_version = "16.6"
  instance_class = "db.t4g.micro"
  family         = "postgres16"

  db_name  = var.service
  username = var.service
  port     = 5432

  allocated_storage = 100
  storage_encrypted = true

  multi_az               = false
  publicly_accessible    = false

  manage_master_user_password = false
  password                    = random_password.db.result
  
  apply_immediately                   = true
  # deletion_protection                 = false
  iam_database_authentication_enabled = false
  enabled_cloudwatch_logs_exports = []

  auto_minor_version_upgrade = true
  maintenance_window         = "Sun:00:00-Sun:03:00"
  backup_retention_period    = 1
  backup_window              = "04:00-08:00"

  create_monitoring_role = false

  create_db_subnet_group    = true
  create_db_option_group    = false
  create_db_parameter_group = false
  subnet_ids                = module.vpc.private_subnets
  vpc_security_group_ids    = [aws_security_group.microblog_db_sg.id]

  tags = local.tags
}

resource "aws_security_group" "microblog_db_sg" {
  name        = "${var.environment}-${var.service}-rds-sg"
  description = "SG for ${var.environment}-${var.service}-rds instance"
  vpc_id      = module.vpc.vpc_id
  tags        = local.tags
}

resource "aws_security_group_rule" "microblog_db_sg_allow_backend" {
  type                     = "ingress"
  description              = "Allow traffic from fargate ${var.environment}-${var.service} instances"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.microblog_fargate_sg.id
  security_group_id        = aws_security_group.microblog_db_sg.id
}

resource "aws_security_group_rule" "microblog_db_sg_allow_outbound_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.microblog_db_sg.id
}

resource "aws_route53_record" "microblog_db" {
  zone_id = aws_route53_zone.dns.zone_id
  name    = "db.${local.dns_zone_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [module.microblog_db.db_instance_address]
}
