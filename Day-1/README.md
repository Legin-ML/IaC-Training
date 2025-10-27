# IaC Day 1


## Task

Assignment 1: Basic Web Server Deployment on AWS
 
Objective:
Use Terraform to automate the creation of a simple web server on AWS within a custom network environment.
 
Requirements:
- Create a VPC with a public subnet.
- Launch an EC2 instance in that subnet to host a basic web server (e.g., Apache).
- Create a security group that allows inbound HTTP (port 80) access.
- Use user data to automatically install and start the web server.
- Output the public IP or DNS of the instance.

## Commands

- terraform init (initializes the providers in providers.tf, first time only)
- terraform plan (creates plan for resources and shows the changes that will take place)
- terraform apply (Actually applies the plan, requires yes keyword, bypassed by -auto-approve flag)

## Notes
Automatically uses the aws cli config if none is provided in the provider block