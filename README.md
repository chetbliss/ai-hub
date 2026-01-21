# AI Hub v2 - Second Brain Infrastructure

**Status:** In Development
**Version:** 2.0.0
**Target:** Dev (10.10.10.51), Prod (10.10.10.50)

---

## Overview

AI Hub v2 is a comprehensive "second brain" system that combines:
- **Knowledge Base**: Semantic search across all homelab documentation
- **Personal Memory**: Todos, reminders, notes organized by category
- **Live Infrastructure**: MCP servers for Proxmox, UniFi monitoring
- **Conversational Interface**: Slack/Telegram bots powered by Claude/Gemini

---

## Architecture

```
User → Telegram → telegram-claude-bot (polling) → Claude CLI
                                                       ↓
                                      ┌────────────────┴───────────────┐
                                      ↓                                ↓
                              Memory MCP Server                Infrastructure MCPs
                              ├─ Qdrant (semantic search)      ├─ Proxmox (live stats)
                              ├─ SQLite (todos/reminders)      └─ UniFi (network)
                              └─ Document ingestion
```

---

## Components

### Infrastructure (Terraform)
- VM provisioning on Proxmox
- Minimal cloud-init (user + SSH only)
- Environment-specific configs (dev/prod)

### Configuration (Ansible)
- Idempotent setup (replaces cloud-init)
- Modular roles for each component
- Automated deployment via Jenkins

### Storage Layer
- **Qdrant**: Vector database for semantic search
- **SQLite**: Structured data (todos, reminders)
- **OpenAI Embeddings**: Text → numbers conversion

### Memory MCP Server
- Custom Node.js MCP server
- 9 tools: search, store, todos, reminders
- Integrates with Claude CLI automatically

### Telegram Bot (Native)
- Python service with long polling
- Chat ID whitelist for security
- Prometheus metrics on port 9120
- Grafana dashboard: https://grafana.lab.chettv.com

### Automation (n8n)
- Slack bot workflow
- Daily document sync

---

## Deployment

### Prerequisites
1. Jenkins credentials configured:
   - `anthropic-api-key`
   - `gemini-api-key`
   - `openai-api-key`
   - `proxmox-jenkins-token`
2. SSH keys on AI Hub VM
3. Proxmox template 102 (Debian 12)

### Deploy to Dev (10.10.10.51)
```bash
cd ai-hub
./scripts/deploy-ai-hub.sh dev full-deploy
```

### Deploy via Jenkins
```
Jenkins → AI Hub Pipeline
Environment: dev
Action: full-deploy
```

---

## Directory Structure

```
ai-hub/
├── terraform/          # VM provisioning
│   ├── main.tf
│   ├── variables.tf
│   └── environments/
│       ├── dev.tfvars
│       └── prod.tfvars
├── ansible/            # Configuration management
│   ├── inventory/
│   ├── playbooks/
│   ├── roles/
│   └── group_vars/
├── mcp-servers/        # Custom MCP server code
│   └── mcp-memory/
├── docker/             # Docker compose configs
│   └── docker-compose.yml
├── n8n/                # Workflow templates
│   └── workflows/
├── scripts/            # Helper scripts
└── Jenkinsfile         # CI/CD pipeline
```

---

## Usage Examples

### Via SSH (Direct)
```bash
ssh cbliss@10.10.10.51
claude
> "Search my homelab docs for Pi-hole setup"
> "Add todo: Update Proxmox certificates"
> "What reminders do I have for this week?"
```

### Via Slack
```
@claude hey remember I need to go to Costco today and get TP
@claude how did we setup the PVE exporter?
@claude what's the status of pve01?
```

### Via Telegram
```
claude what do I need to do today?
claude where is pihole running?
```

---

## Development Status

- [x] Directory structure created
- [x] Terraform configs
- [x] Ansible playbooks
- [x] Jenkinsfile & CI/CD
- [x] Claude CLI installation
- [x] Telegram Claude Bot (native polling)
- [x] Prometheus metrics & Grafana dashboard
- [x] n8n deployment
- [ ] Memory MCP server
- [ ] Slack bot workflow

---

## Documentation

- [AI Hub v1 Setup](../homelab-migration/ai-hub-setup.md)
- Session docs in `chettv-lab/deployments/ai-hub/`

---

**Last Updated:** 2026-01-21
**Next Steps:** Memory MCP server implementation
