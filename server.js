const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;
const MESSAGE = process.env.APP_MESSAGE || 'Hello World from GitHub Webhook!';
const VERSION = process.env.VERSION || '1.0.0';

app.use(express.json());

// Main endpoint
app.get('/', (req, res) => {
  res.json({
    message: MESSAGE,
    version: VERSION,
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV,
    hostname: require('os').hostname(),
    uptime: process.uptime(),
    system: 'prod-pi self-updating infrastructure'
  });
});

// Health check endpoint (required for Docker health checks)
app.get('/health', (req, res) => {
  res.json({ 
    status: 'healthy', 
    timestamp: new Date().toISOString(),
    version: VERSION,
    uptime: process.uptime()
  });
});

// API info endpoint
app.get('/api/info', (req, res) => {
  res.json({
    name: 'Hello World Demo App',
    description: 'Demonstrates prod-pi self-updating system',
    version: VERSION,
    endpoints: [
      { path: '/', method: 'GET', description: 'Main hello message' },
      { path: '/health', method: 'GET', description: 'Health check' },
      { path: '/api/info', method: 'GET', description: 'API information' }
    ],
    deployment: {
      system: 'prod-pi',
      container: 'Docker',
      orchestration: 'docker-compose',
      tunnel: 'Cloudflare',
      automation: 'GitHub webhooks'
    }
  });
});

// Start server
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Hello World app running on port ${PORT}`);
  console.log(`📝 Message: ${MESSAGE}`);
  console.log(`🔢 Version: ${VERSION}`);
  console.log(`🌍 Environment: ${process.env.NODE_ENV}`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('👋 Received SIGTERM, shutting down gracefully');
  process.exit(0);
});

process.on('SIGINT', () => {
  console.log('👋 Received SIGINT, shutting down gracefully');
  process.exit(0);
});