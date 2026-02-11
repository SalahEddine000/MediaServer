
# 🎬 MediaServer - Complete Home Media Stack

A comprehensive Docker-based home media server solution featuring automatic media management, downloading, and playback with an integrated suite of powerful applications.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Services](#services)
- [Directory Structure](#directory-structure)
- [Configuration](#configuration)
- [Port Mappings](#port-mappings)
- [Accessing the Services](#accessing-the-services)
- [Common Tasks](#common-tasks)
- [Troubleshooting](#troubleshooting)
- [Additional Resources](#additional-resources)
- [Important Notes](#important-notes)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Overview

MediaServer is a complete home media infrastructure that combines multiple specialized applications into a single, easy-to-manage Docker stack. Perfect for automating the management of your personal media library across movies, TV shows, and music.

This project orchestrates 8 interconnected services using Docker Compose, providing a seamless experience for media collection, organization, and streaming.

## ✨ Features

- Automated media discovery, downloading and organization
- Support for movies, TV shows, music and subtitles
- CloudFlare bypass for protected sites (FlareSolverr)
- Portainer for container management
- Docker-native — easy to deploy and upgrade
- Shared network and common configuration for simplicity
- Scripted installation for Ubuntu/Debian systems

## 📦 Prerequisites

- Ubuntu/Debian-based Linux (tested)
- Docker (latest)
- Docker Compose (plugin or v2)
- Sudo-capable user
- Recommended hardware: 2+ GB RAM, sufficient disk for media

## 🚀 Quick Start

1. Clone the repo:
   ```bash
   git clone https://github.com/SalahEddine000/MediaServer.git
   cd MediaServer
   ```

2. Run the setup script (installs Docker, Portainer, creates directories):
   ```bash
   bash requirements.sh
   ```
   After running, either log out/login or run:
   ```bash
   newgrp docker
   ```

3. Start the stack:
   ```bash
   docker compose up -d
   ```

4. Verify containers:
   ```bash
   docker ps
   ```

5. Visit Portainer (optional) at `https://<your-server-ip>:9443` to manage containers visually.

## 🛠️ Services

This stack includes:

- Jellyfin (media server) — 8096
- Radarr (movies) — 7878
- Sonarr (TV shows) — 8989
- Lidarr (music) — 8686
- Bazarr (subtitles) — 6767
- Prowlarr (indexer manager) — 9696
- qBittorrent (downloader) — 8080 and 6881
- FlareSolverr (CloudFlare bypass) — 8191

Each service runs in its own container and stores configuration under `/docker/appdata/<service>` (as defined in docker-compose.yml).

## 📁 Directory Structure

The setup script creates the following on the host (default paths):

```
/data/
├── torrents/
│   ├── tv/
│   ├── movies/
│   └── music/
└── media/
    ├── tv/
    ├── movies/
    └── music/

Docker appdata:
 /docker/appdata/
 ├── radarr/
 ├── sonarr/
 ├── lidarr/
 ├── bazarr/
 ├── prowlarr/
 ├── qbittorrent/
 ├── jellyfin/
 └── portainer_data/
```

Permissions set by the script: owner UID:GID 1000:1000 (adjust if needed).

## ⚙️ Configuration

Common environment variables (set in docker-compose.yml):

```env
PUID=1000
PGID=1000
TZ=Europe/London
```

Network: all services use a dedicated Docker network `arr_network`. DNS configured to Cloudflare (1.1.1.1 / 1.0.0.1).

Change any env values or volumes in `docker-compose.yml` to suit your setup.

## 🔌 Port Mappings

| Service | UI Port | Purpose |
|--------:|:--------|:--------|
| Radarr | 7878 | Movie management |
| Sonarr | 8989 | TV show management |
| Lidarr | 8686 | Music management |
| Bazarr | 6767 | Subtitle management |
| Prowlarr | 9696 | Indexer manager |
| qBittorrent (WebUI) | 8080 | Download client UI |
| qBittorrent (Torrent) | 6881 | Torrent protocol |
| Jellyfin | 8096 | Media server / playback |
| FlareSolverr | 8191 | CloudFlare bypass API |
| Portainer | 9443 | Container management UI |

## 🌐 Accessing the Services

Example (if server IP is 192.168.1.100):

- Jellyfin: http://192.168.1.100:8096
- Radarr: http://192.168.1.100:7878
- Sonarr: http://192.168.1.100:8989
- Lidarr: http://192.168.1.100:8686
- Bazarr: http://192.168.1.100:6767
- Prowlarr: http://192.168.1.100:9696
- qBittorrent: http://192.168.1.100:8080
- Portainer: https://192.168.1.100:9443

Use the container names for inter-service communication (example: Radarr -> qBittorrent as `http://qbittorrent:8080`).

## ✅ Recommended Initial Setup Flow

1. Prowlarr — add and test indexers.
2. qBittorrent — change default password, set download paths to `/data/torrents`.
3. Radarr — add qBittorrent and Prowlarr; set movie root to `/data/media/movies`.
4. Sonarr — add qBittorrent and Prowlarr; set series root to `/data/media/tv`.
5. Lidarr — add qBittorrent and Prowlarr; set root to `/data/media/music`.
6. Bazarr — link to Radarr and Sonarr; set subtitle languages and providers.
7. Jellyfin — add libraries pointing to `/data/media/*` and create users.

## 🔧 Common Tasks

View logs:
```bash
docker compose logs -f            # all services
docker compose logs -f radarr     # single service
```

Restart a service:
```bash
docker compose restart radarr
```

Stop all:
```bash
docker compose down
```

Update images & restart:
```bash
docker compose pull
docker compose up -d
```

Fix permissions:
```bash
sudo chown -R 1000:1000 /data
sudo chmod -R a=,a+rX,u+w,g+w /data
```

## 🐞 Troubleshooting

- Service won't start: ensure Docker is running (`systemctl status docker`), check `docker ps`, inspect logs (`docker compose logs <service>`).
- Permission denied: verify `/data` ownership and `PUID/PGID` values match your user.
- Can't access web UI: check firewall/UFW, ensure ports are exposed, and `docker ps` shows port mappings.
- Indexers not returning results: ensure Prowlarr is configured and linked to Radarr/Sonarr/Lidarr, and FlareSolverr is reachable for CloudFlare-protected indexers.
- qBittorrent connection fails: verify qBittorrent WebUI credentials and that it accepts connections from the other containers (use container names in settings).

Helpful commands:
```bash
# Check ports listening
ss -tulpen | grep -E '8096|7878|8989|8686|6767|9696|8080|8191|9443'

# Disk usage
df -h /data
du -sh /data/* | sort -h
```

## Bazarr — configuration (complete)

1. Open Bazarr UI: `http://<server-ip>:6767`
2. Providers: enable required subtitle providers (OpenSubtitles, Addic7ed, Subscene, etc.). For some providers you may need API keys.
3. Languages: select preferred subtitle languages.
4. Sonarr/Radarr Integration:
   - Settings → Sonarr/Radarr → Add → provide service URL and API key.
   - Example Sonarr URL: `http://sonarr:8989` (for internal, or `http://<server-ip>:8989` for external).
5. Test and enable automatic subtitle searching. Configure fallback providers and quality preferences.
6. Check logs and enable debug if subtitle fetching fails.

## 🔗 Additional Resources

- Jellyfin: https://jellyfin.org/docs/
- Radarr: https://wiki.servarr.com/radarr
- Sonarr: https://wiki.servarr.com/sonarr
- Lidarr: https://wiki.servarr.com/lidarr
- Bazarr: https://www.bazarr.media/
- Prowlarr: https://wiki.servarr.com/prowlarr
- qBittorrent: https://www.qbittorrent.org/
- FlareSolverr: https://github.com/FlareSolverr/FlareSolverr
- Docker docs: https://docs.docker.com/

## ⚠️ Important Notes

- Legal: Ensure you comply with local laws regarding content downloading and distribution.
- Security: Do not expose these services to the public internet without a reverse proxy, HTTPS, authentication, and firewall rules.
- Backups: Regularly back up `/docker/appdata/*` (databases and config).
- Updates: Keep containers and host OS updated; test updates on a non-critical system first.
- Resource planning: Media servers can consume significant CPU/disk I/O and storage; plan accordingly.

## 🤝 Contributing

Contributions, issues and feature requests are welcome.

- Open an issue to report bugs or request enhancements.
- Submit pull requests with clear descriptions of changes.
- Keep changes focused and well-documented.

When contributing, follow these guidelines:
- Use concise commit messages.
- Document configuration changes in the README.
- Test compatibility locally before opening PRs.

## 📄 License

This project is provided as-is for personal/home use. No explicit open-source license is included. If you want to publish under a specific license (MIT, Apache 2.0, etc.), add a LICENSE file.

## 📬 Contact & Support

For issues or questions, open an issue on the repository:  
https://github.com/SalahEddine000/MediaServer/issues

---

**Last Updated:** 2026-02-11
