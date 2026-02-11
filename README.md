# 🎬 MediaServer

A complete Docker-based media server stack designed for managing and streaming your digital media library. This project includes integrated *Arr suite applications (Prowlarr, Sonarr, Radarr, Lidarr) along with Jellyfin for media streaming, qBittorrent for downloading, and additional utilities.

## 📋 Table of Contents

- [Overview](#overview)
- [Components](#components)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Service Access](#service-access)
- [Directory Structure](#directory-structure)
- [Environment Configuration](#environment-configuration)
- [Common Commands](#common-commands)
- [Troubleshooting](#troubleshooting)
- [Next Steps](#next-steps)
- [Additional Resources](#additional-resources)

## Overview

This is a **Docker Compose**-based media server that automates content management and delivery. It orchestrates multiple specialized services to handle:
- 🔍 Content Discovery (Prowlarr, Sonarr, Radarr, Lidarr)
- 📺 Media Streaming (Jellyfin)
- 📥 Content Downloading (qBittorrent, FlareSolverr)
- 🏠 Dashboard & Management (Homarr, Portainer)

## Components

### Core Services

| Service | Port | Purpose | Description |
|---------|------|---------|-------------|
| **Prowlarr** | 9696 | Indexer Manager | Centralized indexer and search management |
| **Sonarr** | 8989 | TV Series Manager | Automated TV series collection management |
| **Radarr** | 7878 | Movie Manager | Automated movie collection management |
| **Lidarr** | 8686 | Music Manager | Automated music collection management |
| **Jellyfin** | 8096 | Media Streaming | Your personal Netflix-like media player |
| **qBittorrent** | 8080 | Torrent Client | Lightweight torrent downloading |
| **FlareSolverr** | 8191 | CF Bypass | Cloudflare captcha solver for indexers |
| **Homarr** | 7575 | Dashboard | Unified control dashboard for all services |
| **Portainer** | 9443 | Docker Management | Container & image management UI |

## 📦 Prerequisites

Before you begin, ensure you have:

- **Ubuntu/Debian-based Linux system** (or equivalent)
- **Sudo access** on your system
- **At least 20GB free disk space** for media libraries (recommended 100GB+)
- **Stable internet connection**
- **Minimum 4GB RAM** (8GB or more recommended)
- **Git** installed (optional, for cloning the repository)

## 🚀 Quick Start

### ⚠️ IMPORTANT: Step 1 - Run Requirements Script FIRST

This is the **MANDATORY first step**. The `requirements.sh` script will set up your entire environment:

#### What the script does:
- Updates system packages
- Installs Docker Engine and Docker Compose
- Sets up Docker user permissions
- Creates Portainer for container management
- Creates the media library directory structure (`~/media/Arr/`)

#### How to run:

```bash
# Clone the repository (if you haven't already)
git clone https://github.com/SalahEddine000/MediaServer.git
cd MediaServer

# Make the script executable
chmod +x requirements.sh

# Run the requirements script with sudo
./requirements.sh
```

#### After running the script:

⚠️ **CRITICAL**: You must do ONE of the following:

```bash
# Option 1: Run this command to activate Docker group for current session
newgrp docker

# Option 2: Log out completely and log back in to your user account
# Then proceed to Step 2
```

**Verify Docker installation:**
```bash
docker --version
docker-compose --version
```

**Access Portainer:**
- Open your browser and go to: `https://localhost:9443`
- Set up your admin user on first access

---

### Step 2: Configure Environment Variables

Edit the `.env` file to customize your installation:

```bash
# Open the .env file with your favorite editor
nano .env
```

The default `.env` file contains:

```env
# Media library path - stores all *Arr configs, backups, and downloads
ARRPATH=~/media/Arr/

# User ID and Group ID (typically 1000 for first user)
PUID=1000
GUID=1000

# Timezone - adjust to your location
TZ=Africa/Casablanca
```

**Configuration options:**

| Variable | Default | Description |
|----------|---------|-------------|
| `ARRPATH` | `~/media/Arr/` | Base path for all media library data. Customize if you have a separate disk |
| `PUID` | `1000` | User ID. Find yours with: `id -u` |
| `GUID` | `1000` | Group ID. Find yours with: `id -g` |
| `TZ` | `Africa/Casablanca` | Timezone for log timestamps. Use format: `Continent/City` |

**Find your timezone:**
```bash
# List available timezones
timedatectl list-timezones
```

**Update ARRPATH for custom location:**
```bash
# If you have a separate disk mounted at /mnt/media
ARRPATH=/mnt/media/Arr/

# Make sure the directory exists and is writable
mkdir -p /mnt/media/Arr/
```

---

### Step 3: Start the Docker Services

**IMPORTANT**: Make sure you've completed Steps 1 and 2 first!

```bash
# Navigate to the project directory
cd ~/MediaServer

# Start all services in the background
docker-compose up -d

# Check status of all services
docker-compose ps
```

Expected output (all services should show "Up"):
```
CONTAINER ID   IMAGE                              COMMAND                  STATUS
abc123def      linuxserver/prowlarr:latest        "/init"                  Up 2 minutes
def456ghi      linuxserver/sonarr:latest         "/init"                  Up 2 minutes
ghi789jkl      linuxserver/radarr:latest         "/init"                  Up 2 minutes
jkl012mno      linuxserver/lidarr:latest         "/init"                  Up 2 minutes
mno345pqr      linuxserver/jellyfin:latest       "/jellyfin/jellyfin"     Up 2 minutes
pqr678stu      linuxserver/qbittorrent:latest    "/init"                  Up 2 minutes
stu901vwx      ghcr.io/ajnart/homarr:latest      "node server.js"         Up 2 minutes
vwx234yza      flaresolverr/flaresolverr:latest  "python -m flask"        Up 2 minutes
```

**View real-time logs:**
```bash
# All services
docker-compose logs -f

# Specific service (e.g., sonarr)
docker-compose logs -f sonarr

# Last 100 lines
docker-compose logs --tail=100
```

---

### Step 4: Verify Services Are Running

Test that each service is accessible:

```bash
# Test Jellyfin (media streaming)
curl -I http://localhost:8096

# Test Prowlarr (indexer manager)
curl -I http://localhost:9696

# Test qBittorrent (torrent client)
curl -I http://localhost:8080

# All should return HTTP 200 or redirect responses
```

---

## 🌐 Service Access

Once all services are running, access them using your browser. Replace `localhost` with your server's IP if accessing from another machine.

### Service URLs

**Dashboard & Management:**
- **Homarr Dashboard** → http://localhost:7575 *(Main control panel)*
- **Portainer** → https://localhost:9443 *(Docker container management)*

**Media Organization & Management:**
- **Prowlarr** → http://localhost:9696 *(Indexer management)*
- **Sonarr** → http://localhost:8989 *(TV series management)*
- **Radarr** → http://localhost:7878 *(Movie management)*
- **Lidarr** → http://localhost:8686 *(Music management)*

**Media Consumption & Downloading:**
- **Jellyfin** → http://localhost:8096 *(Media playback)*
- **qBittorrent** → http://localhost:8080 *(Torrent downloads)*
- **FlareSolverr** → http://localhost:8191 *(Behind-the-scenes Cloudflare bypass)*

### Accessing from Another Computer

Replace `localhost` with your server's IP address:

```
http://YOUR_SERVER_IP:PORT

Example:
http://192.168.1.100:8096  (Jellyfin)
http://192.168.1.100:8989  (Sonarr)
```

**Find your server IP:**
```bash
hostname -I
```

---

## 📁 Directory Structure

After running `requirements.sh`, your media library directory is automatically created at `~/media/Arr/` with this structure:

```
~/media/Arr/
│
├── Prowlarr/
│   ├── config/                 # Prowlarr configuration
│   └── backup/                 # Automatic backups
│
├── Sonarr/
│   ├── config/                 # Sonarr configuration
│   ├── backup/                 # Automatic backups
│   └── tvshows/                # Your TV series storage
│
├── Radarr/
│   ├── config/                 # Radarr configuration
│   ├── backup/                 # Automatic backups
│   ├── movies/                 # Your movie storage
│   └── (monitored folders)
│
├── Lidarr/
│   ├── config/                 # Lidarr configuration
│   ├── backup/                 # Automatic backups
│   └── musicfolder/            # Your music storage
│
├── Jellyfin/
│   ├── config/                 # Jellyfin configuration
│   ├── cache/                  # Cache files
│   └── data/                   # Database files
│
├── Homarr/
│   ├── configs/                # Dashboard configuration
│   ├── icons/                  # Custom icons
│   └── data/                   # Dashboard data
│
├── qbittorrent/
│   └── config/                 # qBittorrent configuration
│
└── Downloads/
    ├── completed/              # Completed downloads
    ├── incomplete/             # In-progress downloads
    └── torrents/               # Torrent files
```

**View your directory:**
```bash
ls -lah ~/media/Arr/
```

---

## ⚙️ Environment Configuration

### Detailed .env Configuration

Your `.env` file controls how services run. Here's a complete reference:

```env
# ============================================
# Media Library Path
# ============================================
# This is where ALL your media and configs are stored
# Use absolute path (starting with /) for maximum compatibility
# Or ~ for home directory
ARRPATH=~/media/Arr/

# ============================================
# User Permissions
# ============================================
# These ensure Docker containers have proper file permissions
# Find your values with: id -u and id -g
PUID=1000
GUID=1000

# ============================================
# Timezone
# ============================================
# Used for logging and scheduling
# Format: Continent/City
# List all: timedatectl list-timezones
TZ=Africa/Casablanca
```

### How to Find Your PUID and GUID

```bash
# Get your User ID
id -u

# Get your Group ID  
id -g

# View all info
id
```

### How to Change Timezone

```bash
# List all timezones
timedatectl list-timezones

# Common timezones:
# US Eastern: America/New_York
# US Pacific: America/Los_Angeles
# UK: Europe/London
# Australia: Australia/Sydney
# Asia: Asia/Tokyo
```

Update your `.env`:
```bash
nano .env
# Change TZ line to your timezone
# Save (Ctrl+X, then Y, then Enter)

# Restart services to apply changes
docker-compose down
docker-compose up -d
```

---

## 🛠️ Common Commands

### Managing Services

```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# Restart all services
docker-compose restart

# Restart a specific service
docker-compose restart sonarr

# View service status
docker-compose ps

# View service logs
docker-compose logs -f

# View logs for specific service
docker-compose logs -f radarr

# View last 50 lines of logs
docker-compose logs --tail=50
```

### Updating Services

```bash
# Pull latest images for all services
docker-compose pull

# Start services with new images
docker-compose up -d

# View what changed
docker-compose config
```

### Troubleshooting Commands

```bash
# Check service health
docker-compose ps

# Inspect a specific container
docker inspect CONTAINER_NAME

# View resource usage
docker stats

# Clean up unused images and containers
docker system prune

# Free up space
docker system prune -a
```

### Backup and Recovery

```bash
# Backup your configuration directory
tar -czf ~/mediaserver-backup-$(date +%Y%m%d).tar.gz ~/media/Arr/

# List backups
ls -lah ~/mediaserver-backup-*.tar.gz

# Restore from backup
tar -xzf ~/mediaserver-backup-20240211.tar.gz -C ~/
```

---

## 🔧 Troubleshooting

### Issue: "Docker command not found" after running requirements.sh

```bash
# Solution 1: Activate Docker group for current session
newgrp docker

# Solution 2: Log out and log back in
# Or restart your terminal

# Verify it works
docker --version
```

### Issue: Services show "Exited" status

```bash
# Check logs for the failed service
docker-compose logs SERVICE_NAME

# Example: Check sonarr
docker-compose logs sonarr

# Common causes:
# 1. Wrong ARRPATH in .env
# 2. Permission issues on directories
# 3. Port already in use
# 4. Insufficient disk space
```

### Issue: Cannot access services on http://localhost:PORT

**If on the same machine:**
```bash
# Check if service is running
docker-compose ps

# Check if port is listening
sudo netstat -tuln | grep :8096

# Test connectivity
curl http://localhost:8096
```

**If accessing from another computer:**
```bash
# Use server IP instead of localhost
http://192.168.1.100:8096

# Find your server IP
hostname -I

# Check firewall allows the port
sudo ufw allow 8096
```

### Issue: Permission denied errors on folders

```bash
# Fix permissions
sudo chown -R 1000:1000 ~/media/Arr/
sudo chmod -R 755 ~/media/Arr/

# Verify
ls -l ~/media/Arr/
```

### Issue: "Address already in use" error

A service port is already taken:

```bash
# Find what's using the port (example: port 8096)
sudo lsof -i :8096

# Or with netstat
sudo netstat -tuln | grep :8096

# You can either:
# 1. Stop the conflicting service
# 2. Change port in docker-compose.yml (port mapping: EXTERNAL:INTERNAL)
# 3. Restart Docker daemon
```

### Issue: Out of disk space

```bash
# Check disk usage
df -h

# Find large folders
du -sh ~/media/Arr/*

# Clean Docker unused data
docker system prune -a

# Clean old logs
docker-compose logs --tail=0 > /dev/null
```

### Issue: Out of memory

```bash
# Check memory usage
free -h

# Check container resource usage
docker stats

# Limit service memory in docker-compose.yml
services:
  sonarr:
    deploy:
      resources:
        limits:
          memory: 512M
```

### Issue: Slow performance

```bash
# Check system resources
top
# Press 'q' to exit

# Check disk I/O
iostat -x 1 5

# Monitor container stats
docker stats --no-stream

# Reduce resource usage:
# 1. Disable unnecessary services in docker-compose.yml
# 2. Add resource limits in docker-compose.yml
# 3. Move media to faster disk
# 4. Increase available RAM
```

### Reset/Clean Installation

```bash
# Stop all services
docker-compose down

# Remove all containers and images
docker-compose down -v

# Remove associated images
docker rmi $(docker images -q)

# Clean all Docker data
docker system prune -a

# Start fresh
docker-compose up -d
```

---

## 📝 Next Steps - Initial Configuration

Once all services are running and accessible, follow this configuration sequence:

### 1. **Set Up Jellyfin** (Media Playback)
- Go to http://localhost:8096
- Complete initial setup wizard
- Add your media libraries:
  - Movies → `~/media/Arr/Radarr/movies`
  - TV Shows → `~/media/Arr/Sonarr/tvshows`
  - Music → `~/media/Arr/Lidarr/musicfolder`

### 2. **Configure Prowlarr** (Indexer Manager)
- Go to http://localhost:9696
- Add indexers (torrent sites)
- Configure API key (you'll need this for *Arr apps)

### 3. **Set Up Sonarr** (TV Series Manager)
- Go to http://localhost:8989
- Settings → Download Clients → Add qBittorrent
  - Host: `qbittorrent`
  - Port: `8080`
- Settings → Indexers → Add Prowlarr
  - Use API key from Prowlarr
- Create monitored folders for TV series

### 4. **Set Up Radarr** (Movie Manager)
- Go to http://localhost:7878
- Settings → Download Clients → Add qBittorrent
  - Host: `qbittorrent`
  - Port: `8080`
- Settings → Indexers → Add Prowlarr
  - Use API key from Prowlarr
- Create monitored folders for movies

### 5. **Set Up Lidarr** (Music Manager)
- Go to http://localhost:8686
- Settings → Download Clients → Add qBittorrent
  - Host: `qbittorrent`
  - Port: `8080`
- Settings → Indexers → Add Prowlarr
  - Use API key from Prowlarr
- Create monitored folders for music

### 6. **Configure qBittorrent** (Torrent Client)
- Go to http://localhost:8080
- Settings → Downloads → Set default paths:
  - Default Save Path: `~/media/Arr/Downloads`
  - Incomplete downloads: `~/media/Arr/Downloads/incomplete`

### 7. **Customize Homarr** (Dashboard)
- Go to http://localhost:7575
- Add widgets for each service
- Customize layout and appearance
- Set up quick links to frequently used services

### 8. **Monitor Portainer** (Docker Management)
- Go to https://localhost:9443
- Review container stats and logs
- Set up alerts for issues

---

## 📚 Additional Resources

### Official Documentation
- [Jellyfin](https://docs.jellyfin.org/)
- [Prowlarr](https://prowlarr.com/)
- [Sonarr Wiki](https://wiki.servarr.com/sonarr)
- [Radarr Wiki](https://wiki.servarr.com/radarr)
- [Lidarr Wiki](https://wiki.servarr.com/lidarr)
- [qBittorrent](https://www.qbittorrent.org/)

### Docker Resources
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Guide](https://docs.docker.com/compose/)
- [Portainer Documentation](https://docs.portainer.io/)

### Community & Support
- Check logs first: `docker-compose logs SERVICE_NAME`
- GitHub Issues: If you encounter bugs
- Community Forums: ServaRr forums for *Arr questions

---

## ⚠️ Important Notes & Best Practices

### Security
- Keep Docker and services updated
- Change default qBittorrent credentials
- Use strong passwords for Jellyfin admin account
- Consider using a VPN for indexers
- Don't expose ports directly to the internet (use reverse proxy)

### Performance
- Monitor disk space regularly
- Use fast storage for ARRPATH
- Keep at least 20GB free space
- Monitor memory usage with `docker stats`
- Adjust resource limits based on your hardware

### Maintenance
- **Regular Backups**: `tar -czf backup.tar.gz ~/media/Arr/`
- **Update Services**: Run `docker-compose pull && docker-compose up -d` monthly
- **Clean Logs**: Docker logs can grow large; use log rotation
- **Check Indexers**: Update Prowlarr indexers regularly

### Network
- Services communicate via internal Docker network
- From outside: Use server IP + port
- For remote access: Consider reverse proxy (Nginx, Traefik)
- Port forwarding is NOT recommended for security

### Storage Tips
- Monitor each folder: `du -sh ~/media/Arr/*/`
- Allocate space proportionally (Movies & TV shows take most space)
- Consider separate fast drives for active operations
- Archive old downloads to save space

---

## 📝 Logs & Debugging

### View Real-Time Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f SERVICE_NAME

# Last 100 lines
docker-compose logs --tail=100 -f sonarr
```

### Common Log Locations Inside Containers
- Prowlarr: `/config/logs/`
- Sonarr: `/config/logs/`
- Radarr: `/config/logs/`
- Jellyfin: `/config/logs/`

### Export Logs for Support
```bash
# Export last 1000 lines to file
docker-compose logs --tail=1000 > service-logs.txt

# Share for debugging (be careful with sensitive info)
cat service-logs.txt
```

---

## ✅ Verification Checklist

Before considering your setup complete:

- [ ] Run `requirements.sh` successfully
- [ ] Docker installed and working (`docker --version`)
- [ ] All services show "Up" (`docker-compose ps`)
- [ ] Can access Homarr dashboard (http://localhost:7575)
- [ ] Can access Jellyfin (http://localhost:8096)
- [ ] Media folders exist (`ls ~/media/Arr/`)
- [ ] .env configured with correct timezone
- [ ] Prowlarr configured with indexers
- [ ] Sonarr/Radarr connected to qBittorrent
- [ ] Jellyfin libraries added and scanned
- [ ] Can play test media in Jellyfin

---

## 🆘 Getting Help

If you encounter issues:

1. **Check Logs First**
   ```bash
   docker-compose logs SERVICE_NAME
   ```

2. **Verify Requirements**
   - Did you run `requirements.sh`?
   - Did you run `newgrp docker` or log out?
   - Is ARRPATH in .env correct?

3. **Common Fixes**
   - Restart services: `docker-compose restart`
   - Restart Docker: `sudo systemctl restart docker`
   - Check disk space: `df -h`
   - Verify permissions: `ls -l ~/media/Arr/`

4. **Still Having Issues?**
   - Check GitHub Issues
   - Review Docker Compose configuration
   - Verify network connectivity
   - Check firewall rules

---

## 📄 License

[Add your license information here]

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

---

**Last Updated**: 2026-02-11
**Status**: Active
**Version**: 1.0

Happy streaming! 🍿📺🎵
