output "regional_connect_instances" {
  description = "Amazon Connect deployment outputs by region."
  value = {
    "us-east-1" = {
      region             = "us-east-1"
      instance_id        = try(module.connect_us_east_1[0].instance_id, null)
      instance_arn       = try(module.connect_us_east_1[0].instance_arn, null)
      queue_id           = try(module.connect_us_east_1[0].queue_id, null)
      routing_profile_id = try(module.connect_us_east_1[0].routing_profile_id, null)
      admin_user_id      = try(module.connect_us_east_1[0].admin_user_id, null)
    }
    "eu-central-1" = {
      region             = "eu-central-1"
      instance_id        = try(module.connect_eu_central_1[0].instance_id, null)
      instance_arn       = try(module.connect_eu_central_1[0].instance_arn, null)
      queue_id           = try(module.connect_eu_central_1[0].queue_id, null)
      routing_profile_id = try(module.connect_eu_central_1[0].routing_profile_id, null)
      admin_user_id      = try(module.connect_eu_central_1[0].admin_user_id, null)
    }
    "ap-southeast-1" = {
      region             = "ap-southeast-1"
      instance_id        = try(module.connect_ap_southeast_1[0].instance_id, null)
      instance_arn       = try(module.connect_ap_southeast_1[0].instance_arn, null)
      queue_id           = try(module.connect_ap_southeast_1[0].queue_id, null)
      routing_profile_id = try(module.connect_ap_southeast_1[0].routing_profile_id, null)
      admin_user_id      = try(module.connect_ap_southeast_1[0].admin_user_id, null)
    }
  }
}

output "regional_ec2_test_instances" {
  description = "Disposable EC2 test instance outputs by region."
  value = {
    "us-east-1" = {
      region       = "us-east-1"
      instance_id  = try(module.ec2_test_us_east_1[0].instance_id, null)
      instance_arn = try(module.ec2_test_us_east_1[0].instance_arn, null)
      private_ip   = try(module.ec2_test_us_east_1[0].private_ip, null)
      public_ip    = try(module.ec2_test_us_east_1[0].public_ip, null)
      ami_id       = try(module.ec2_test_us_east_1[0].ami_id, null)
    }
    "eu-central-1" = {
      region       = "eu-central-1"
      instance_id  = try(module.ec2_test_eu_central_1[0].instance_id, null)
      instance_arn = try(module.ec2_test_eu_central_1[0].instance_arn, null)
      private_ip   = try(module.ec2_test_eu_central_1[0].private_ip, null)
      public_ip    = try(module.ec2_test_eu_central_1[0].public_ip, null)
      ami_id       = try(module.ec2_test_eu_central_1[0].ami_id, null)
    }
    "ap-southeast-1" = {
      region       = "ap-southeast-1"
      instance_id  = try(module.ec2_test_ap_southeast_1[0].instance_id, null)
      instance_arn = try(module.ec2_test_ap_southeast_1[0].instance_arn, null)
      private_ip   = try(module.ec2_test_ap_southeast_1[0].private_ip, null)
      public_ip    = try(module.ec2_test_ap_southeast_1[0].public_ip, null)
      ami_id       = try(module.ec2_test_ap_southeast_1[0].ami_id, null)
    }
  }
}
