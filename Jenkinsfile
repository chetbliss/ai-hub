pipeline {
    agent any

    environment {
        // AI Hub deployment settings based on branch
        AI_HUB_INVENTORY = "${env.BRANCH_NAME == 'main' ? 'prod.yml' : (env.BRANCH_NAME == 'test' ? 'test.yml' : 'dev.yml')}"
        AI_HUB_TARGET = "${env.BRANCH_NAME == 'main' ? '10.10.10.50 (ai-hub PROD)' : (env.BRANCH_NAME == 'test' ? '10.10.10.55 (ai-hub-test TEST)' : '10.10.10.51 (ai-hub-dev DEV)')}"
        AI_HUB_ENV = "${env.BRANCH_NAME == 'main' ? 'production' : (env.BRANCH_NAME == 'test' ? 'test' : 'development')}"

        // Terraform credentials (injected as TF_VAR_ environment variables)
        TF_VAR_proxmox_api_token = credentials('proxmox-api-token')
    }

    stages {
        stage('Initialize') {
            steps {
                script {
                    echo "=========================================="
                    echo "AI Hub Deployment Pipeline"
                    echo "Branch: ${env.BRANCH_NAME}"
                    echo "Target: ${env.AI_HUB_TARGET}"
                    echo "Environment: ${env.AI_HUB_ENV}"
                    echo "Inventory: ansible/inventory/${env.AI_HUB_INVENTORY}"
                    echo "Method: Terraform + Ansible"
                    echo "=========================================="
                }
            }
        }

        stage('Provision VM with Terraform') {
            steps {
                script {
                    echo "Checking if AI Hub VM needs provisioning..."

                    def targetHost = env.AI_HUB_INVENTORY == 'prod.yml' ? '10.10.10.50' : (env.AI_HUB_INVENTORY == 'test.yml' ? '10.10.10.55' : '10.10.10.51')
                    def tfvarFile = env.AI_HUB_INVENTORY == 'prod.yml' ? 'prod.tfvars' : (env.AI_HUB_INVENTORY == 'test.yml' ? 'test.tfvars' : 'dev.tfvars')

                    // Check if VM is reachable
                    def vmExists = sh(
                        script: "ping -c 2 -W 2 ${targetHost} > /dev/null 2>&1",
                        returnStatus: true
                    ) == 0

                    if (vmExists) {
                        echo "VM ${targetHost} is already running, skipping Terraform provisioning"
                    } else {
                        echo "VM ${targetHost} not found, provisioning with Terraform..."

                        sh """
                            cd terraform

                            # Initialize Terraform
                            terraform init

                            # Apply (credentials already injected as TF_VAR_ environment variables)
                            terraform apply -auto-approve -var-file=environments/${tfvarFile}

                            # Wait for VM to boot and be SSH-ready
                            echo "Waiting for VM to be SSH-ready..."
                            for i in {1..30}; do
                                if ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=5 cbliss@${targetHost} 'echo VM ready' 2>/dev/null; then
                                    echo "VM is ready!"
                                    break
                                fi
                                echo "Attempt \$i/30: VM not ready yet, waiting 10 seconds..."
                                sleep 10
                            done
                        """
                    }
                }
            }
        }

        stage('Deploy with Ansible') {
            steps {
                script {
                    echo "Deploying AI Hub using Ansible..."

                    withCredentials([
                        string(credentialsId: 'anthropic-api-key', variable: 'ANTHROPIC_API_KEY'),
                        string(credentialsId: 'gemini-api-key', variable: 'GEMINI_API_KEY'),
                        string(credentialsId: 'openai-api-key', variable: 'OPENAI_API_KEY'),
                        string(credentialsId: 'proxmox-api-token', variable: 'PROXMOX_API_TOKEN'),
                        string(credentialsId: 'unifi-controller-username', variable: 'UNIFI_USERNAME'),
                        string(credentialsId: 'unifi-controller-password', variable: 'UNIFI_PASSWORD'),
                        string(credentialsId: 'telegram-bot-token', variable: 'TELEGRAM_BOT_TOKEN'),
                        string(credentialsId: 'ai-hub-ssh-password', variable: 'AI_HUB_SSH_PASSWORD'),
                        usernamePassword(credentialsId: 'github-token-chetbliss', usernameVariable: 'GITHUB_USERNAME', passwordVariable: 'GITHUB_TOKEN')
                    ]) {
                        sh """
                            cd ansible

                            # Install Ansible Galaxy requirements
                            ansible-galaxy install -r requirements.yml

                            # Extract Proxmox token value (secret part after =)
                            export PROXMOX_TOKEN_VALUE=\$(echo "${PROXMOX_API_TOKEN}" | cut -d'=' -f2)

                            # Run Ansible playbook with credentials injected as environment variables
                            export ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY}"
                            export GEMINI_API_KEY="${GEMINI_API_KEY}"
                            export OPENAI_API_KEY="${OPENAI_API_KEY}"
                            export UNIFI_USERNAME="${UNIFI_USERNAME}"
                            export UNIFI_PASSWORD="${UNIFI_PASSWORD}"
                            export GITHUB_USERNAME="${GITHUB_USERNAME}"
                            export GITHUB_TOKEN="${GITHUB_TOKEN}"
                            export TELEGRAM_BOT_TOKEN="${TELEGRAM_BOT_TOKEN}"
                            export AI_HUB_SSH_PASSWORD="${AI_HUB_SSH_PASSWORD}"

                            # Use Jenkins SSH key for Ansible
                            ansible-playbook -i inventory/${env.AI_HUB_INVENTORY} \
                                --private-key /var/lib/jenkins/.ssh/id_rsa \
                                playbooks/site.yml
                        """
                    }
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    echo "Verifying AI Hub deployment..."

                    def targetHost = env.AI_HUB_INVENTORY == 'prod.yml' ? '10.10.10.50' : (env.AI_HUB_INVENTORY == 'test.yml' ? '10.10.10.55' : '10.10.10.51')

                    sh """
                        # Check Qdrant
                        echo "Checking Qdrant..."
                        ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null cbliss@${targetHost} 'curl -s http://localhost:6333/health' || echo "WARNING: Qdrant not responding"

                        # Check n8n
                        echo "Checking n8n..."
                        ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null cbliss@${targetHost} 'curl -s http://localhost:5678' || echo "WARNING: n8n not responding"

                        # Check MCP Memory server
                        echo "Checking MCP Memory server..."
                        ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null cbliss@${targetHost} 'pm2 list' || echo "WARNING: PM2 not running"

                        # Check SQLite database
                        echo "Checking SQLite database..."
                        ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null cbliss@${targetHost} 'test -f /opt/ai-hub/data/memory.db && echo "Database exists" || echo "WARNING: Database not found"'

                        # Check Claude Code Web UI
                        echo "Checking Claude Code Web UI..."
                        ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null cbliss@${targetHost} 'curl -s http://localhost:8081/ | head -1' || echo "WARNING: Claude Code Web UI not responding"
                    """
                }
            }
        }
    }

    post {
        success {
            script {
                echo "=========================================="
                echo "✓ AI Hub Deployment Successful!"
                echo "Branch: ${env.BRANCH_NAME}"
                echo "Target: ${env.AI_HUB_TARGET}"
                echo "Environment: ${env.AI_HUB_ENV}"
                echo ""
                echo "Services deployed:"
                echo "  - Claude CLI"
                echo "  - Claude Code Web UI (port 8081)"
                echo "  - Gemini CLI"
                echo "  - Qdrant (vector database)"
                echo "  - SQLite (memory database)"
                echo "  - n8n (workflow automation)"
                echo "  - Telegram Claude Bot workflow"
                echo "  - MCP Memory Server"
                echo "  - MCP Proxmox Server"
                echo "  - MCP UniFi Server"
                echo "  - Document ingestion (ChetTV-Lab)"
                echo "=========================================="
            }
        }

        failure {
            script {
                echo "=========================================="
                echo "✗ AI Hub Deployment Failed"
                echo "Branch: ${env.BRANCH_NAME}"
                echo "Target: ${env.AI_HUB_TARGET}"
                echo "Check the logs above for error details"
                echo "=========================================="
            }
        }
    }
}
