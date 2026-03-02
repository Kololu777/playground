# Deployment Guide

## Prerequisites

- Docker and Docker Compose installed
- Access to the container registry
- Environment variables configured

## Steps

### 1. Build the Docker image

```bash
docker build -t myapp:latest .
```

### 2. Configure environment

Copy `.env.example` to `.env` and fill in production values:

```bash
cp .env.example .env
```

### 3. Deploy

```bash
docker-compose up -d
```

### 4. Verify

```bash
curl http://localhost:3000/health
```

## Rollback

To rollback to the previous version:

```bash
docker-compose down
docker-compose up -d --force-recreate
```
