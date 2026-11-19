output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.monitoring_server.id
}

output "instance_public_ip" {
  description = "Public IP address of EC2"
  value       = aws_instance.monitoring_server.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of EC2"
  value       = aws_instance.monitoring_server.public_dns
}

output "cloudwatch_alarm_name" {
  description = "CloudWatch alarm name"
  value       = aws_cloudwatch_metric_alarm.cpu_high.alarm_name
}
