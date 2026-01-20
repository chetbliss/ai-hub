-- Security+ SY0-701 Starter Questions
-- 50 questions across 5 domains for quiz practice

-- ===========================================================================
-- Domain 1: General Security Concepts (10 questions)
-- ===========================================================================

INSERT INTO quiz_questions (domain, subdomain, question, option_a, option_b, option_c, option_d, correct_answer, explanation, difficulty) VALUES
('General Security Concepts', 'CIA Triad', 'Which security principle ensures that data is accessible when needed by authorized users?', 'Confidentiality', 'Integrity', 'Availability', 'Non-repudiation', 'C', 'Availability ensures that information and resources are accessible to authorized users when needed. Confidentiality protects against unauthorized disclosure, and integrity ensures data accuracy.', 'easy'),

('General Security Concepts', 'CIA Triad', 'A hash function is primarily used to ensure which aspect of the CIA triad?', 'Confidentiality', 'Integrity', 'Availability', 'Authentication', 'B', 'Hash functions create a unique fingerprint of data. If the data changes, the hash changes, making them ideal for verifying data integrity.', 'medium'),

('General Security Concepts', 'Authentication', 'Which of the following is an example of multi-factor authentication?', 'Username and password', 'Password and security question', 'Smart card and PIN', 'Two different passwords', 'C', 'MFA requires two or more different types of factors. A smart card (something you have) and PIN (something you know) are two different factor types. Two passwords are the same factor type.', 'easy'),

('General Security Concepts', 'AAA', 'Which AAA component determines what resources a user can access?', 'Authentication', 'Authorization', 'Accounting', 'Auditing', 'B', 'Authorization determines what resources an authenticated user can access. Authentication verifies identity, and accounting tracks resource usage.', 'easy'),

('General Security Concepts', 'Security Controls', 'A firewall is an example of which type of security control?', 'Administrative', 'Technical', 'Physical', 'Managerial', 'B', 'Firewalls are technical (logical) controls that use technology to protect systems. Physical controls protect facilities, and administrative controls are policies and procedures.', 'easy'),

('General Security Concepts', 'Security Controls', 'Which control type is designed to discourage a security violation before it occurs?', 'Detective', 'Preventive', 'Corrective', 'Deterrent', 'D', 'Deterrent controls discourage violations (e.g., warning signs, cameras). Preventive controls block violations, detective controls identify them, and corrective controls fix issues.', 'medium'),

('General Security Concepts', 'Zero Trust', 'What is the core principle of Zero Trust security?', 'Trust but verify', 'Never trust, always verify', 'Trust internal networks', 'Verify once at the perimeter', 'B', 'Zero Trust operates on "never trust, always verify" - assuming breach and verifying every access request regardless of location or previous authentication.', 'medium'),

('General Security Concepts', 'Defense in Depth', 'Which strategy implements multiple layers of security controls?', 'Single sign-on', 'Defense in depth', 'Least privilege', 'Separation of duties', 'B', 'Defense in depth uses multiple layers of security controls so that if one fails, others still provide protection. This creates redundancy in security.', 'easy'),

('General Security Concepts', 'Non-repudiation', 'Which technology provides non-repudiation for email messages?', 'Encryption', 'Digital signatures', 'Hashing', 'Access control lists', 'B', 'Digital signatures provide non-repudiation by proving the sender''s identity and that they sent the message. The sender cannot deny sending a digitally signed message.', 'medium'),

('General Security Concepts', 'Gap Analysis', 'What is the purpose of a gap analysis in security?', 'Identify vulnerabilities in applications', 'Compare current state to desired state', 'Test incident response procedures', 'Measure network performance', 'B', 'Gap analysis compares the current security posture with desired or required standards to identify what needs to be implemented or improved.', 'medium'),

-- ===========================================================================
-- Domain 2: Threats, Vulnerabilities & Mitigations (15 questions)
-- ===========================================================================

('Threats, Vulnerabilities & Mitigations', 'Social Engineering', 'An attacker calls an employee pretending to be from IT support and asks for their password. This is an example of which attack?', 'Phishing', 'Vishing', 'Smishing', 'Whaling', 'B', 'Vishing (voice phishing) uses phone calls to trick victims. Phishing uses email, smishing uses SMS, and whaling targets executives.', 'easy'),

('Threats, Vulnerabilities & Mitigations', 'Social Engineering', 'An attacker follows an authorized person through a secure door without using credentials. What is this called?', 'Tailgating', 'Shoulder surfing', 'Dumpster diving', 'Pretexting', 'A', 'Tailgating (or piggybacking) is when an unauthorized person follows an authorized person through a secure entry point without proper authentication.', 'easy'),

