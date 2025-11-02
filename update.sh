#!/bin/bash

# WanderLog Update Script
# Run this script on your server to update to the latest version

set -e

PROJECT_DIR="/opt/WanderLog"
BACKUP_DIR="/opt/backups/wanderlog-$(date +%Y%m%d-%H%M%S)"

echo "🔄 Starting WanderLog update process..."

# Check if project directory exists
if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ Error: Project directory $PROJECT_DIR not found!"
    echo "Please run the deployment script first."
    exit 1
fi

# Create backup
echo "💾 Creating backup..."
mkdir -p /opt/backups
cp -r "$PROJECT_DIR" "$BACKUP_DIR"
echo "✅ Backup created at: $BACKUP_DIR"

# Change to project directory
cd "$PROJECT_DIR"

# Check current git status
echo "📊 Current git status:"
git status --porcelain
git log --oneline -3

# Stash any local changes
echo "💾 Stashing local changes..."
git stash push -m "Auto-stash before update $(date)"

# Pull latest changes
echo "📥 Pulling latest changes..."
git fetch origin
git pull origin main

# Show what changed
echo "📋 Changes pulled:"
git log --oneline -5

# Update backend dependencies
echo "🔧 Updating backend dependencies..."
cd "$PROJECT_DIR/backend"
npm install --production

# Update frontend and rebuild
echo "🎨 Updating frontend..."
cd "$PROJECT_DIR/frontend"
npm install
echo "🏗️ Building frontend..."
npm run build

# Restart backend service
echo "🔄 Restarting backend service..."
pm2 restart wanderlog-backend

# Reload nginx (in case of config changes)
echo "🌐 Reloading nginx..."
nginx -t && systemctl reload nginx

# Check service status
echo "📊 Checking service status..."
echo "Backend status:"
pm2 status wanderlog-backend

echo "Nginx status:"
systemctl status nginx --no-pager -l

echo "MongoDB status:"
systemctl status mongod --no-pager -l

# Test the application
echo "🧪 Testing application..."
HEALTH_CHECK=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/api/posts || echo "000")

if [ "$HEALTH_CHECK" = "200" ]; then
    echo "✅ Health check passed! Application is running correctly."
else
    echo "⚠️  Health check failed (HTTP $HEALTH_CHECK). Check logs:"
    echo "Backend logs:"
    pm2 logs wanderlog-backend --lines 10
    echo ""
    echo "Nginx error logs:"
    tail -10 /var/log/nginx/error.log
fi

# Cleanup old backups (keep last 5)
echo "🧹 Cleaning up old backups..."
cd /opt/backups
ls -t | grep "wanderlog-" | tail -n +6 | xargs -r rm -rf

echo "✅ Update completed!"
echo "🌍 Your application is available at: http://$(curl -s ifconfig.me)"
echo "📁 Backup location: $BACKUP_DIR"
echo ""
echo "💡 Useful commands:"
echo "  - View backend logs: pm2 logs wanderlog-backend"
echo "  - Restart backend: pm2 restart wanderlog-backend"
echo "  - Check nginx: systemctl status nginx"
echo "  - Rollback: cp -r $BACKUP_DIR/* $PROJECT_DIR/"