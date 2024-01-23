resource "aws_db_instance" "my_rds" {
  username            = "db_user"
  storage_type        = "gp2"
  skip_final_snapshot = true
  publicly_accessible = false
  password            = "db_password"
  instance_class      = "db.t2.micro"
  identifier          = "my-rds-instance"
  engine              = "postgres"
  allocated_storage   = 20

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id,
  ]
}

resource "aws_security_group" "rds_sg" {
  vpc_id      = aws_vpc.my_vpc.id
  name        = "rds-sg"
  description = "Security group for RDS"

  egress {
    to_port   = 0
    protocol  = "-1"
    from_port = 0
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    to_port   = 5432
    protocol  = "tcp"
    from_port = 5432
    security_groups = [
      aws_security_group.ecs_tasks_sg.id,
    ]
  }
}