('Threats, Vulnerabilities & Mitigations', 'Malware', 'Which type of malware appears legitimate but contains malicious code?', 'Virus', 'Worm', 'Trojan', 'Rootkit', 'C', 'Trojans disguise themselves as legitimate software but contain malicious code. Viruses attach to files, worms self-replicate, and rootkits hide at the OS level.', 'easy'),

('Threats, Vulnerabilities & Mitigations', 'Malware', 'Which malware type can self-replicate without human interaction?', 'Virus', 'Worm', 'Trojan', 'Spyware', 'B', 'Worms can self-replicate and spread across networks without human interaction. Viruses require human action to spread (e.g., opening a file).', 'easy'),

('Threats, Vulnerabilities & Mitigations', 'Application Attacks', 'An attacker sends malicious SQL code through a web form to manipulate a database. This is which type of attack?', 'XSS', 'CSRF', 'SQL injection', 'Buffer overflow', 'C', 'SQL injection attacks insert malicious SQL code through input fields to manipulate or extract data from databases.', 'easy'),

('Threats, Vulnerabilities & Mitigations', 'Application Attacks', 'Which attack involves injecting malicious scripts into web pages viewed by other users?', 'SQL injection', 'Cross-site scripting (XSS)', 'LDAP injection', 'XML injection', 'B', 'XSS attacks inject malicious scripts into trusted websites that are then executed in other users'' browsers, potentially stealing cookies or session tokens.', 'medium'),

('Threats, Vulnerabilities & Mitigations', 'Network Attacks', 'An attacker intercepts communication between two parties without their knowledge. This is which type of attack?', 'DoS', 'Man-in-the-middle', 'Replay attack', 'Session hijacking', 'B', 'Man-in-the-middle (MITM) attacks intercept communications between two parties, allowing the attacker to eavesdrop or modify traffic.', 'easy'),

('Threats, Vulnerabilities & Mitigations', 'Network Attacks', 'Which attack floods a target with traffic to make services unavailable?', 'Man-in-the-middle', 'DNS poisoning', 'Denial of Service', 'ARP spoofing', 'C', 'Denial of Service (DoS) attacks overwhelm systems with traffic or requests, making services unavailable to legitimate users.', 'easy'),

('Threats, Vulnerabilities & Mitigations', 'Cryptographic Attacks', 'An attacker captures encrypted data and retransmits it later to gain unauthorized access. This is which attack?', 'Brute force', 'Rainbow table', 'Replay attack', 'Birthday attack', 'C', 'Replay attacks capture valid data transmissions (like authentication tokens) and retransmit them later to impersonate the legitimate user.', 'medium'),

('Threats, Vulnerabilities & Mitigations', 'Vulnerabilities', 'Which vulnerability occurs when an application writes data beyond allocated memory?', 'SQL injection', 'Buffer overflow', 'Integer overflow', 'Race condition', 'B', 'Buffer overflows occur when programs write data beyond allocated memory buffers, potentially overwriting adjacent memory and allowing arbitrary code execution.', 'medium'),

('Threats, Vulnerabilities & Mitigations', 'Threat Intelligence', 'Which indicator of compromise (IoC) represents a specific malware signature?', 'IP address', 'File hash', 'Domain name', 'User account', 'B', 'File hashes (MD5, SHA-256) uniquely identify specific files and are commonly used to detect known malware. IP addresses and domains can change, but file hashes remain constant.', 'medium'),

('Threats, Vulnerabilities & Mitigations', 'Vulnerability Management', 'What is the primary purpose of patch management?', 'Improve system performance', 'Add new features', 'Remediate known vulnerabilities', 'Reduce system costs', 'C', 'Patch management primarily aims to remediate known security vulnerabilities by applying vendor-provided updates and fixes.', 'easy'),

('Threats, Vulnerabilities & Mitigations', 'Penetration Testing', 'Which penetration testing methodology provides testers with full knowledge of the target environment?', 'Black box', 'White box', 'Gray box', 'Red team', 'B', 'White box testing provides full knowledge of the system (source code, architecture, credentials). Black box has no knowledge, gray box has partial knowledge.', 'medium'),

('Threats, Vulnerabilities & Mitigations', 'Security Awareness', 'Which is the most effective control against social engineering attacks?', 'Firewalls', 'Antivirus software', 'User training', 'Encryption', 'C', 'User training and security awareness are the most effective defenses against social engineering, as these attacks exploit human psychology rather than technical vulnerabilities.', 'easy'),

