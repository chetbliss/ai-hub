# AI Hub v2 - Implementation Plan

**Created:** 2026-01-19
**Status:** In Progress - Phase 1 Complete
**Target:** Dev (10.10.10.51) → Prod (10.10.10.50)

---

## Executive Summary

Building a "Second Brain" system that combines:
- **Knowledge Base**: Semantic search across all homelab documentation via Qdrant vector database
- **Personal Memory**: Todos, reminders, notes organized by category in SQLite
- **Live Infrastructure**: MCP servers for Proxmox, UniFi monitoring
- **Conversational Interface**: Slack/Telegram bots powered by Claude/Gemini
- **Learning Tools**: Security+ quiz mode, code snippet library, troubleshooting journal

**Key Difference from AI Hub v1:**
- v1: Manual cloud-init, no persistent memory, single VM setup
- v2: GitOps (Terraform + Ansible), Memory MCP server, dev/prod environments

---

## Architecture Overview

```
User → Slack/Telegram → n8n → Claude API
                                   ↓
                  ┌────────────────┴───────────────┐
                  ↓                                ↓
          Memory MCP Server                Infrastructure MCPs
          ├─ Qdrant (semantic search)      ├─ Proxmox (live stats)
          ├─ SQLite (todos/reminders)      └─ UniFi (network)
          └─ OpenAI embeddings
```

### Technology Stack

| Component | Technology | Purpose |
|-----------|-----------|---------|
| **Infrastructure** | Terraform | VM provisioning on Proxmox |
| **Configuration** | Ansible | Idempotent setup (replaces cloud-init) |
| **Vector DB** | Qdrant | Semantic search of documents |
| **Structured DB** | SQLite | Todos, reminders, metadata |
| **Embeddings** | OpenAI API | Convert text to numbers for search |
| **Knowledge API** | Memory MCP Server (Node.js) | Claude interface to data |
| **Automation** | n8n | Slack/Telegram → Claude workflows |
| **CI/CD** | Jenkins | Full deployment pipeline |

---

## Implementation Phases

### Phase 1: Foundation ✅ COMPLETE

**Goal:** Infrastructure as code foundation

**Deliverables:**
- [x] Directory structure created
- [x] Terraform VM provisioning configs
- [x] Ansible inventory and playbook skeleton
- [x] Documentation (README, this plan)

**Files Created:**
```
ai-hub/
├── README.md
├── IMPLEMENTATION-PLAN.md (this file)
├── terraform/
│   ├── main.tf
│   ├── provider.tf
│   ├── variables.tf
│   ├── .gitignore
│   └── environments/
│       ├── dev.tfvars
│       └── prod.tfvars
├── ansible/
│   ├── ansible.cfg
│   ├── group_vars/all.yml
│   ├── inventory/
│   │   ├── dev.yml
│   │   └── prod.yml
│   └── playbooks/
│       └── site.yml
```

**Git Status:** Ready to commit

---

### Phase 2: Ansible Roles (Next Session)

**Goal:** Build configuration management roles

**Roles to Create:**

#### Role 1: base-system
**Purpose:** Install Docker, Node.js, common tools
**Tasks:**
- Install system packages (curl, git, vim, htop, jq)
- Add Docker GPG key and repository
- Install Docker CE
- Add user to docker group
- Install Node.js 20.x
- Verify installations

**Files:**
```
ansible/roles/base-system/
├── tasks/main.yml
├── defaults/main.yml
└── handlers/main.yml
```

#### Role 2: claude-cli
**Purpose:** Install Claude CLI and configure API key
**Tasks:**
- Download and install Claude CLI via curl script
- Create ~/.claude directory
- Configure API key from environment
- Create empty mcpServers config
- Verify installation

**Files:**
```
ansible/roles/claude-cli/
├── tasks/main.yml
├── templates/
│   └── config.json.j2
└── defaults/main.yml
```

#### Role 3: gemini-cli
**Purpose:** Install Gemini CLI (optional, for comparison)
**Tasks:**
- Install via npm globally
- Configure API key
- Verify installation

**Files:**
```
ansible/roles/gemini-cli/
├── tasks/main.yml
└── defaults/main.yml
```

#### Role 4: qdrant
**Purpose:** Deploy Qdrant vector database container
**Tasks:**
- Create data directory
- Deploy Qdrant container via docker
- Wait for healthcheck
- Create knowledge_base collection
- Verify collection exists

**Files:**
```
ansible/roles/qdrant/
├── tasks/main.yml
├── defaults/main.yml
└── templates/
    └── qdrant-docker-compose.yml.j2
```

#### Role 5: sqlite
**Purpose:** Set up SQLite database for structured data
**Tasks:**
- Create data directory
- Install sqlite3 if needed
- Create database file with proper permissions
- Initialize schema (via Memory MCP setup script)

**Files:**
```
ansible/roles/sqlite/
├── tasks/main.yml
└── defaults/main.yml
```

#### Role 6: n8n
**Purpose:** Deploy n8n workflow automation
**Tasks:**
- Create n8n data directory
- Deploy n8n container
- Wait for healthcheck
- Configure environment variables

**Files:**
```
ansible/roles/n8n/
├── tasks/main.yml
├── defaults/main.yml
└── templates/
    └── n8n-docker-compose.yml.j2
```

#### Role 7: mcp-proxmox
**Purpose:** Install existing Proxmox MCP server
**Tasks:**
- Clone mcp-proxmox repository
- Install npm dependencies
- Create .env file with Proxmox credentials
- Update Claude config to include Proxmox MCP
- Test MCP connection

