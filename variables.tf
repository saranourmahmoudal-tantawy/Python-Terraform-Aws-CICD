variable "vpc_cidr" {
  description= "The VPC range"
  type= string
}

variable "subnet1_cidr" {
  description= "The subnet range"
  type= string
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "ami" {
  description = "AMI for instance"
  type = string
}


variable "instance_type" {
  description = "Instance Type for instance"
  type = string
}