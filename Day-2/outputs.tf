# output "public_ip" {
#     value = aws_instance.webserver-vm.public_ip
#     description = "Public IP address of the webserver VM"
# }

output "alb_dns_name" {
    value       = aws_alb.app-alb.dns_name
    description = "DNS name of the Application Load Balancer"
  
}

output "instance_ids" {
    value       = [aws_instance.webserver-vm-1.id, aws_instance.webserver-vm-2.id]
    description = "IDs of the webserver instances"
}

output "subnet_ids" {
    value       = [aws_subnet.app-public-subnet-1.id, aws_subnet.app-public-subnet-2.id, aws_subnet.app-private-subnet-1.id, aws_subnet.app-private-subnet-2.id]
    description = "IDs of the VPC subnets" 
}