**Files:**
```
ansible/roles/mcp-proxmox/
├── tasks/main.yml
├── templates/
│   └── proxmox-mcp-env.j2
└── defaults/main.yml
```

#### Role 8: mcp-memory
**Purpose:** Install custom Memory MCP server
**Tasks:**
- Copy Memory MCP server code to VM
- Install npm dependencies
- Create .env file with API keys
- Run database setup script
- Update Claude config to include Memory MCP
- Test MCP tools

**Files:**
```
ansible/roles/mcp-memory/
├── tasks/main.yml
├── templates/
│   └── memory-mcp-env.j2
└── defaults/main.yml
```

#### Role 9: document-ingestion
**Purpose:** Initial ingestion of markdown documentation
**Tasks:**
- Clone homelab-migration repository
- Run document ingestion script
- Create .ingestion_complete marker
- Display ingestion results

**Files:**
```
ansible/roles/document-ingestion/
├── tasks/main.yml
└── defaults/main.yml
```

**Time Estimate:** 1.5-2 hours to create all roles

---

### Phase 3: Memory MCP Server (Next Session)

**Goal:** Build custom Node.js MCP server for knowledge base

**Structure:**
```
mcp-servers/mcp-memory/
├── package.json
├── index.js                    # Main MCP server
├── .env.example
├── lib/
│   ├── qdrant-client.js       # Vector DB interface
│   ├── sqlite-client.js       # SQLite interface
│   ├── embeddings.js          # OpenAI embeddings wrapper
│   └── tools/
│       ├── knowledge.js       # search_knowledge, store_note, etc.
│       ├── todos.js           # add_todo, get_todos, complete_todo
│       └── reminders.js       # add_reminder, get_reminders
├── scripts/
│   ├── setup-database.js      # Initialize DBs
│   ├── ingest-documents.js    # Document ingestion
│   └── test-mcp.js            # Test MCP tools
└── README.md
```

**MCP Tools to Implement:**

1. **search_knowledge(query, category, limit)**
   - Generate embedding from query
   - Search Qdrant collection
   - Return top N results with scores

2. **store_note(content, category, tags)**
   - Generate embedding from content
   - Store in Qdrant with metadata
   - Return confirmation

3. **store_document(title, content, category, metadata)**
   - Chunk document into pieces
   - Generate embeddings for each chunk
   - Store in Qdrant
   - Return confirmation

4. **get_document(id)**
   - Retrieve document from Qdrant by ID
   - Return full document

5. **add_todo(task, category, due_date)**
   - Insert into SQLite todos table
   - Return todo ID

6. **get_todos(category, status)**
   - Query SQLite with filters
   - Return list of todos

7. **complete_todo(id)**
   - Update todo status in SQLite
   - Set completed_at timestamp

8. **add_reminder(content, date)**
   - Insert into SQLite reminders table
   - Return reminder ID

9. **get_reminders(start_date, end_date)**
   - Query SQLite for reminders in range
   - Return list

**Dependencies:**
```json
{
  "dependencies": {
    "@modelcontextprotocol/sdk": "^1.0.0",
    "@qdrant/js-client-rest": "^1.11.0",
    "better-sqlite3": "^11.0.0",
    "openai": "^4.0.0",
    "dotenv": "^16.4.5",
    "gray-matter": "^4.0.3",
    "markdown-it": "^14.1.0"
  }
}
```

**Time Estimate:** 2-3 hours to build complete MCP server

---

### Phase 4: Docker Compose (Quick)

**Goal:** Deploy Qdrant + n8n via Docker Compose

**File:** `docker/docker-compose.yml`

```yaml
version: '3.8'

services:
  qdrant:
    image: qdrant/qdrant:latest
    container_name: qdrant
    restart: unless-stopped
    ports:
      - "6333:6333"  # HTTP API
      - "6334:6334"  # gRPC API
    volumes:
      - qdrant_data:/qdrant/storage
    networks:
      - ai-hub

  n8n:
    image: n8nio/n8n:latest
    container_name: n8n
    restart: unless-stopped
    ports:
      - "5678:5678"
    environment:
      - N8N_HOST=0.0.0.0
      - N8N_PORT=5678
      - N8N_PROTOCOL=http
      - NODE_ENV=production
      - WEBHOOK_URL=http://10.10.10.51:5678
      - GENERIC_TIMEZONE=America/New_York
    volumes:
      - n8n_data:/home/node/.n8n
    networks:
      - ai-hub

volumes:
  qdrant_data:
  n8n_data:

networks:
  ai-hub:
    driver: bridge
```

**Time Estimate:** 15 minutes

---

### Phase 5: n8n Workflows (Quick)

**Goal:** Create basic Slack and Telegram bot workflows

**Workflows to Create:**

#### 1. Slack Bot (slack-bot.json)
```
Slack Trigger → Check for @claude →
Extract Message → Call Claude API →
Format Response → Reply to Slack
```

#### 2. Telegram Bot (telegram-bot.json)
```
Telegram Trigger → Extract Message →
Call Claude API → Send Telegram Reply
```

#### 3. Daily Doc Sync (daily-doc-sync.json)
```
Schedule Trigger (daily) →
Update Git Repo → Ingest Documents →
Notify Slack of completion
```

**Telegram Integration:**
- Use existing bot: `8236588067:AAHwo1LgAXpnHKVtzCXLpbn1zziKFly_F-Q`
- Chat ID: `8355680407`
- Already configured in Jenkins as `telegram-apprise-url`

**Time Estimate:** 30 minutes

---

### Phase 6: Jenkinsfile (Medium)

