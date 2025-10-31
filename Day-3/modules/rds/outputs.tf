output "db_endpoint" {
  value       = aws_db_instance.app-db.address
  description = "Endpoint of the RDS database instance"
  
}

output "db_name" {
  value       = aws_db_instance.app-db.db_name
  description = "Name of the RDS database"
}

output "db_port" {
  value       = aws_db_instance.app-db.port
  description = "Port of the RDS database"
}