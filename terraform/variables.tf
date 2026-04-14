variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.xlarge"
}

variable "key_name" {
  description = "SSH key pair name on AWS"
  type        = string
  default     = "sentry-key"
}

variable "public_key_path" {
  description = "Path to your local public SSH key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ami_id" {
  description = "Ubuntu 22.04 AMI ID for eu-west-1"
  type        = string
  default     = "ami-0694d931cee176e7d"
}