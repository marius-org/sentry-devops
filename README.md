# Sentry DevOps Assignment

This repository contains the infrastructure and automation code to deploy a self-hosted Sentry instance on AWS using Terraform and Ansible, along with a log rotation script.

## Repository Structure

    sentry-devops/
    ├── terraform/          # Terraform module to provision AWS infrastructure
    ├── ansible/            # Ansible playbook to install and configure Sentry
    ├── scripts/            # Log rotation bash script
    ├── cron/               # Cron job configuration
    └── README.md

## Prerequisites

Make sure the following tools are installed on your machine before running anything:

- Terraform >= 1.0
- Ansible >= 2.12
- AWS CLI configured with valid credentials
- Python3 and boto3 library
- SSH key pair generated at ~/.ssh/id_rsa

Install Python dependencies:

    pip3 install boto3 botocore

Install Ansible AWS collection:

    ansible-galaxy collection install -r ansible/requirements.yml

## Assignment 1: Deploy Self-Hosted Sentry on AWS

### Step 1 - Provision Infrastructure with Terraform

    cd terraform
    terraform init
    terraform plan
    terraform apply

Terraform will create:
- EC2 t3.xlarge instance (4 vCPU, 16GB RAM) running Ubuntu 22.04
- Security group allowing ports 22, 80, 443, 9000
- SSH key pair
- Elastic IP for stable public access

After apply, note the outputs:
- sentry_public_ip
- ssh_connection
- sentry_url

### Step 2 - Configure AWS credentials for Ansible dynamic inventory

Make sure your AWS CLI is configured:

    aws configure

### Step 3 - Install Sentry with Ansible

    cd ../ansible
    ansible-playbook playbook.yml

Ansible will automatically discover the EC2 instance using dynamic inventory by the tag Name=sentry-server and:
- Install Docker and Docker Compose
- Clone the Sentry self-hosted repository
- Run the Sentry installation script
- Start all Sentry services

### Step 4 - Access Sentry

Open your browser and go to:

    http://<sentry_public_ip>:9000

### Destroy Infrastructure

To avoid unnecessary AWS costs, destroy the infrastructure when done:

    cd terraform
    terraform destroy

## Assignment 2: Log Rotation Script

### How the Script Works

The script scripts/log_rotation.sh automates log rotation for /var/log/application.log:

- Copies and compresses the active log file to /var/log/archive/ with a date stamp
- Truncates the active log file using cat /dev/null to ensure the application continues writing without interruption
- Deletes compressed archives older than 5 days

### Log Retention and Archival Logic

- Active log: /var/log/application.log
- Archive location: /var/log/archive/
- Archive format: application.log.YYYYMMDD.gz
- Retention period: 5 days
- Compression: gzip

### Edge Cases Handled

- Log file not present: script exits gracefully with a warning
- Permission issues: script exits with an error message
- Script re-runs (idempotent): if archive for today already exists, archival is skipped

### Cron Schedule

The cron job runs daily at 2:00 AM:

    0 2 * * * root /bin/bash /scripts/log_rotation.sh >> /var/log/log_rotation.log 2>&1

To install the cron job:

    sudo cp cron/log_rotation.cron /etc/cron.d/log_rotation
    sudo chmod 644 /etc/cron.d/log_rotation

### How to Test the Script Manually

    # Create a test log file
    sudo touch /var/log/application.log
    echo "test log entry" | sudo tee -a /var/log/application.log

    # Run the script manually
    sudo bash scripts/log_rotation.sh

    # Check the archive
    ls -la /var/log/archive/

    # Check rotation log
    cat /var/log/log_rotation.log