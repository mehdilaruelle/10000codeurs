# Shared variables
variable "project_name" {
}

# Network
variable "region" {
  description = "AWS region used."
  default     = "eu-west-1"
}

locals {
  azs = {
    "eu-west-1" = ["eu-west-1a", "eu-west-1b"]
  }
}

variable "cidr_block" {
  description = "The CIDR block to use for VPC."
  default     = "10.0.0.0/16"
}

# Frontend
variable "front_elb_port" {
  description = "The port to allow from ELB."
  default     = "80"
}

variable "front_elb_protocol" {
  description = "The protocol to allow from ELB."
  default     = "http"
}

# Backend
variable "back_instance_number" {
  description = "The number of instance should be used in the autoscaling_group."
  default     = "2"
}

variable "back_instance_type" {
  description = "The instance type you want to use for your EC2 backend."
  default     = "t3.micro"
}