**Goal:** Full CI/CD pipeline for deployment

**Pipeline Stages:**

1. **Checkout** - Clone repo
2. **Terraform Init** - Initialize Terraform
3. **Terraform Plan** - Generate plan
4. **Terraform Apply** - Create/update VM
5. **Wait for VM** - Wait for SSH access
6. **Ansible Configure** - Run all roles
7. **Verify Deployment** - Test each component
8. **Import n8n Workflows** - Load workflows via API
9. **Destroy** (optional) - Destroy VM if requested

**Parameters:**
- `ENVIRONMENT`: dev or prod
- `ACTION`: plan, apply, configure, destroy, full-deploy
- `REINGEST_DOCS`: Force re-ingestion (boolean)

**Jenkins Credentials Required:**
- `anthropic-api-key` ✅ Added
- `gemini-api-key` ✅ Added
- `openai-api-key` ✅ Added
- `proxmox-jenkins-token` (existing)

**Time Estimate:** 1 hour

---

### Phase 7: Testing & Validation

**Goal:** Verify everything works end-to-end

**Test Plan:**

1. **Infrastructure Tests**
   - [ ] VM created with correct IP
   - [ ] SSH access works
   - [ ] Docker running
   - [ ] Node.js installed

2. **Service Tests**
   - [ ] Claude CLI installed and working
   - [ ] Qdrant accessible on port 6333
   - [ ] SQLite database created
   - [ ] n8n accessible on port 5678

3. **MCP Server Tests**
   - [ ] Memory MCP server responds
   - [ ] Proxmox MCP server responds
   - [ ] Claude config includes both MCPs
   - [ ] Can execute MCP tools via Claude

4. **Knowledge Base Tests**
   - [ ] Documents ingested successfully
   - [ ] Semantic search returns relevant results
   - [ ] Can store new notes
   - [ ] Can retrieve documents by ID

5. **Todo/Reminder Tests**
   - [ ] Can add todos
   - [ ] Can retrieve todos by category
   - [ ] Can mark todos complete
   - [ ] Can add reminders
   - [ ] Can get reminders by date

6. **Bot Integration Tests**
   - [ ] Slack bot responds to messages
   - [ ] Telegram bot responds to messages
   - [ ] Bots can search knowledge base
   - [ ] Bots can add todos/reminders

7. **End-to-End Tests**
   - [ ] Ask via Slack: "How did we setup PVE exporter?"
   - [ ] Should return relevant documentation
   - [ ] Ask via Telegram: "Add todo: Update certificates"
   - [ ] Should confirm todo added
   - [ ] SSH to VM, run claude, search knowledge base
   - [ ] Should return semantic search results

**Time Estimate:** 1-2 hours

---

## Deployment Strategy

### Option 1: All-at-Once (Recommended for First Deployment)
1. Build all components in phases 2-6
2. Test locally where possible
3. Deploy to dev (10.10.10.51) via Jenkins
4. Run full test plan
5. Fix issues, iterate
6. Deploy to prod (10.10.10.50) when stable

### Option 2: Incremental (Lower Risk)
1. Deploy Phase 2 only (Ansible roles for base system)
2. Test and validate
3. Add Phase 3 (Memory MCP server)
4. Test and validate
5. Continue adding phases one at a time

### Option 3: Terraform First (Infrastructure Validation)
1. Deploy just Terraform (VM creation)
2. Manually SSH and verify
3. Add Ansible roles incrementally
4. Test each role as added
5. Add automation (Jenkins) last

**Recommendation:** Option 1 for speed, Option 2 if being cautious

---

## Cost Analysis

### One-Time Costs

**OpenAI Embeddings:**
- Initial ingestion: ~50 markdown files × 2000 words avg = 100k words
- Cost: $0.02 per 1M tokens (1 token ≈ 0.75 words)
- **Total: $0.002** (less than a penny)

**Setup Time:**
- Phase 2: 2 hours (Ansible roles)
- Phase 3: 3 hours (MCP server)
- Phase 4: 15 minutes (Docker Compose)
- Phase 5: 30 minutes (n8n workflows)
- Phase 6: 1 hour (Jenkinsfile)
- Phase 7: 2 hours (Testing)
- **Total: ~9 hours** of development time

### Ongoing Costs

**OpenAI API (Embeddings):**
- New note/document: ~500 words × $0.02 / 1M tokens
- Cost per note: $0.000013 (basically free)
- Monthly: ~$0.05 assuming 100 new notes/month

**Anthropic Claude API:**
- Free tier: $5 credit
- After free tier: ~$3/M input tokens, $15/M output tokens
- Estimated usage: $2-5/month for casual use

**Google Gemini API:**
- Free tier: 15 requests/min, 1500/day
- Cost: FREE for personal use

**Infrastructure:**
- No additional cost (using existing Proxmox hardware)
- Disk space: ~5GB for all data

**Total Monthly Cost: $2-5** (mostly Claude API)

---

## Prerequisites Completed ✅

- [x] Anthropic API key obtained and added to Jenkins
- [x] Gemini API key obtained and added to Jenkins
- [x] OpenAI API key obtained and added to Jenkins
- [x] $5 added to OpenAI account for API usage
- [x] SSH keys identified on AI Hub VM
- [x] Telegram bot configured (from Apprise setup)
- [x] Git repository structure ready (core-services repo)
- [x] Jenkins credentials configured

---

## Next Session Tasks

When you resume:

1. **Review Progress**
   ```bash
   cd /mnt/c/Users/crb/OneDrive/Documents/aiterminal/claude/homelab-migration/core-services/ai-hub
   git status
   ```

