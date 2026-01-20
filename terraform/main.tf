terraform {
  required_version = ">= 1.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.69"
    }
  }
}

# AI Hub VM (meta-data files pre-created on snippets-shared)
resource "proxmox_virtual_environment_vm" "ai_hub" {
  name        = var.vm_name
  description = "AI Hub v2 - Second Brain with Claude/Gemini CLI, n8n, MCP servers"
  node_name   = var.proxmox_node
  # vm_id is auto-assigned by Proxmox (next available ID)

  # Clone from Debian 12 template
  clone {
    vm_id = var.template_id
  }

  # Resources
  cpu {
    cores   = var.cpu_cores
    sockets = 1
    type    = "host"
  }

  memory {
    dedicated = var.memory_mb
  }

  # Network
  network_device {
    bridge = "vmbr0"
  }

  # Disk
  disk {
    datastore_id = var.datastore
    interface    = "scsi0"
    size         = var.disk_size_gb
    file_format  = "raw"
  }

  # Cloud-init using pre-existing snippet files
  initialization {
    datastore_id = var.datastore

    # Reference pre-existing cloud-init files on snippets-shared
    meta_data_file_id = "snippets-shared:snippets/meta-${var.vm_name}.yml"
    user_data_file_id = var.user_data_file_id

    ip_config {
      ipv4 {
        address = "${var.vm_ip}/24"
        gateway = var.gateway
      }
    }
  }

  # Start VM after creation
  started = true

  lifecycle {
    ignore_changes = [
      # Ignore cloud-init changes after first boot
      initialization,
    ]
  }
}

# Output VM details for Ansible
output "vm_ip" {
  value       = var.vm_ip
  description = "AI Hub VM IP address"
}

output "vm_id" {
  value       = proxmox_virtual_environment_vm.ai_hub.vm_id
  description = "AI Hub VM ID"
}

output "vm_name" {
  value       = proxmox_virtual_environment_vm.ai_hub.name
  description = "AI Hub VM name"
}

output "node_name" {
  value       = var.proxmox_node
  description = "Proxmox node hosting AI Hub"
}
