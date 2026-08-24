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
  description = "Business region code, for example us, europe, or apac."
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to resources."
  type        = map(string)
}

variable "contact_center_alias" {
  description = "Base alias for Amazon Connect instances."
  type        = string
}
