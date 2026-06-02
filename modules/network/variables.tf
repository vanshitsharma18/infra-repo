variable "vpc_name" {
  description = "VPC Name"
  type        = string
}

variable "subnet_name" {
  description = "Subnet Name"
  type        = string
}

variable "cidr" {
  description = "Subnet CIDR Range"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
}