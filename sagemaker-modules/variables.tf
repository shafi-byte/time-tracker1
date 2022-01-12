variable "vpc_name" {
  description = "Name of the vpc"
}

variable "cidr" {
  description = "The CIDR block for the VPC"
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  default     = "default"
}