
resource "aws_secretsmanager_secret" "db_secret" {
  name                    = "${var.environment}/${var.service}/microblog"
  description             = "Database credentials for ${var.environment}-${var.service} DB"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({ database_url: "postgres://${var.service}:${random_password.db.result}@${aws_route53_record.microblog_db.name}:5432/microblog" })
}


