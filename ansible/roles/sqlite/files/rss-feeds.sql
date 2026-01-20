-- RSS Feed Starter Data for News Aggregator
-- 13 curated feeds across Security, Homelab, and Technology categories
-- Note: News aggregator tools will be implemented in Phase 3c

-- ===========================================================================
-- Security News Feeds (Critical - Enable alerts)
-- ===========================================================================

INSERT INTO rss_feeds (name, url, category, fetch_interval, is_active) VALUES
('BleepingComputer Security', 'https://www.bleepingcomputer.com/feed/', 'security', 120, 1),
('The Hacker News', 'https://feeds.feedburner.com/TheHackersNews', 'security', 120, 1),
('Krebs on Security', 'https://krebsonsecurity.com/feed/', 'security', 120, 1),
('SANS Internet Storm Center', 'https://isc.sans.edu/rssfeed.xml', 'security', 120, 1),
('Dark Reading', 'https://www.darkreading.com/rss.xml', 'security', 120, 1),
('Threatpost', 'https://threatpost.com/feed/', 'security', 120, 1);

-- ===========================================================================
-- Homelab & Self-Hosted Feeds (Medium priority)
-- ===========================================================================

INSERT INTO rss_feeds (name, url, category, fetch_interval, is_active) VALUES
('r/homelab', 'https://www.reddit.com/r/homelab/.rss', 'homelab', 240, 1),
('r/selfhosted', 'https://www.reddit.com/r/selfhosted/.rss', 'homelab', 240, 1),
('Proxmox Forum - Latest', 'https://forum.proxmox.com/forums/-/index.rss', 'homelab', 360, 1);

-- ===========================================================================
-- Technology News Feeds (Low priority - general interest)
-- ===========================================================================

INSERT INTO rss_feeds (name, url, category, fetch_interval, is_active) VALUES
('Ars Technica', 'https://feeds.arstechnica.com/arstechnica/index', 'technology', 360, 1),
('TechCrunch', 'https://techcrunch.com/feed/', 'technology', 360, 1),
('The Verge', 'https://www.theverge.com/rss/index.xml', 'technology', 360, 1);

-- ===========================================================================
-- Security Keywords (Trigger proactive alerts)
-- ===========================================================================

-- Critical security keywords (immediate alerts)
INSERT INTO feed_keywords (feed_id, keyword, priority, alert_enabled) VALUES
(1, 'CVE', 'critical', 1),
(1, 'zero-day', 'critical', 1),
(1, 'ransomware', 'critical', 1),
(1, 'breach', 'critical', 1),
(2, 'CVE', 'critical', 1),
(2, 'zero-day', 'critical', 1),
(2, 'ransomware', 'critical', 1),
(3, 'CVE', 'critical', 1),
(3, 'zero-day', 'critical', 1),
(4, 'CVE', 'critical', 1),
(4, 'vulnerability', 'critical', 1);

-- High priority keywords (infrastructure-specific)
INSERT INTO feed_keywords (feed_id, keyword, priority, alert_enabled) VALUES
(1, 'proxmox', 'high', 1),
(1, 'docker', 'high', 1),
(1, 'kubernetes', 'high', 1),
(2, 'proxmox', 'high', 1),
(2, 'docker', 'high', 1),
(3, 'proxmox', 'high', 1),
(5, 'proxmox', 'high', 1);

-- Medium priority keywords (cert study)
INSERT INTO feed_keywords (feed_id, keyword, priority, alert_enabled) VALUES
(2, 'CompTIA', 'medium', 0),
(2, 'Security+', 'medium', 0),
(2, 'certification', 'medium', 0);

-- Homelab keywords (informational)
INSERT INTO feed_keywords (feed_id, keyword, priority, alert_enabled) VALUES
(7, 'proxmox', 'medium', 0),
(7, 'docker', 'medium', 0),
(7, 'unifi', 'medium', 0),
(8, 'proxmox', 'medium', 0),
(8, 'docker', 'medium', 0),
(8, 'unifi', 'medium', 0),
(9, 'backup', 'medium', 0),
(9, 'storage', 'medium', 0),
(9, 'networking', 'medium', 0);
