variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string

}

variable "private_subnets" {
  description = "List of AZs mapped to private subnet CIDR blocks"
  type        = map(string)
}

variable "public_subnets" {
  description = "List of AZs mapped to public subnet CIDR blocks"
  type        = map(string)
}

variable "enable_igw" {
  description = "Whether to create an Internet Gateway"
  type        = bool
  default     = true
}

variable "enable_nat_gateway" {
  description = "Whether to create a NAT Gateway"
  type        = bool
  default     = false
}