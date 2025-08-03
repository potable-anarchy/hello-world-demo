# Hello World Demo App

This is a demonstration application showing how the **prod-pi self-updating infrastructure system** works.

<!-- Lifecycle test change - August 3, 2025 -->

## What This Demonstrates

This repository demonstrates the complete end-to-end workflow:

1. **Make changes** to this GitHub repository
2. **Push to main branch** triggers webhook automatically  
3. **Server receives webhook** and runs deployment
4. **App updates** without SSH access required

## Live Demo

- **App URL**: https://hello.brad-dougherty.com (when tunnel configured)
- **Local URL**: http://localhost:3003 (on prod-pi server)

## Endpoints

- `GET /` - Main hello message with system info
- `GET /health` - Health check endpoint (required for Docker)
- `GET /api/info` - API information and deployment details

## Configuration

- **Port**: 3003 (automatically assigned next available port)
- **Domain**: hello.brad-dougherty.com (when tunnel configured)
- **Container**: Docker with health checks
- **Environment**: Production-ready with proper logging

## How It Works

1. **GitHub Webhook** → `https://prod.circle.solutions/webhook`
2. **Webhook Server** validates signature and triggers deployment
3. **Deploy Script** (`deploy.sh`) pulls latest code and rebuilds container
4. **Docker Health Checks** ensure app is running correctly
5. **Cloudflare Tunnel** provides secure external access

## Making Changes

To test the system:

1. Edit any file in this repository (try changing the message in `server.js`)
2. Commit and push to main branch
3. Watch the deployment happen automatically on the server
4. Visit the app URL to see your changes live

## Architecture

```
GitHub Push → Webhook → prod-pi Server → Docker Container → Cloudflare Tunnel → Public Internet
```

This demonstrates how you can deploy and manage applications entirely through GitHub without needing SSH access to the server.

## Built With

- **Node.js** + Express for the web server
- **Docker** for containerization  
- **GitHub Webhooks** for automatic deployments
- **Cloudflare Tunnels** for secure external access
- **prod-pi** self-updating infrastructure system

---

🤖 This demo app is part of the prod-pi self-updating infrastructure system.