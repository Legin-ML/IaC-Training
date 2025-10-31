output "alb_dns_name" {
  value       = aws_lb.app_alb.dns_name
  description = "DNS name of the Application Load Balancer"

}

output "app_sg_id" {
  value       = aws_security_group.app_instance_sg.id
  description = "ID of the Application Security Group"
}