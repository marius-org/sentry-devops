terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "sentry_vm" {
  source          = "./modules/sentry-vm"
  aws_region      = var.aws_region
  instance_type   = var.instance_type
  key_name        = var.key_name
  public_key_path = var.public_key_path
  ami_id          = var.ami_id
}