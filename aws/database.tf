# RDS PostgreSQL (equivalent to Azure PostgreSQL Flexible Server)
resource "aws_db_subnet_group" "postgresql" {
  name       = "${local.name_prefix}-db-subnet-group"
  subnet_ids = aws_subnet.database[*].id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-db-subnet-group"
  })
}

resource "aws_security_group" "postgresql" {
  name_prefix = "${local.name_prefix}-postgresql-"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_tasks.id]
    description     = "PostgreSQL from ECS tasks"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-postgresql-sg"
  })
}

resource "aws_db_instance" "postgresql" {
  # Basic configuration
  identifier = "${local.name_prefix}-postgresql"

  # Engine configuration
  engine         = "postgres"
  engine_version = "16.4"
  instance_class = "db.t3.micro"  # Equivalent to Burstable tier

  # Storage configuration
  allocated_storage     = 20  # Start smaller, can grow
  max_allocated_storage = 100
  storage_type          = "gp3"
  storage_encrypted     = true

  # Database configuration
  db_name  = var.database_name
  username = var.database_username
  password = random_password.db_password.result
  port     = 5432

  # Network configuration
  db_subnet_group_name   = aws_db_subnet_group.postgresql.name
  vpc_security_group_ids = [aws_security_group.postgresql.id]
  publicly_accessible    = false

  # Backup configuration
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"

  # Additional configuration
  auto_minor_version_upgrade = true
  deletion_protection       = false  # Set to true for production
  skip_final_snapshot      = true   # Set to false for production

  # Performance Insights
  performance_insights_enabled = false  # Enable for production monitoring

  # Multi-AZ for high availability (disabled for cost in dev)
  multi_az = false

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-postgresql"
  })
}