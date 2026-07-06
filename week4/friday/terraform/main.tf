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