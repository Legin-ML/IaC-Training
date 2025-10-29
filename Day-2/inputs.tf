variable "ami-id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
  default     = "ami-07d1f1c6865c6b0e7"  
}

variable "instance-type" {
  description = "The instance type for the EC2 instance"
  type        = string
}

variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "vpc-cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

locals {
  subnet-cidrs = cidrsubnets(var.vpc-cidr, 8, 8, 8, 8)
  description = "Subnet CIDR blocks derived from VPC CIDR"
}
  
variable "azs" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# variable "az2" {
#   description = "Availability Zone 2"
#   type        = string
#   default     = "us-east-1b"
# }

variable "all_cidr" {
    description = "CIDR block for allowing all traffic"
    type        = string
    default     = "0.0.0.0/0"
}

variable "allowed_cidr" {
  description = "CIDR block allowed to access the webserver"
  type        = string
  default     = "0.0.0.0/0"
}
