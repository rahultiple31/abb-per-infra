environment          = "uat"
project_name         = "aws-connect"
aws_region           = "us-east-1"
contact_center_alias = "company-connect-uat"
enabled_modules      = ["connect"]

common_tags = {
  CostCenter = "contact-center"
  Owner      = "platform-engineering"
}
