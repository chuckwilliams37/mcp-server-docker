# MCP Server with Redis, PGVector, and TimescaleDB - Docker Setup Guide

## 🔧 Prerequisites
- Docker
- Docker Compose

## 🗂 Directory Structure
```
.
├── app/
│   └── app.py
├── Dockerfile
├── docker-compose.yml
└── requirements.txt
```

## 📦 Step-by-Step Setup

### 1. Create Required Files
- `app/app.py` - Your MCP server code.
- `requirements.txt` - Python dependencies:
  ```
  fastapi
  uvicorn[standard]
  torch
  redis
  psycopg2-binary
  timescale-toolkit
  mcp-sdk
  ```

### 2. Build and Run
```bash
docker-compose build
docker-compose up
```

### 3. MCP Server Access
Visit [http://localhost:8080](http://localhost:8080)

## 📂 Database Access
- TimescaleDB: `localhost:5432` (`mcpuser` / `example`)
- Redis: `localhost:6379`

## 📘 Notes
- PGVector is included in TimescaleDB image.
- Timescale Toolkit (ImescaleDB Toolkit) auto-installs extensions like `timescaledb_toolkit` & `pgvector`.

## 🚀 Next Steps
- Create `app.py` with FastAPI MCP logic
- Define data ingestion and model interfaces
- Extend Redis/TimescaleDB access in code