('Threats, Vulnerabilities & Mitigations', 'Threat Actors', 'Which threat actor is primarily motivated by financial gain?', 'Hacktivist', 'Nation-state', 'Organized crime', 'Script kiddie', 'C', 'Organized crime groups are primarily motivated by financial gain through activities like ransomware, fraud, and data theft. Hacktivists are motivated by ideology.', 'medium'),

-- ===========================================================================
-- Domain 3: Security Architecture (10 questions)
-- ===========================================================================

('Security Architecture', 'Network Security', 'Which device filters traffic based on IP addresses, ports, and protocols?', 'Router', 'Firewall', 'Switch', 'Hub', 'B', 'Firewalls filter traffic based on rules that typically include source/destination IP addresses, ports, and protocols. Routers forward packets, switches connect devices.', 'easy'),

('Security Architecture', 'Network Security', 'What is the primary purpose of network segmentation?', 'Increase bandwidth', 'Reduce attack surface', 'Improve routing', 'Decrease latency', 'B', 'Network segmentation divides networks into smaller segments to limit lateral movement, contain breaches, and reduce the overall attack surface.', 'medium'),

('Security Architecture', 'Secure Protocols', 'Which protocol provides secure remote access to network devices?', 'Telnet', 'SSH', 'FTP', 'SMTP', 'B', 'SSH (Secure Shell) provides encrypted remote access to network devices. Telnet transmits credentials in cleartext and is insecure.', 'easy'),

('Security Architecture', 'VPN', 'Which VPN protocol operates at Layer 2 of the OSI model?', 'IPSec', 'SSL/TLS', 'L2TP', 'PPTP', 'C', 'L2TP (Layer 2 Tunneling Protocol) operates at the Data Link layer. IPSec operates at Layer 3 (Network layer).', 'hard'),

('Security Architecture', 'Cloud Security', 'In which cloud service model is the customer responsible for application security but not OS security?', 'IaaS', 'PaaS', 'SaaS', 'DaaS', 'B', 'In PaaS (Platform as a Service), the provider manages the OS and infrastructure, while the customer manages applications and data. In IaaS, customers manage OS and up.', 'medium'),

('Security Architecture', 'Wireless Security', 'Which wireless security protocol is considered the most secure?', 'WEP', 'WPA', 'WPA2', 'WPA3', 'D', 'WPA3 is the newest and most secure wireless protocol, addressing vulnerabilities in WPA2. WEP is deprecated and easily cracked.', 'easy'),

('Security Architecture', 'Access Control', 'Which access control model uses labels to determine access?', 'DAC', 'MAC', 'RBAC', 'ABAC', 'B', 'MAC (Mandatory Access Control) uses security labels/classifications to determine access. DAC is owner-based, RBAC is role-based, ABAC is attribute-based.', 'medium'),

('Security Architecture', 'Cryptography', 'Which symmetric encryption algorithm is the current U.S. government standard?', 'DES', '3DES', 'AES', 'RC4', 'C', 'AES (Advanced Encryption Standard) is the current U.S. government standard. DES and 3DES are deprecated, RC4 has known vulnerabilities.', 'easy'),

('Security Architecture', 'PKI', 'What is the primary purpose of a Certificate Revocation List (CRL)?', 'Issue new certificates', 'List valid certificates', 'List invalid certificates before expiration', 'Encrypt certificate data', 'C', 'CRLs list certificates that have been revoked before their expiration date due to compromise, change in status, or other reasons.', 'medium'),

('Security Architecture', 'Data Protection', 'Which technique replaces sensitive data with non-sensitive substitutes?', 'Encryption', 'Hashing', 'Tokenization', 'Masking', 'C', 'Tokenization replaces sensitive data with random tokens that have no mathematical relationship to the original data. The mapping is stored securely elsewhere.', 'medium'),

-- ===========================================================================
-- Domain 4: Security Operations (10 questions)
-- ===========================================================================

('Security Operations', 'Incident Response', 'What is the first phase of the incident response process?', 'Containment', 'Preparation', 'Detection', 'Recovery', 'B', 'The incident response process begins with Preparation (policies, training, tools). The typical order is: Preparation, Detection, Analysis, Containment, Eradication, Recovery, Lessons Learned.', 'medium'),

('Security Operations', 'Incident Response', 'During which phase do you remove the threat from the environment?', 'Containment', 'Eradication', 'Recovery', 'Lessons learned', 'B', 'Eradication removes the threat from the environment (deleting malware, closing unauthorized accounts). Containment limits spread, Recovery restores operations.', 'medium'),

