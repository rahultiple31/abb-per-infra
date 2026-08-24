locals {
  common_tags = merge(var.common_tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Platform    = "Amazon Connect Multi-Region UAT Environment"
    Network     = "No Custom VPC"
  })

  enabled_module_set = toset([for module_name in var.enabled_modules : lower(module_name)])
  deploy_connect     = contains(local.enabled_module_set, "connect")
  deploy_ec2         = contains(local.enabled_module_set, "ec2")
}

module "connect_us_east_1" {
  count  = local.deploy_connect ? 1 : 0
  source = "../../modules/connect"

  providers = {
    aws = aws.us_east_1
  }

  project_name         = var.project_name
  environment          = var.environment
  aws_region           = "us-east-1"
  region_code          = "us-east-1"
  common_tags          = local.common_tags
  contact_center_alias = var.contact_center_alias
}

module "connect_eu_central_1" {
  count  = local.deploy_connect ? 1 : 0
  source = "../../modules/connect"

  providers = {
    aws = aws.eu_central_1
  }

  project_name         = var.project_name
  environment          = var.environment
  aws_region           = "eu-central-1"
  region_code          = "eu-central-1"
  common_tags          = local.common_tags
  contact_center_alias = var.contact_center_alias
}

module "connect_ap_southeast_1" {
  count  = local.deploy_connect ? 1 : 0
  source = "../../modules/connect"

  providers = {
    aws = aws.ap_southeast_1
  }

  project_name         = var.project_name
  environment          = var.environment
  aws_region           = "ap-southeast-1"
  region_code          = "ap-southeast-1"
  common_tags          = local.common_tags
  contact_center_alias = var.contact_center_alias
}

module "ec2_test_us_east_1" {
  count  = local.deploy_ec2 ? 1 : 0
  source = "../../modules/ec2_test"

  providers = {
    aws = aws.us_east_1
  }

  project_name = var.project_name
  environment  = var.environment
  aws_region   = "us-east-1"
  region_code  = "us-east-1"
  common_tags  = local.common_tags
}

module "ec2_test_eu_central_1" {
  count  = local.deploy_ec2 ? 1 : 0
  source = "../../modules/ec2_test"

  providers = {
    aws = aws.eu_central_1
  }

  project_name = var.project_name
  environment  = var.environment
  aws_region   = "eu-central-1"
  region_code  = "eu-central-1"
  common_tags  = local.common_tags
}

module "ec2_test_ap_southeast_1" {
  count  = local.deploy_ec2 ? 1 : 0
  source = "../../modules/ec2_test"

  providers = {
    aws = aws.ap_southeast_1
  }

  project_name = var.project_name
  environment  = var.environment
  aws_region   = "ap-southeast-1"
  region_code  = "ap-southeast-1"
  common_tags  = local.common_tags
}
