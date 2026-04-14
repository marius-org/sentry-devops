variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name on AWS"
  type        = string
}

variable "public_key_path" {
  description = "Path to your local public SSH key"
  type        = string
}

variable "ami_id" {
  description = "Ubuntu 22.04 AMI ID"
  type        = string
}