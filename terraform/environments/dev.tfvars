# Development Environment - AI Hub v2
# Target: 10.10.10.51

proxmox_node = "pve02"
vm_name      = "ai-hub-dev"
vm_ip        = "10.10.10.51"
cpu_cores    = 2
memory_mb    = 4096
disk_size_gb = 100

# SSH public keys (personal + jenkins)
ssh_public_keys = [
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCRyptcwOtuzHohxUJbOdLP1VH+uYT6gWQSwg73+AOnwVAhpXcW6XRuBFFesjObC4GdguOZqPZywFiXkSGJt8/4AqL3hFy83EpUR1WieO7GVCIz/ed0U2hspoxXrO5CDa9TLNM46zEOMmM41yK17PKDu8N9mNtwVUfG3qUCSaSwxuDvXnlElNnG8CEyO+4PeMHD0ASc2PiokmL+SowuGMa7mk7MM1fFvY0CT8EuFmUHXUhzyiyZwUMdQBBGlLTpO8T5gtJpx4Y/LtaOlC9cTnDzfwBtdivl3rvK/TLgQyrEKavkr6dr00vaG0ypWnuSdNz4+wQ9owrEB0pwPwYKRSiP rsa-key-20251227",
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFBQNSNptIoOlA04Y8xkc2DQd3QbjjBc1BTa8Ild4378 jenkins@lab.chettv.com"
]
