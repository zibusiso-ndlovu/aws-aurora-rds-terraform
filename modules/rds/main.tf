resource "aws_secretsmanager_secret" "db_password" {
  name = "aurora-db-password"
  description = "This is the RDS Aurora DB password"

  secret_string = jsonencode({
    password = random_password.db_password.result
  })
}

resource "random_password" "db_password" {
  length  = 16
  special = true
}

resource "aws_db_subnet_group" "aurora" {
  name       = "aurora-subnet-group"
  subnet_ids = var.private_subnet_ids
}

resource "aws_rds_cluster" "aurora" {
  cluster_identifier      = "aurora-cluster"
  engine                  = "aurora"
  master_username         = "admin"
  master_password         = data.aws_secretsmanager_secret_version.secret.secret_string["password"]
  db_subnet_group_name    = aws_db_subnet_group.aurora.name
  vpc_security_group_ids  = [var.bastion_security_group_id]

  depends_on = [aws_secretsmanager_secret.db_password]
}

data "aws_secretsmanager_secret_version" "secret" {
  secret_id = aws_secretsmanager_secret.db_password.id
}

output "endpoint" {
  value = aws_rds_cluster.aurora.endpoint
}
