output "instance_id" {
  description = "ID of the disposable EC2 test instance."
  value       = aws_instance.this.id
}

output "instance_arn" {
  description = "ARN of the disposable EC2 test instance."
  value       = aws_instance.this.arn
}

output "private_ip" {
  description = "Private IP address of the disposable EC2 test instance."
  value       = aws_instance.this.private_ip
}

output "public_ip" {
  description = "Public IP address of the disposable EC2 test instance."
  value       = aws_instance.this.public_ip
}

output "ami_id" {
  description = "Ubuntu AMI ID selected for the disposable EC2 test instance."
  value       = data.aws_ami.ubuntu.id
}
