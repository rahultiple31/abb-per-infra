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

variable "admin_user_enabled" {
  description = "Whether to create an initial Amazon Connect administrator user."
  type        = bool
  default     = false
}

variable "admin_user_first_name" {
  description = "First name for the Amazon Connect administrator user."
  type        = string
  default     = null
}

variable "admin_user_last_name" {
  description = "Last name for the Amazon Connect administrator user."
  type        = string
  default     = null
}

variable "admin_user_username" {
  description = "Username for the Amazon Connect administrator user."
  type        = string
  default     = null
}

variable "admin_user_password" {
  description = "Password for the Amazon Connect administrator user. Set this from a secret variable."
  type        = string
  default     = null
  sensitive   = true
}

variable "admin_user_email" {
  description = "Email address for the Amazon Connect administrator user."
  type        = string
  default     = null
}
