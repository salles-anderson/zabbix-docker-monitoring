# Zabbix Docker Monitoring

A Docker-based Zabbix monitoring stack for monitoring Laravel applications and infrastructure.

![Zabbix](https://img.shields.io/badge/Zabbix-CC0000?style=for-the-badge&logo=zabbix&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![Laravel](https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white)

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Docker Network                            │
│                                                              │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐     │
│  │   Laravel   │◀───│   Zabbix    │───▶│   Zabbix    │     │
│  │    App      │    │   Agent     │    │   Server    │     │
│  │   :8080     │    │             │    │             │     │
│  └─────────────┘    └─────────────┘    └──────┬──────┘     │
│                                               │             │
│                                               ▼             │
│  ┌─────────────┐                      ┌─────────────┐      │
│  │   Zabbix    │◀─────────────────────│  PostgreSQL │      │
│  │    Web      │                      │     DB      │      │
│  │   :8081     │                      │             │      │
│  └─────────────┘                      └─────────────┘      │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Components

| Service | Port | Description |
|---------|------|-------------|
| Laravel App | 8080 | PHP application being monitored |
| Zabbix Web | 8081 | Zabbix web interface |
| Zabbix Server | 10051 | Zabbix server (internal) |
| Zabbix Agent | 10050 | Monitoring agent |
| PostgreSQL | 5432 | Zabbix database (internal) |

## Prerequisites

- Docker >= 20.0
- Docker Compose >= 2.0

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/salles-anderson/zabbix-docker-monitoring.git
cd zabbix-docker-monitoring
```

### 2. Start the stack

```bash
docker-compose up -d
```

### 3. Access the services

- **Laravel App**: http://localhost:8080
- **Zabbix Web**: http://localhost:8081
  - Username: `Admin`
  - Password: `zabbix`

## Project Structure

```
.
├── docker-compose.yml       # Main compose file
├── laravel/
│   ├── Dockerfile           # Laravel container build
│   └── ...                  # Laravel application files
└── README.md
```

## Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `POSTGRES_USER` | postgres | Database user |
| `POSTGRES_PASSWORD` | postgres | Database password |
| `POSTGRES_DB` | zabbix | Database name |
| `ZBX_SERVER_HOST` | zabbix-server | Zabbix server hostname |

## Useful Commands

```bash
# View logs
docker-compose logs -f zabbix-server

# Restart services
docker-compose restart

# Stop containers
docker-compose down
```

## Author

**Anderson Sales** - DevOps Cloud Engineer

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0A66C2?style=flat-square&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/salesanderson)
