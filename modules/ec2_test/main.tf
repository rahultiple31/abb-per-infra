locals {
  name_prefix = lower(replace("${var.project_name}-${var.environment}-${var.region_code}-ec2-test", "_", "-"))
  tags = merge(var.common_tags, {
    Name       = local.name_prefix
    RegionCode = var.region_code
    AWSRegion  = var.aws_region
    Service    = "ec2-test"
    Temporary  = "true"
  })
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "this" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = local.tags
}