2. **Continue from Phase 2**
   - Start creating Ansible roles (base-system first)
   - Test each role as you create it

3. **Quick Wins First**
   - Build base-system, claude-cli, qdrant roles
   - Deploy to dev (.51) and verify basics work
   - Then continue with Memory MCP server

---

## Rollback Plan

If deployment fails:

### Option 1: Terraform Destroy
```bash
cd ai-hub/terraform
terraform destroy -var-file=environments/dev.tfvars -auto-approve
```

### Option 2: Revert Git Changes
```bash
git revert HEAD
git push origin main
```

### Option 3: Restore to Current AI Hub
- Current AI Hub at 10.10.10.50 remains untouched
- Dev deployment at .51 is isolated
- Can always fall back to existing v1 setup

---

## Success Criteria

Deployment is successful when:

1. ✅ VM created and accessible via SSH
2. ✅ All Docker containers running (Qdrant, n8n)
3. ✅ Claude CLI installed with API key configured
4. ✅ Memory MCP server responding to tool calls
5. ✅ Documents ingested and searchable
6. ✅ Can add/retrieve todos via MCP tools
7. ✅ Slack bot responds with knowledge base search
8. ✅ Telegram bot responds with knowledge base search
9. ✅ End-to-end test: "How did we setup PVE exporter?" returns correct doc
10. ✅ End-to-end test: "Add todo: Test something" creates todo successfully

---

### Phase 8: Core Use Cases

**Goal:** Implement primary use cases beyond basic knowledge storage

**Use Cases to Implement:**

#### Use Case 1: Security+ Quiz Mode

**Purpose:** Interactive study tool for Security+ certification

**Features:**
- Store quiz questions with metadata (domain, difficulty, tags)
- Track quiz sessions and performance
- Adaptive learning (focus on weak areas)
- Spaced repetition scheduling
- Performance analytics by domain

**New MCP Tools:**
```javascript
start_quiz(category, count, difficulty)
  // Starts new quiz session, returns session_id

get_next_question(session_id)
  // Returns next question based on difficulty/category

submit_answer(session_id, question_id, answer)
  // Records answer, returns correct/incorrect + explanation

get_quiz_stats(category)
  // Returns performance statistics by domain

get_weak_areas()
  // Identifies domains needing more study

review_missed_questions(limit)
  // Returns questions previously answered incorrectly
```

**Question Storage Format:**
```markdown
---
category: security-plus
domain: 1.0 Threats, Attacks and Vulnerabilities
subdomain: 1.2 Compare and contrast types of attacks
difficulty: medium
tags: [phishing, social-engineering]
last_asked: 2026-01-15
times_correct: 3
times_wrong: 1
---

# Question
An attacker sends an email appearing to be from a trusted source...

A) Vishing
B) Smishing
C) Phishing
D) Whaling

## Answer
C

## Explanation
Phishing is an email-based social engineering attack...
```

**SQLite Schema Additions:**
```sql
CREATE TABLE quiz_sessions (
  id INTEGER PRIMARY KEY,
  category TEXT,
  started_at DATETIME,
  completed_at DATETIME,
  total_questions INTEGER,
  correct_answers INTEGER
);

CREATE TABLE quiz_answers (
  id INTEGER PRIMARY KEY,
  session_id INTEGER,
  question_id TEXT,
  user_answer TEXT,
  correct_answer TEXT,
  is_correct BOOLEAN,
  answered_at DATETIME,
  FOREIGN KEY (session_id) REFERENCES quiz_sessions(id)
);

CREATE TABLE question_stats (
  question_id TEXT PRIMARY KEY,
  times_asked INTEGER DEFAULT 0,
  times_correct INTEGER DEFAULT 0,
  last_asked DATETIME,
  next_review DATETIME
);
```

**Conversational Flow:**
```
You: @claude let's do Security+ questions
Claude: Starting Security+ quiz!
Domain: All (or specify domain 1.0, 2.0, etc.)
Difficulty: Mixed (or easy/medium/hard)
Questions: 10 (or specify count)

Ready? Type 'start'

You: start
Claude: Question 1/10 (Domain 1.2 - Medium)

An attacker sends an email that appears to be from...
A) Vishing
B) Smishing
C) Phishing
D) Whaling

Your answer?

You: C
Claude: ✅ Correct!

Explanation: Phishing is an email-based social engineering attack...

Score: 1/1 (100%)
Next question? (yes/no/stats)

You: stats
Claude: Quiz Statistics:

Current Session: 1/1 correct (100%)

Overall Performance:
Domain 1.0: 42/50 (84%)
Domain 2.0: 18/25 (72%) ← Focus here
Domain 3.0: 27/30 (90%)

Weak areas: AAA concepts (4 wrong), PKI basics (3 wrong)
Ready for exam: Not yet (aim for 85%+ across all domains)
```

**Time Estimate:** 2 hours
- 1 hour: MCP tools implementation
- 30 min: Question storage/retrieval
- 30 min: Stats tracking and analytics

---

#### Use Case 2: Code Snippet Library

**Purpose:** Store and retrieve frequently used commands, scripts, and code patterns

**Features:**
- Store snippets with tags and descriptions
- Search by description, language, or tags
- Track usage frequency
- Version history
- Quick copy-paste via chat

**New MCP Tools:**
```javascript
add_snippet(title, code, language, tags, description)
  // Stores code snippet with metadata

search_snippets(query, language, tags)
  // Semantic search across snippet descriptions

get_snippet(id)
  // Retrieve full snippet by ID

update_snippet(id, code)
  // Update snippet, preserves version history

get_popular_snippets(limit)
  // Returns most-used snippets

get_recent_snippets(limit)
  // Returns recently used snippets
```

