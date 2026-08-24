variable "project_name" {
  description = "Project prefix used for names and tags."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "aws_region" {
  description = "AWS region for this module instance."
  type        = string
}

variable "region_code" {
  description = "Business region code, for example us-east-1, eu-central-1, or ap-southeast-1."
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to resources."
  type        = map(string)
}

variable "instance_type" {
  description = "EC2 instance type for the disposable pipeline test instance."
  type        = string
  default     = "t3.nano"
}

variable "key_name" {
  description = "Existing EC2 key pair name used for the test instance."
  type        = string
  default     = "default"
}
