# Open WebUI Role

Deploys Open WebUI as a web-based chat interface for AI Hub.

## Features

- **Web-based Chat**: Access AI models through browser (no SSH required)
- **Claude Integration**: Uses Anthropic API for Claude models
- **MCP Server Support**: Can connect to local MCP servers (manual configuration)
- **Authentication**: Email/password login, signup disabled for security
- **Mobile Friendly**: Works on phone, tablet, desktop

## Deployment

- **Container**: ghcr.io/open-webui/open-webui
- **Port**: 3000
- **Data**: /opt/ai-hub/open-webui
- **URL**: http://10.10.10.51:3000 (dev) or http://10.10.10.50:3000 (prod)

## First Time Setup

1. **Access Open WebUI**: Navigate to http://10.10.10.51:3000
2. **Create Admin Account**: First visitor creates admin account (email + password)
3. **Model Selection**: Claude models available via Anthropic API

## MCP Server Configuration (Manual)

Open WebUI supports MCP servers, but configuration is done via the web UI:

1. **Access Settings**: Click user icon → Settings
2. **Navigate to Connections**: Look for "MCP Servers" or "Tools" section
3. **Add MCP Server**:
   - **Name**: AI Hub Memory
   - **Type**: stdio
   - **Command**: `node`
   - **Args**: `["/opt/ai-hub/mcp-servers/mcp-memory/dist/index.js"]`
   - **Environment Variables**:
     - `OPENAI_API_KEY`: (your OpenAI key)
     - `QDRANT_URL`: `http://localhost:6333`
     - `SQLITE_DB`: `/opt/ai-hub/data/memory.db`

4. **Save and Test**: Server should connect and show 34 available tools

## Available Models

### Claude (via Anthropic API)
- claude-3-5-sonnet-20241022
- claude-3-opus-20240229
- claude-3-haiku-20240307

### GPT (if OpenAI key configured)
- gpt-4-turbo
- gpt-4
- gpt-3.5-turbo

## URLs

### Development (10.10.10.51)
- Open WebUI: http://10.10.10.51:3000
- n8n: http://10.10.10.51:5678
- Qdrant: http://10.10.10.51:6333

### Production (10.10.10.50)
- Open WebUI: http://10.10.10.50:3000
- n8n: http://10.10.10.50:5678
- Qdrant: http://10.10.10.50:6333

## Adding to Caddy (HTTPS)

To expose via HTTPS (https://chat.lab.chettv.com):

1. **Add to core-services/caddy/config/Caddyfile**:
```
chat.lab.chettv.com {
    reverse_proxy 10.10.10.50:3000
}
```

2. **Deploy core-services**: Git push triggers Jenkins deployment

## Security

- **Signup Disabled**: Only admin can create accounts
- **Authentication Required**: All access requires login
- **API Keys**: Stored in environment variables, not in database
- **Network**: Bound to all interfaces (accessible from network)

## Troubleshooting

### Container won't start
```bash
docker logs open-webui
```

### Can't access from browser
- Check firewall: `sudo ufw status`
- Verify port: `curl http://localhost:3000`

### MCP servers not working
- Verify PM2 status: `pm2 status`
- Check MCP server logs: `pm2 logs mcp-memory`
- Ensure paths are absolute in Open WebUI config

## References

- Open WebUI Docs: https://docs.openwebui.com
- MCP Protocol: https://modelcontextprotocol.io
- Anthropic API: https://docs.anthropic.com
