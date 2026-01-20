variable "proxmox_node" {
  description = "Proxmox node name (pve01 or pve02)"
  type        = string
}

variable "vm_name" {
  description = "VM name"
  type        = string
}

variable "vm_ip" {
  description = "VM IP address (without subnet mask)"
  type        = string
}

variable "gateway" {
  description = "Network gateway"
  type        = string
  default     = "10.10.10.1"
}

variable "template_id" {
  description = "Debian template VM ID"
  type        = number
  default     = 102
}

variable "cpu_cores" {
  description = "CPU cores"
  type        = number
  default     = 2
}

variable "memory_mb" {
  description = "Memory in MB"
  type        = number
  default     = 4096
}

variable "disk_size_gb" {
  description = "Disk size in GB"
  type        = number
  default     = 100
}

variable "datastore" {
  description = "Datastore for VM disk"
  type        = string
  default     = "local-zfs"
}

variable "snippets_datastore" {
  description = "Datastore for cloud-init snippets"
  type        = string
  default     = "local"
}

variable "ssh_username" {
  description = "SSH username"
  type        = string
  default     = "cbliss"
}

variable "ssh_public_keys" {
  description = "SSH public keys for VM access"
  type        = list(string)
}

variable "user_data_file_id" {
  description = "Cloud-init user-data snippet ID (e.g., snippets-shared:snippets/user-data-ai-hub.yml)"
  type        = string
  default     = "snippets-shared:snippets/user-data-ai-hub.yml"
}