**Snippet Storage Format:**
```yaml
id: docker-cleanup-001
title: Docker System Cleanup
language: bash
tags: [docker, cleanup, maintenance]
category: homelab
description: Remove stopped containers, unused networks, and dangling images
created: 2026-01-19
last_used: 2026-01-19
usage_count: 15
code: |
  # Complete Docker cleanup
  docker system prune -af --volumes

  # Selective cleanup
  docker container prune -f
  docker image prune -af
  docker volume prune -f
```

**SQLite Schema Additions:**
```sql
CREATE TABLE snippets (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  code TEXT NOT NULL,
  language TEXT,
  category TEXT,
  description TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  last_used DATETIME,
  usage_count INTEGER DEFAULT 0
);

CREATE TABLE snippet_tags (
  snippet_id TEXT,
  tag TEXT,
  FOREIGN KEY (snippet_id) REFERENCES snippets(id)
);

CREATE TABLE snippet_versions (
  id INTEGER PRIMARY KEY,
  snippet_id TEXT,
  code TEXT,
  changed_at DATETIME,
  change_note TEXT,
  FOREIGN KEY (snippet_id) REFERENCES snippets(id)
);

CREATE INDEX idx_snippets_language ON snippets(language);
CREATE INDEX idx_snippets_category ON snippets(category);
CREATE INDEX idx_snippet_tags_tag ON snippet_tags(tag);
```

**Conversational Flow:**
```
You: @claude show me that Docker cleanup command
Claude: Found snippet: Docker System Cleanup

```bash
# Complete Docker cleanup
docker system prune -af --volumes

# Selective cleanup
docker container prune -f
docker image prune -af
docker volume prune -f
```

Tags: docker, cleanup, maintenance
Last used: 3 days ago
Used 15 times

Copy to clipboard? (yes/no)

---

You: @claude add snippet - title "Restart all core services" - bash
Claude: Ready to capture snippet. Paste the code:

You: cd /opt/core-services && docker compose restart
Claude: ✅ Snippet saved!

ID: restart-core-services-001
Title: Restart all core services
Language: bash
Category: homelab
Tags: (add tags? docker, restart, core-services)

You: add tags
Claude: ✅ Tags added: docker, restart, core-services

Snippet ready for use. Try: @claude show me restart core services

---

You: @claude what are my most used snippets?
Claude: Top 10 Most Used Snippets:

1. Docker System Cleanup (15 uses) - bash
2. Check Docker logs (12 uses) - bash
3. SSH tunnel to Proxmox (9 uses) - bash
4. Git commit with co-author (8 uses) - bash
5. Ansible vault encrypt (7 uses) - bash
6. Find large files (6 uses) - bash
7. Python venv activate (5 uses) - bash
8. npm clean install (4 uses) - bash
9. Terraform plan with vars (4 uses) - bash
10. Jenkins pipeline syntax (3 uses) - groovy

Want details on any snippet? Just ask!
```

**Time Estimate:** 1.5 hours
- 45 min: MCP tools implementation
- 30 min: Version history tracking
- 15 min: Usage analytics

---

#### Use Case 3: Troubleshooting Journal

**Purpose:** Record problems and solutions for future reference

**Features:**
- Store problem + solution pairs
- Search by error message, symptoms, or tags
- Link related issues
- Track resolution time
- Suggest solutions based on past issues

**New MCP Tools:**
```javascript
add_troubleshooting_entry(problem, solution, tags, category)
  // Records a troubleshooting case

search_troubleshooting(query, category)
  // Semantic search across past issues

get_similar_issues(description)
  // Find past issues similar to current problem

link_issues(issue_id, related_id)
  // Link related troubleshooting entries

get_unresolved_issues()
  // Returns issues marked as unresolved

mark_resolved(issue_id, solution)
  // Update issue with solution
```

**Troubleshooting Entry Format:**
```yaml
id: ts-docker-perms-001
date: 2026-01-19
category: docker
status: resolved
resolution_time: 15 minutes

problem: |
  Getting "permission denied" error when accessing /var/lib/docker
  Error occurs when running docker compose commands
  User is not root

symptoms:
  - permission denied: /var/lib/docker/volumes
  - docker compose fails with exit code 1
  - sudo works but shouldn't be needed

solution: |
  Added user to docker group and logged out/in

  Commands:
  sudo usermod -aG docker $USER
  # Log out and back in (or: newgrp docker)

  Verification:
  groups | grep docker  # Should show docker group
  docker ps  # Should work without sudo

tags: [docker, permissions, usermod, groups]

related_issues:
  - ts-jenkins-docker-001
  - ts-portainer-access-002

lessons_learned: |
  - Always check group membership after adding to docker group
  - Logout/login required for group changes to take effect
  - Alternative: newgrp docker (no logout needed)
```

**SQLite Schema Additions:**
```sql
CREATE TABLE troubleshooting (
  id TEXT PRIMARY KEY,
  date DATETIME DEFAULT CURRENT_TIMESTAMP,
  category TEXT,
  status TEXT DEFAULT 'unresolved',
  problem TEXT NOT NULL,
  solution TEXT,
  resolution_time INTEGER,  -- minutes
  resolved_at DATETIME
);

CREATE TABLE troubleshooting_symptoms (
  troubleshooting_id TEXT,
  symptom TEXT,
  FOREIGN KEY (troubleshooting_id) REFERENCES troubleshooting(id)
);

CREATE TABLE troubleshooting_tags (
  troubleshooting_id TEXT,
  tag TEXT,
  FOREIGN KEY (troubleshooting_id) REFERENCES troubleshooting(id)
);

CREATE TABLE issue_links (
  issue_id TEXT,
  related_id TEXT,
  relationship TEXT,  -- 'similar', 'caused_by', 'led_to'
  FOREIGN KEY (issue_id) REFERENCES troubleshooting(id),
  FOREIGN KEY (related_id) REFERENCES troubleshooting(id)
);

CREATE INDEX idx_troubleshooting_status ON troubleshooting(status);
CREATE INDEX idx_troubleshooting_category ON troubleshooting(category);
```

