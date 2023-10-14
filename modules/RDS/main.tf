resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "${local.name}-rds-subnet-group"
  description = "RDS subnet group"
  subnet_ids  = var.config.subnet_ids
  tags        = local.tags
}
// SG to access DB
resource "aws_security_group" "db_access_sg" {
  count       = var.config.db_access_sg_exists ? 0 : 1
  vpc_id      = var.config.vpc_id
  name        = "${local.name}-db-access-sg"
  description = "Allow access to RDS"
  tags = local.tags
}
resource "aws_security_group" "rds_sg" {
  name        = "${local.name}-rds-sg"
  description = "${var.config.environment} Security Group"
  vpc_id      = var.config.vpc_id
  tags        = local.tags
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }
  ingress {
    from_port       = var.config.db_port
    to_port         = var.config.db_port
    protocol        = "tcp"
    security_groups = var.config.db_access_sg_exists ? [var.config.db_access_sg_id] : ["${aws_security_group.db_access_sg[0].id}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "rds" {
  identifier             = local.name
  allocated_storage      = var.config.allocated_storage
  engine                 = var.config.engine
  engine_version         = var.config.engine_version
  instance_class         = var.config.instance_class
  multi_az               = false
  db_name                = var.config.db_name
  port                   = var.config.db_port
  username               = var.config.db_username
  password               = var.config.db_password
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.id
  vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
  maintenance_window        = var.config.maintenance_window
  backup_window             = var.config.backup_window
  backup_retention_period   = var.config.backup_retention_period
  skip_final_snapshot       = var.config.skip_final_snapshot
  final_snapshot_identifier = var.config.final_snapshot_identifier
  parameter_group_name = var.config.parameter_group_name != "" ? var.config.parameter_group_name : null
  monitoring_interval          = var.config.monitoring_interval
  performance_insights_enabled = var.config.performance_insights_enabled
  tags = local.tags
  lifecycle {
    ignore_changes = [
    ]
  }
}
