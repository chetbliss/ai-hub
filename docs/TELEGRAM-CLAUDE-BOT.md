# Telegram Claude Bot

Native Python service that bridges Telegram messages to Claude CLI.

## Overview

The Telegram Claude Bot uses long polling to receive messages from Telegram and forwards them to the Claude CLI for processing. This approach was chosen over n8n webhooks because:
- Internal network (10.10.10.x) cannot receive webhook callbacks from Telegram servers
- Simpler architecture with fewer moving parts
- Direct integration with Claude CLI via subprocess

## Architecture

```
Telegram App → Telegram API ← Long Polling ← telegram-claude-bot.py → Claude CLI
                                                      ↓
                                              Prometheus metrics
                                                      ↓
                                              Grafana dashboard
```

## Components

### Python Script
- **Location**: `/opt/ai-hub/telegram-claude-bot/telegram_claude_bot.py`
- **Virtual env**: `/opt/ai-hub/telegram-claude-bot/venv`
- **Dependencies**: `requests`, `prometheus_client`

### Systemd Service
- **Service**: `telegram-claude-bot.service`
- **User**: `cbliss`
- **Auto-restart**: Yes (10 second delay)

## Configuration

### Ansible Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `telegram_bot_token` | env lookup | Bot token from @BotFather |
| `telegram_allowed_chat_ids` | `[8355680407]` | Whitelist of authorized chat IDs |
| `telegram_poll_timeout` | `60` | Long polling timeout in seconds |
| `telegram_metrics_port` | `9120` | Prometheus metrics port |
| `apprise_url` | localhost:8000 | Apprise notification URL |
| `claude_command` | `/usr/bin/claude` | Path to Claude CLI |

### Environment Variables (Service)

```ini
TELEGRAM_BOT_TOKEN=<token>
POLL_TIMEOUT=60
METRICS_PORT=9120
APPRISE_URL=http://localhost:8000/notify/apprise
CLAUDE_COMMAND=/usr/bin/claude
```

## Security

### Chat ID Whitelist
Only messages from authorized chat IDs are processed. Unauthorized users receive a rejection message and are logged.

To find your chat ID:
1. Message the bot
2. Check service logs: `journalctl -u telegram-claude-bot -f`
3. Look for "Unauthorized message from chat_id=XXXXX"

### Service Hardening
- `NoNewPrivileges=true` - Prevents privilege escalation
- `PrivateTmp=true` - Isolated /tmp directory
- Runs as non-root user (cbliss)

## Monitoring

### Prometheus Metrics

| Metric | Type | Description |
|--------|------|-------------|
| `telegram_bot_up` | Gauge | 1 if bot is running |
| `telegram_messages_received_total` | Counter | Messages received (by chat_id, authorized) |
| `telegram_messages_processed_total` | Counter | Successfully processed messages |
| `telegram_messages_failed_total` | Counter | Failed message processing |
| `telegram_response_seconds` | Histogram | Claude response time distribution |
| `telegram_last_poll_timestamp` | Gauge | Unix timestamp of last successful poll |

### Grafana Dashboard

**URL**: https://grafana.lab.chettv.com/d/8a00d286-7579-4e97-9d56-bd3fd427a3d9/telegram-claude-bot

**Panels**:
- Bot Status (UP/DOWN)
- Messages Processed/Failed counts
- Average Response Time
- Time Since Last Poll
- Messages Over Time (graph)
- Response Time Distribution (p50/p95/p99)
- Success Rate gauge

### Prometheus Scrape Config

Added to `/opt/core-services/prometheus/prometheus.yml` on 10.10.10.4:

```yaml
- job_name: telegram-claude-bot
  static_configs:
    - targets: ["10.10.10.51:9120"]
      labels:
        instance: ai-hub-dev
  scrape_interval: 15s
  scrape_timeout: 10s
```

## Operations

### Service Management

```bash
# Status
systemctl status telegram-claude-bot

# Logs
journalctl -u telegram-claude-bot -f

# Restart
sudo systemctl restart telegram-claude-bot

# Check metrics
curl http://localhost:9120/metrics
```

### Testing

1. Send a message to @chettvbot on Telegram
2. Watch logs: `journalctl -u telegram-claude-bot -f`
3. Verify response in Telegram

### Troubleshooting

| Issue | Cause | Fix |
|-------|-------|-----|
| No response | Claude CLI error | Check `journalctl` for error details |
| "Unauthorized" | Chat ID not whitelisted | Add chat ID to `telegram_allowed_chat_ids` |
| 409 Conflict | Another bot polling same token | Stop other instances (e.g., n8n workflow) |
| Timeout | Claude taking >5 minutes | Simplify prompt or increase timeout |

## Deployment

### Via Jenkins
The bot is deployed automatically when running the AI Hub pipeline with `ansible-deploy` or `full-deploy` action.

### Manual Deployment
```bash
cd ai-hub
ansible-playbook -i ansible/inventory/dev ansible/playbooks/site.yml --tags telegram-claude-bot
```

## Files

```
ansible/roles/telegram-claude-bot/
├── defaults/main.yml                    # Default variables
├── handlers/main.yml                    # Service restart handler
├── tasks/main.yml                       # Installation tasks
└── templates/
    ├── telegram_claude_bot.py.j2        # Main Python script
    └── telegram-claude-bot.service.j2   # Systemd unit file
```

## Changelog

- **2026-01-21**: Initial implementation with native polling
- **2026-01-21**: Fixed Claude CLI stdin input (was using -p flag)
- **2026-01-21**: Removed ProtectHome=read-only (blocked Claude CLI)
- **2026-01-21**: Added Prometheus metrics and Grafana dashboard