**Conversational Flow:**
```
You: @claude I'm getting "permission denied" on /var/lib/docker
Claude: 🔍 Searching troubleshooting history...

✅ You solved this before on Dec 12, 2025!

Problem: Permission denied on Docker volumes
Solution: Added user to docker group, logged out/in

Commands used:
```bash
sudo usermod -aG docker $USER
# Log out and back in (or: newgrp docker)
```

Resolution time: 15 minutes

Similar issues you've solved:
- Jenkins Docker socket permissions (Jan 3, 2026)
  Solution: Used sudo chown for specific files

- Portainer access denied (Nov 15, 2025)
  Solution: Restarted Docker daemon

Try this solution? (yes/no/other)

---

You: @claude log troubleshooting - Jenkins job failing with npm permission error
Claude: Recording troubleshooting entry...

Problem: Jenkins job failing with npm permission error

What symptoms are you seeing?

You: npm ERR! EACCES: permission denied, mkdir '/home/jenkins/.npm'
Claude: Got it. What was the solution?

You: Changed ownership of .npm directory to jenkins user
Claude: ✅ Troubleshooting entry saved!

ID: ts-jenkins-npm-001
Category: jenkins (auto-detected)
Problem: Jenkins job failing with npm permission error
Solution: Changed ownership of .npm directory to jenkins user

Commands used:
(Add the exact commands? yes/no)

You: yes - sudo chown -R jenkins:jenkins /home/jenkins/.npm
Claude: ✅ Commands added!

Entry complete. Tagged as: jenkins, npm, permissions, chown

This entry is now searchable. Next time you see npm permission errors,
I'll suggest this solution!

---

You: @claude show me unresolved issues
Claude: Unresolved Issues (2):

1. [3 days ago] Proxmox VM console not loading
   Category: proxmox
   Symptoms: Console shows black screen, VNC connection fails
   Status: Investigating

2. [1 week ago] n8n workflow random timeouts
   Category: n8n
   Symptoms: HTTP requests timeout after 30s
   Status: Workaround in place (increased timeout)

Want to update any of these? (1/2/no)
```

**Integration with Knowledge Base:**
```
You: @claude what's the best way to debug Docker permission issues?
Claude: Based on your troubleshooting history and homelab docs:

From your experience (3 past issues):
1. Check group membership (most common solution)
   - Command: groups | grep docker
   - If missing: sudo usermod -aG docker $USER

2. Check file ownership
   - Command: ls -la /var/lib/docker/volumes
   - Fix: sudo chown -R $USER:$USER <path>

3. Restart Docker daemon (rare but works)
   - Command: sudo systemctl restart docker

From homelab docs:
- DOCKER-TROUBLESHOOTING.md has detailed guide
- Similar issue in PVE-EXPORTER-TROUBLESHOOTING.md

Success rate: 100% (3/3 issues resolved with these approaches)
Average resolution time: 12 minutes

Want the full troubleshooting guide? (yes/no)
```

**Time Estimate:** 2 hours
- 1 hour: MCP tools implementation
- 30 min: Linking and similarity detection
- 30 min: Integration with knowledge base search

---

#### Use Case 4: News Aggregator

**Purpose:** Intelligent RSS feed aggregator with AI summarization and filtering

**Features:**
- Subscribe to RSS/Atom feeds with custom categories
- Keyword-based filtering
- AI-powered article summarization
- Semantic search across all articles
- Daily/weekly digest delivery
- Read later queue
- Proactive alerts for critical topics

**New MCP Tools:**
```javascript
subscribe_feed(url, category, keywords, fetch_frequency)
  // Subscribe to RSS feed with filters

unsubscribe_feed(feed_id)
  // Remove feed subscription

get_subscriptions()
  // List all subscribed feeds

fetch_new_articles(feed_id)
  // Manually trigger feed fetch

get_news_digest(timeframe, category, keywords)
  // Get curated news digest

search_news(query, date_range, source)
  // Semantic search across all articles

save_article(article_id)
  // Add article to read later queue

get_saved_articles(read_status)
  // Retrieve saved articles

mark_article_read(article_id)
  // Mark article as read
```

**Feed Subscription Format:**
```yaml
id: feed-arstechnica-security-001
title: Ars Technica Security
url: https://arstechnica.com/security/feed/
category: tech-news/security
keywords: [vulnerability, malware, breach, CVE, exploit]
fetch_frequency: 7200  # 2 hours in seconds
last_fetched: 2026-01-19T10:00:00Z
active: true
```

