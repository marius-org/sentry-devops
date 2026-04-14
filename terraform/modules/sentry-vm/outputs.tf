output "public_ip" {
  description = "Public IP of the Sentry server"
  value       = aws_eip.sentry.public_ip
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.sentry.id
}