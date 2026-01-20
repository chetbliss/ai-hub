provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = true

  # No SSH config needed - cloud-init files pre-created on snippets-shared
}

variable "proxmox_endpoint" {
  description = "Proxmox API endpoint"
  type        = string
  default     = "https://10.10.10.12:8006"
}

variable "proxmox_api_token" {
  description = "Proxmox API token (format: user@realm!tokenid=secret)"
  type        = string
  sensitive   = true
}
