variable "aws_region" {
  description = "Default AWS region for backend and unaliased provider operations."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project prefix used for names and tags."
  type        = string
  default     = "aws-connect"
}

variable "contact_center_alias" {
  description = "Alias prefix for the Amazon Connect dev instances."
  type        = string
  default     = "company-connect-dev"
}

variable "enabled_modules" {
  description = "Infrastructure modules enabled for this Terraform state. Supported values: connect, ec2."
  type        = list(string)
  default     = ["connect"]

  validation {
    condition     = length(setsubtract(toset([for module_name in var.enabled_modules : lower(module_name)]), toset(["connect", "ec2"]))) == 0
    error_message = "enabled_modules supports: connect, ec2."
  }
}

variable "common_tags" {
  description = "Additional tags applied to all resources."
  type        = map(string)
  default     = {}
}