('Security Operations', 'Monitoring', 'Which tool aggregates and correlates log data from multiple sources?', 'Firewall', 'IDS', 'SIEM', 'Antivirus', 'C', 'SIEM (Security Information and Event Management) systems aggregate, correlate, and analyze log data from multiple sources to identify security events.', 'easy'),

('Security Operations', 'Monitoring', 'What is the difference between IDS and IPS?', 'IDS prevents attacks, IPS detects them', 'IDS detects attacks, IPS prevents them', 'IDS is hardware, IPS is software', 'There is no difference', 'B', 'IDS (Intrusion Detection System) detects and alerts on suspicious activity. IPS (Intrusion Prevention System) can actively block or prevent attacks.', 'easy'),

('Security Operations', 'Digital Forensics', 'What is the correct order for volatility in digital forensics?', 'Hard drive, RAM, network traffic', 'Network traffic, RAM, hard drive', 'RAM, hard drive, network traffic', 'Hard drive, network traffic, RAM', 'B', 'The order of volatility (most to least volatile) is: registers/cache, RAM, network traffic, running processes, hard drive, backups. Collect most volatile data first.', 'hard'),

('Security Operations', 'Disaster Recovery', 'Which backup type only backs up data that changed since the last full backup?', 'Incremental', 'Differential', 'Full', 'Snapshot', 'B', 'Differential backups include all changes since the last full backup. Incremental backups only include changes since the last backup (full or incremental).', 'medium'),

('Security Operations', 'Business Continuity', 'Which metric defines the maximum acceptable outage time?', 'RTO', 'RPO', 'MTTR', 'MTBF', 'A', 'RTO (Recovery Time Objective) is the maximum acceptable time to restore services. RPO (Recovery Point Objective) is the maximum acceptable data loss.', 'medium'),

('Security Operations', 'Vulnerability Scanning', 'Which scan type tests for vulnerabilities without exploiting them?', 'Passive scan', 'Active scan', 'Credentialed scan', 'Non-credentialed scan', 'A', 'Passive scans detect vulnerabilities without actively probing or exploiting them (e.g., by analyzing network traffic). Active scans send probes that might disrupt systems.', 'hard'),

('Security Operations', 'Hardening', 'Which hardening technique reduces the attack surface by removing unnecessary software?', 'Patching', 'Disabling services', 'Encryption', 'Access control', 'B', 'Disabling or removing unnecessary services and software reduces the attack surface by eliminating potential vulnerabilities and entry points.', 'easy'),

('Security Operations', 'Security Automation', 'What is the primary benefit of SOAR platforms?', 'Replace security analysts', 'Automate incident response', 'Perform vulnerability scans', 'Encrypt network traffic', 'B', 'SOAR (Security Orchestration, Automation, and Response) platforms automate incident response workflows, integrating multiple security tools to respond faster and more consistently.', 'medium'),

-- ===========================================================================
-- Domain 5: Security Program Management & Oversight (5 questions)
-- ===========================================================================

('Security Program Management', 'Governance', 'Which framework provides a risk-based approach to implementing cybersecurity controls?', 'ISO 27001', 'NIST CSF', 'PCI DSS', 'COBIT', 'B', 'NIST Cybersecurity Framework (CSF) provides a risk-based approach with five core functions: Identify, Protect, Detect, Respond, and Recover.', 'medium'),

('Security Program Management', 'Risk Management', 'Which risk management strategy involves purchasing insurance?', 'Risk avoidance', 'Risk mitigation', 'Risk transference', 'Risk acceptance', 'C', 'Risk transference shifts risk to another party (e.g., insurance, outsourcing). Avoidance eliminates risk, mitigation reduces it, acceptance acknowledges it.', 'easy'),

('Security Program Management', 'Risk Management', 'What is the formula for calculating risk?', 'Threat × Vulnerability', 'Threat + Vulnerability', 'Likelihood × Impact', 'Asset Value + Threat', 'C', 'Risk is typically calculated as Likelihood (or probability) × Impact. Some models include asset value: Risk = Asset Value × Threat × Vulnerability.', 'medium'),

('Security Program Management', 'Compliance', 'Which regulation protects personal health information in the United States?', 'GDPR', 'HIPAA', 'PCI DSS', 'SOX', 'B', 'HIPAA (Health Insurance Portability and Accountability Act) protects health information in the U.S. GDPR is European data protection, PCI DSS is payment card security.', 'easy'),

('Security Program Management', 'Policies', 'Which document provides specific step-by-step instructions for completing a task?', 'Policy', 'Standard', 'Procedure', 'Guideline', 'C', 'Procedures provide detailed step-by-step instructions. Policies are high-level statements, standards define specific requirements, guidelines are recommendations.', 'easy');
