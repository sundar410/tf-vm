variable "region" {
  description = "AWS region for the VM"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use for the VM"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type (e.g., t2.micro)"
  type        = string
}

variable "key_pair_name" {
  description = "Name of the AWS key pair to use for SSH"
  type        = string
}

variable "instance_name" {
  description = "Name tag for the VM instance"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where resources will be deployed"
  type        = string
}
