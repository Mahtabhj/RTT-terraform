output "rds_instance_identifier" {
  value = aws_db_instance.my_rds.identifier
}

output "rds_instance_address" {
  value = aws_db_instance.my_rds.address
}

output "rds_security_group_id" {
  value = aws_security_group.rds_sg.id
}