**SQLite Schema Additions:**
```sql
CREATE TABLE rss_feeds (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  url TEXT UNIQUE NOT NULL,
  category TEXT,
  fetch_frequency INTEGER DEFAULT 7200,
  last_fetched DATETIME,
  active BOOLEAN DEFAULT TRUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE feed_keywords (
  feed_id TEXT,
  keyword TEXT,
  match_type TEXT DEFAULT 'any',  -- 'any', 'all', 'exclude'
  FOREIGN KEY (feed_id) REFERENCES rss_feeds(id)
);

CREATE TABLE articles (
  id TEXT PRIMARY KEY,
  feed_id TEXT,
  title TEXT NOT NULL,
  url TEXT UNIQUE NOT NULL,
  content TEXT,
  summary TEXT,  -- AI-generated summary
  published_date DATETIME,
  fetched_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  keywords_matched TEXT,  -- JSON array of matched keywords
  relevance_score REAL,  -- AI-scored 0.0-1.0
  FOREIGN KEY (feed_id) REFERENCES rss_feeds(id)
);

CREATE TABLE article_tags (
  article_id TEXT,
  tag TEXT,
  auto_generated BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (article_id) REFERENCES articles(id)
);

CREATE TABLE saved_articles (
  article_id TEXT PRIMARY KEY,
  saved_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  read BOOLEAN DEFAULT FALSE,
  read_at DATETIME,
  notes TEXT,
  FOREIGN KEY (article_id) REFERENCES articles(id)
);

CREATE INDEX idx_articles_published ON articles(published_date);
CREATE INDEX idx_articles_feed ON articles(feed_id);
CREATE INDEX idx_articles_relevance ON articles(relevance_score);
CREATE INDEX idx_saved_read ON saved_articles(read);
```

**Conversational Flow:**
```
You: @claude subscribe to Ars Technica security feed
Claude: 🔍 Searching for Ars Technica security feed...

Found: Ars Technica - Security
URL: https://arstechnica.com/security/feed/

✅ Subscribed!
Category: tech-news/security
Fetch frequency: Every 2 hours
Articles matching keywords only: No

Add keyword filters? (yes/no)

You: yes - vulnerability, malware, breach, CVE
Claude: ✅ Keyword filters added: [vulnerability, malware, breach, CVE]

Only articles mentioning these keywords will be saved.
Match type: any (article must contain at least one keyword)

Want to change match type to 'all'? (yes/no)

You: no
Claude: Perfect! Feed configured.

Fetching initial articles...
Found 15 articles from last 7 days
5 articles match your keywords
Generating summaries...

Latest matching article:
"Critical vulnerability in OpenSSL 3.0-3.2"
Published: 2 hours ago
Matched: vulnerability, CVE

Read now? (yes/no/digest)

---

You: @claude news digest
Claude: 📰 Your News Digest (Last 24 hours)

🔒 Security News (5 articles):
1. [Ars Technica] Critical vulnerability in OpenSSL 3.0-3.2
   Summary: New CVE-2026-9999 affects OpenSSL versions 3.0 through 3.2.
   Remote attackers can trigger heap overflow leading to RCE.
   Patch available, all users should upgrade immediately.

   Keywords: vulnerability, CVE
   Relevance: 95%
   📌 High priority!

   Actions: Read / Save / Dismiss / Check homelab impact

2. [Krebs] Malware campaign targets Docker containers
   Summary: Security researchers discovered new malware specifically
   targeting exposed Docker APIs. 2000+ hosts compromised.

   Keywords: malware, docker
   Relevance: 88%

   ⚠️ Related to your homelab: You use Docker
   Actions: Read / Save / Check exposure

[... 3 more articles ...]

🏠 Homelab News (2 articles):
1. [Proxmox] Proxmox VE 9.0 released
2. [UniFi] Dream Machine Pro Max announced

📚 Learning (1 article):
1. [CompTIA] Security+ exam updates for 2026

Total new articles: 8
High priority: 2
Read: 0 / 8

What would you like to do? (read all / save all / filter / next)

---

You: check homelab impact for article 1
Claude: 🔍 Analyzing OpenSSL vulnerability impact on your homelab...

Checking your infrastructure:
- Querying Proxmox hosts (pve01, pve02)
- Checking Docker containers
- Reviewing installed packages

Results:
✅ pve01: OpenSSL 3.1.4 (AFFECTED - patch needed)
✅ pve02: OpenSSL 3.1.4 (AFFECTED - patch needed)
⚠️ Docker containers: 3 containers using affected base images

Action items created:
- [ ] Update OpenSSL on pve01 (apt update && apt upgrade openssl)
- [ ] Update OpenSSL on pve02
- [ ] Rebuild Docker containers: caddy, n8n, qdrant

Urgency: High (CVE has public exploit)
Estimated effort: 30 minutes

Start remediation? (yes/no/schedule)

---

You: @claude search news about Kubernetes security from last month
Claude: Found 12 articles about Kubernetes security (last 30 days):

📊 By source:
- CNCF Blog: 3 articles
- BleepingComputer: 2 articles
- The Hacker News: 2 articles
- Ars Technica: 5 articles

Recent highlights:

1. [CNCF Blog] Kubernetes 1.30 security improvements
   Published: Jan 17, 2026
   Summary: Major release includes enhanced pod security standards,
   improved RBAC audit logging, and native secret encryption at rest.

   Relevance: 92%
   Saved: Yes (you saved this on Jan 17)

2. [BleepingComputer] K8s pod escape vulnerability CVE-2026-8888
   Published: Jan 15, 2026
   Summary: Critical vulnerability allows container escape in clusters
   using default seccomp profiles. Affects K8s 1.26-1.29.

   Relevance: 95%
   Read: No

   ⚠️ Matches your troubleshooting history: container security

[... more results ...]

Filter by: date / relevance / source / read status

---

You: @claude save article 2 for later
Claude: ✅ Saved "K8s pod escape vulnerability CVE-2026-8888"

Added to your read later queue (5 articles)

Read later queue:
1. K8s pod escape vulnerability (just added)
2. Docker security best practices (saved 3 days ago)
3. Proxmox backup strategies (saved 1 week ago)
4. Security+ study guide chapter 4 (saved 2 weeks ago)
5. Terraform state management (saved 1 month ago)

Oldest unread article is 1 month old. Want to review? (yes/no)
```

