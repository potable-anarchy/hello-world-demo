#!/bin/bash
set -e

# Load configuration and export variables
set -a  # automatically export all variables
source app.env
set +a  # stop automatically exporting

echo "🚀 Deploying ${APP_NAME}..."

# Validate configuration
if [[ -z "$APP_NAME" || -z "$APP_PORT" || -z "$PUBLIC_DOMAIN" ]]; then
    echo "❌ Missing required configuration in app.env"
    echo "Required: APP_NAME, APP_PORT, PUBLIC_DOMAIN"
    exit 1
fi

# Check if port is available
if ss -tuln | grep -q ":${APP_PORT} " 2>/dev/null; then
    echo "⚠️  Port ${APP_PORT} is already in use"
    # In automated mode, continue anyway
    echo "⚠️  Continuing with deployment..."
fi

# Install dependencies
echo "📦 Installing dependencies..."
npm install --only=production

# Build and start containers
echo "📦 Building Docker containers..."
docker compose build --no-cache

echo "🔄 Starting services..."
docker compose up -d

# Wait for health check
echo "⏳ Waiting for service to be healthy..."
timeout 60 bash -c "
while ! docker compose ps | grep -q healthy; do
    sleep 2
    echo -n '.'
done
echo
"

# Update cloudflared configuration (if script exists)
if [[ -f "/home/brad/prod-pi/scripts/update-cloudflared-config.sh" ]]; then
    echo "🌐 Updating Cloudflared tunnel configuration..."
    sudo /home/brad/prod-pi/scripts/update-cloudflared-config.sh "${PWD}/cloudflared.yml"
else
    echo "⚠️  Cloudflared config script not found - skipping tunnel configuration"
fi

# Test deployment
echo "🧪 Testing deployment..."
sleep 5
if curl -s -f "http://localhost:${APP_PORT}/health" > /dev/null; then
    echo "✅ Local health check passed"
else
    echo "⚠️  Local health check failed, but service may still be starting"
fi

echo "✅ Deployment complete!"
echo "📍 Local: http://localhost:${APP_PORT}"
echo "📍 Public: https://${PUBLIC_DOMAIN}"
echo "📍 Logs: docker compose logs -f"
echo "📍 Status: docker compose ps"