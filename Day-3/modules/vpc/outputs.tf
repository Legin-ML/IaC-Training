output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.app-vpc.id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [for subnet in aws_subnet.private-subnets : subnet.id]
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [for subnet in aws_subnet.public-subnets : subnet.id]
}
