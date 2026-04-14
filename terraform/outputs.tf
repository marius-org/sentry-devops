output "sentry_public_ip" {
  description = "Public IP of the Sentry server"
  value       = aws_eip.sentry.public_ip
}

output "ssh_connection" {
  description = "SSH command to connect to the server"
  value       = "ssh -i ~/.ssh/id_rsa ubuntu@${aws_eip.sentry.public_ip}"
}

output "sentry_url" {
  description = "Sentry web interface URL"
  value       = "http://${aws_eip.sentry.public_ip}:9000"
}