**Background Processing (n8n workflow):**
```
Every 2 hours:
1. Fetch all active RSS feeds
2. Parse new articles
3. Filter by keywords (if configured)
4. Generate AI summaries using Claude
5. Extract tags and relevance scores
6. Store in database
7. Send notifications for high-priority articles

Daily at 8 AM:
1. Generate digest of last 24 hours
2. Send to Slack/Telegram
3. Include high-priority alerts
4. Suggest related troubleshooting entries
```

**Smart Features:**

**Auto-linking to knowledge base:**
```
New article: "Proxmox backup corruption bug in PBS 3.1"

Auto-actions:
✓ Tagged: proxmox, backup, bug
✓ Linked to homelab docs: PBS-SETUP.md
✓ Linked to troubleshooting: ts-pbs-backup-001
✓ Cross-referenced with todo: "Review PBS backup status"

Suggested action: Check PBS version on your backup server
```

**Proactive security alerts:**
```
Claude: 🚨 SECURITY ALERT

Critical article matches your infrastructure:

"Zero-day exploit for UniFi Dream Machines being actively exploited"
Published: 15 minutes ago
Source: Krebs on Security

Summary: Active exploit targeting UniFi OS 3.x allows remote code
execution. Proof-of-concept published on GitHub. 5000+ devices
already compromised.

Your devices potentially affected:
- UniFi Dream Machine (10.10.10.1) running UniFi OS 3.2.7

IMMEDIATE ACTIONS NEEDED:
1. [ ] Check UniFi OS version
2. [ ] Enable firewall rules blocking external access
3. [ ] Review security logs for suspicious activity
4. [ ] Monitor for UniFi security updates

Urgency: CRITICAL
Time to patch: Unknown (vendor notified)

Want detailed remediation steps? (yes/no)
Want to create incident response ticket? (yes/no)
```

**Trending topics:**
```
You: @claude what are trending topics this week?
Claude: 📈 Trending Topics (Last 7 days)

Based on your 35 subscribed feeds:

1. OpenSSL Vulnerability CVE-2026-9999 (18 articles)
   ⚠️ Affects your homelab
   Status: Patch available

2. Docker Security Best Practices (12 articles)
   Related to your interests: docker, security

3. Kubernetes 1.30 Release (10 articles)

4. Proxmox VE 9.0 Features (8 articles)

5. Security+ Exam Changes 2026 (6 articles)
   ✨ Relevant to your learning goals

Click any topic for full article list.
```

**Time Estimate:** 2 hours
- 45 min: RSS parsing and feed management
- 45 min: AI summarization integration
- 30 min: Digest generation and alerting

---

### Phase 8 Summary

**Total Time:** 7.5 hours
**New MCP Tools:** 27 tools across 4 use cases
**Database Tables:** 14 new tables
**Value:** Very High - practical daily use for learning, coding, troubleshooting, and staying informed

**Implementation Order:**
1. Code Snippets (easiest, immediate value) - 1.5 hours
2. Troubleshooting Journal (builds on snippets) - 2 hours
3. News Aggregator (moderate complexity) - 2 hours
4. Security+ Quiz (most complex, requires question bank) - 2 hours

---

## Future Enhancements (Post-MVP)

**Phase 8: Advanced Features**
- [ ] Web UI for knowledge base management
- [ ] Grafana dashboard for memory stats
- [ ] Slack slash commands (/claude search, /claude todo)
- [ ] Voice interface (whisper → Claude)
- [ ] Integration with Obsidian for note sync
- [ ] Multi-user support (separate knowledge bases)
- [ ] RAG (Retrieval Augmented Generation) optimization
- [ ] Automatic tagging and categorization
- [ ] Smart reminders (context-aware)
- [ ] Export knowledge base to PDF/markdown

**Phase 9: Performance Optimization**
- [ ] Local embeddings (no OpenAI API calls)
- [ ] Qdrant query optimization
- [ ] Caching layer for frequent searches
- [ ] Background document processing
- [ ] Rate limiting for API calls

**Phase 10: Security Hardening**
- [ ] MCP server authentication
- [ ] Encrypted SQLite database
- [ ] API key rotation automation
- [ ] Audit logging for all operations
- [ ] Role-based access control

---

## References

### Technology Documentation
- [Terraform Proxmox Provider](https://registry.terraform.io/providers/bpg/proxmox/latest/docs)
- [Ansible Documentation](https://docs.ansible.com/)
- [Qdrant Documentation](https://qdrant.tech/documentation/)
- [MCP Protocol Spec](https://modelcontextprotocol.io/)
- [OpenAI Embeddings API](https://platform.openai.com/docs/guides/embeddings)
- [n8n Documentation](https://docs.n8n.io/)

### Homelab Documentation
- [AI Hub v1 Setup](../homelab-migration/ai-hub-setup.md)
- [Apprise Telegram Setup](../core-services/APPRISE-TELEGRAM-SETUP.md)
- [Core Services Deployment](../core-services/README.md)

### Session Notes
- Session Date: 2026-01-19
- Duration: ~3 hours planning + 1 hour initial build
- Phase 1 completed: Foundation and Terraform/Ansible skeleton

---

**Document Version:** 1.0
**Last Updated:** 2026-01-19
**Next Review:** After Phase 2 completion
