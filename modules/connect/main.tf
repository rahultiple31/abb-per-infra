locals {
  name_prefix = lower(replace("${var.project_name}-${var.environment}-${var.region_code}", "_", "-"))
  tags = merge(var.common_tags, {
    RegionCode = var.region_code
    AWSRegion  = var.aws_region
    Service    = "connect"
  })
}

resource "aws_connect_instance" "this" {
  identity_management_type = "CONNECT_MANAGED"
  inbound_calls_enabled    = true
  outbound_calls_enabled   = true
  instance_alias           = substr("${var.contact_center_alias}-${var.environment}-${var.region_code}", 0, 62)
  tags                     = local.tags
}

data "aws_connect_hours_of_operation" "basic" {
  instance_id = aws_connect_instance.this.id
  name        = "Basic Hours"
}

resource "aws_connect_queue" "primary" {
  instance_id           = aws_connect_instance.this.id
  name                  = "${upper(var.region_code)} Primary Queue"
  description           = "Primary queue for ${upper(var.region_code)} ${var.environment} contact center."
  hours_of_operation_id = data.aws_connect_hours_of_operation.basic.hours_of_operation_id
  tags                  = local.tags
}

resource "aws_connect_security_profile" "agent" {
  instance_id = aws_connect_instance.this.id
  name        = "${upper(var.region_code)} Agent Security Profile"
  permissions = [
    "BasicAgentAccess",
    "OutboundCallAccess"
  ]
  tags = local.tags
}

resource "aws_connect_routing_profile" "primary" {
  instance_id               = aws_connect_instance.this.id
  name                      = "${upper(var.region_code)} Primary Routing Profile"
  description               = "Primary routing profile for ${upper(var.region_code)} ${var.environment} agents."
  default_outbound_queue_id = aws_connect_queue.primary.queue_id

  queue_configs {
    channel  = "VOICE"
    delay    = 0
    priority = 1
    queue_id = aws_connect_queue.primary.queue_id
  }

  media_concurrencies {
    channel     = "VOICE"
    concurrency = 1
  }

  tags = local.tags
}

resource "aws_connect_contact_flow" "placeholder" {
  instance_id = aws_connect_instance.this.id
  name        = "${upper(var.region_code)} Placeholder Inbound Flow"
  type        = "CONTACT_FLOW"
  description = "Placeholder flow for future IVR and routing logic import."
  content = jsonencode({
    Version     = "2019-10-30"
    StartAction = "disconnect"
    Actions = [{
      Identifier  = "disconnect"
      Type        = "DisconnectParticipant"
      Parameters  = {}
      Transitions = {}
    }]
  })
  tags = local.tags
}
