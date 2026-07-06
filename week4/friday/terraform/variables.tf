variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "staging"
}

variable "ssh_user" {
  description = "SSH username"
  type        = string
  default     = "ubuntu"
}

variable "ssh_private_key" {
  description = "SSH private key path"
  type        = string
  default     = "~/.ssh/id_ed25519"
}