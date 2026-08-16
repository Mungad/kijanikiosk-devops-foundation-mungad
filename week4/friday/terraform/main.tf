terraform {
  required_version = ">= 1.5.0"
}

locals {
  servers = {
    api = {
      name = "kijanikiosk-api"
    }

    payments = {
      name = "kijanikiosk-payments"
    }

    logs = {
      name = "kijanikiosk-logs"
    }
  }
}

module "app_server" {
  source = "./modules/app_server"

  for_each = local.servers

  name = each.value.name
}