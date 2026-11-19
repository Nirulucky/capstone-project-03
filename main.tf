terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Get the latest Amazon Linux 2023 AMI
data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# Create EC2 instance
resource "aws_instance" "monitoring_server" {
  ami           = data.aws_ssm_parameter.al2023_ami.value
  instance_type = var.instance_type

  # Enable 1-minute CloudWatch monitoring
  monitoring = true

  # Generate CPU load automatically after boot
  user_data = <<-EOF
              #!/bin/bash

              # Start CPU-intensive processes
              for i in $(seq 1 $(nproc)); do
                yes > /dev/null &
              done
              EOF

  tags = {
    Name        = "Project-03-EC2-Monitoring"
    Environment = "Training"
    Project     = "Capstone-Project-03"
  }
}

# CloudWatch CPU alarm
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "project-03-ec2-high-cpu"
  alarm_description   = "Alarm when EC2 CPU utilization exceeds 70%"
  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 1
  period             = 60
  statistic          = "Average"
  threshold          = 70

  metric_name = "CPUUtilization"
  namespace   = "AWS/EC2"
  unit        = "Percent"

  dimensions = {
    InstanceId = aws_instance.monitoring_server.id
  }

  treat_missing_data = "notBreaching"

  alarm_actions = []
}
