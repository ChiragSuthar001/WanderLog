#!/bin/bash

# WanderLog Environment Fix Script
# This script connects to the server and fixes the .env configuration

set -e

# Server configuration
SERVER_IP="8.221.125.31"
SERVER_USER="root"
SERVER_PASSWORD="Lyqlah5577##"
PROJECT_DIR="/opt/WanderLog"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Icons
CHECK="✅"
CROSS="❌"
WARNING="⚠️"
ROCKET="🚀"
WRENCH="🔧"

# Logging function
log() {
    echo -e "${BLUE}[$(date '+%H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}${CHECK} $1${NC}"
}

error() {
    echo -e "${RED}${CROSS} $1${NC}"
}

warning() {
    echo -e "${YELLOW}${WARNING} $1${NC}"
}

info() {
    echo -e "${CYAN}${WRENCH} $1${NC}"
}

# Check if sshpass is installed
if ! command -v sshpass &> /dev/null; then
    error "sshpass is not installed. Please install it first:"
    echo "  macOS: brew install sshpass"
    echo "  Ubuntu: sudo apt-get install sshpass"
    echo "  CentOS: sudo yum install sshpass"
    exit 1
fi

log "${ROCKET} Starting WanderLog Environment Fix..."
echo

# Create environment fix command
ENV_FIX_CMD="
set -e

echo -e '${BLUE}============================================${NC}'
echo -e '${BLUE}        WANDERLOG ENVIRONMENT FIX          ${NC}'
echo -e '${BLUE}============================================${NC}'
echo

# Check current directory
cd $PROJECT_DIR || { echo 'Project directory not found!'; exit 1; }
echo \"Working directory: \$(pwd)\"
echo

# Backup current .env file
echo -e '${CYAN}💾 Creating backup of current .env file...${NC}'
if [ -f 'backend/.env' ]; then
    cp backend/.env backend/.env.backup.\$(date +%Y%m%d-%H%M%S)
    echo -e '${GREEN}✅ Backup created${NC}'
    echo 'Current .env content:'
    cat backend/.env | sed 's/^/  /'
else
    echo -e '${YELLOW}⚠️ No existing .env file found${NC}'
fi
echo

# Create new .env file with correct configuration
echo -e '${CYAN}🔧 Creating new .env file...${NC}'
cat > backend/.env << 'EOF'
MONGODB_URI=mongodb://127.0.0.1:27017/wanderlog
PORT=5001
NODE_ENV=production
EOF

echo -e '${GREEN}✅ New .env file created${NC}'
echo 'New .env content:'
cat backend/.env | sed 's/^/  /'
echo

# Set proper permissions
chmod 600 backend/.env
echo -e '${GREEN}✅ File permissions set (600)${NC}'

# Validate MongoDB connection string
echo -e '${CYAN}🔍 Validating configuration...${NC}'
MONGO_URI=\$(grep MONGODB_URI backend/.env | cut -d'=' -f2)
PORT=\$(grep PORT backend/.env | cut -d'=' -f2)

echo \"MongoDB URI: \$MONGO_URI\"
echo \"Port: \$PORT\"

# Test MongoDB connection
echo -e '${CYAN}🧪 Testing MongoDB connection...${NC}'
if mongosh --quiet --eval 'db.adminCommand({ismaster:1}).ismaster' \$MONGO_URI >/dev/null 2>&1; then
    echo -e '${GREEN}✅ MongoDB connection test: PASSED${NC}'
else
    echo -e '${RED}❌ MongoDB connection test: FAILED${NC}'
    echo 'Checking MongoDB service status...'
    systemctl status mongod --no-pager -l | head -5
fi
echo

# Restart backend service
echo -e '${CYAN}🔄 Restarting backend service...${NC}'
if command -v pm2 >/dev/null 2>&1; then
    echo 'Stopping backend service...'
    pm2 stop wanderlog-backend >/dev/null 2>&1 || echo 'Service was not running'
    
    echo 'Starting backend service...'
    cd backend
    pm2 start server.js --name wanderlog-backend
    
    echo 'Waiting for service to stabilize...'
    sleep 5
    
    # Check PM2 status
    PM2_STATUS=\$(pm2 jlist 2>/dev/null | jq -r '.[0].pm2_env.status // \"unknown\"' 2>/dev/null || echo 'unknown')
    if [ \"\$PM2_STATUS\" = 'online' ]; then
        echo -e '${GREEN}✅ Backend service restarted successfully${NC}'
    else
        echo -e '${RED}❌ Backend service restart failed (Status: \$PM2_STATUS)${NC}'
    fi
    
    cd ..
else
    echo -e '${RED}❌ PM2 not found${NC}'
fi
echo

# Test backend endpoints
echo -e '${CYAN}🧪 Testing backend endpoints...${NC}'

# Test health endpoint
HEALTH_RESPONSE=\$(curl -s -o /dev/null -w '%{http_code}' http://localhost:5001/api/health 2>/dev/null || echo '000')
if [ \"\$HEALTH_RESPONSE\" = '200' ]; then
    echo -e '${GREEN}✅ Health endpoint: OK (HTTP \$HEALTH_RESPONSE)${NC}'
else
    echo -e '${RED}❌ Health endpoint: FAILED (HTTP \$HEALTH_RESPONSE)${NC}'
fi

# Test posts API
API_RESPONSE=\$(curl -s -o /dev/null -w '%{http_code}' http://localhost:5001/api/posts 2>/dev/null || echo '000')
if [ \"\$API_RESPONSE\" = '200' ]; then
    echo -e '${GREEN}✅ Posts API: OK (HTTP \$API_RESPONSE)${NC}'
else
    echo -e '${RED}❌ Posts API: FAILED (HTTP \$API_RESPONSE)${NC}'
fi
echo

# Test Nginx proxy
echo -e '${CYAN}🌐 Testing Nginx proxy...${NC}'
PROXY_RESPONSE=\$(curl -s -o /dev/null -w '%{http_code}' http://localhost/api/posts 2>/dev/null || echo '000')
if [ \"\$PROXY_RESPONSE\" = '200' ]; then
    echo -e '${GREEN}✅ Nginx proxy: OK (HTTP \$PROXY_RESPONSE)${NC}'
else
    echo -e '${RED}❌ Nginx proxy: FAILED (HTTP \$PROXY_RESPONSE)${NC}'
    echo 'Reloading Nginx...'
    nginx -t && systemctl reload nginx
    sleep 2
    
    # Test again after reload
    PROXY_RESPONSE_2=\$(curl -s -o /dev/null -w '%{http_code}' http://localhost/api/posts 2>/dev/null || echo '000')
    if [ \"\$PROXY_RESPONSE_2\" = '200' ]; then
        echo -e '${GREEN}✅ Nginx proxy after reload: OK (HTTP \$PROXY_RESPONSE_2)${NC}'
    else
        echo -e '${RED}❌ Nginx proxy after reload: FAILED (HTTP \$PROXY_RESPONSE_2)${NC}'
    fi
fi
echo

# Show current service status
echo -e '${CYAN}📊 Current service status:${NC}'
echo '----------------------------------------'
echo \"MongoDB: \$(systemctl is-active mongod 2>/dev/null || echo 'unknown')\"
echo \"Backend: \$(pm2 jlist 2>/dev/null | jq -r '.[0].pm2_env.status // \"unknown\"' 2>/dev/null || echo 'unknown')\"
echo \"Nginx: \$(systemctl is-active nginx 2>/dev/null || echo 'unknown')\"
echo

# Final summary
echo -e '${BLUE}============================================${NC}'
echo -e '${BLUE}                SUMMARY                    ${NC}'
echo -e '${BLUE}============================================${NC}'

if [ \"\$HEALTH_RESPONSE\" = '200' ] && [ \"\$API_RESPONSE\" = '200' ] && [ \"\$PROXY_RESPONSE\" = '200' ] || [ \"\$PROXY_RESPONSE_2\" = '200' ]; then
    echo -e '${GREEN}🎉 Environment fix completed successfully!${NC}'
    echo -e '${GREEN}✅ All services are now operational${NC}'
else
    echo -e '${YELLOW}⚠️ Environment fix completed with some issues${NC}'
    echo -e '${YELLOW}Some services may still need manual attention${NC}'
fi

echo
echo \"Timestamp: \$(date)\"
echo \"Application URL: http://\$(curl -s --max-time 5 ifconfig.me 2>/dev/null || echo '8.221.125.31')\"
"

# Execute environment fix on remote server
log "🔗 Connecting to server $SERVER_IP for environment fix..."
echo

if sshpass -p "$SERVER_PASSWORD" ssh -o StrictHostKeyChecking=no "$SERVER_USER@$SERVER_IP" "$ENV_FIX_CMD"; then
    echo
    success "Environment fix completed successfully!"
    echo
    info "Your application should now be working properly at: http://$SERVER_IP"
else
    echo
    error "Environment fix failed or server unreachable!"
    exit 1
fi

echo
log "🎯 Environment fix process completed!"
echo
echo "💡 Next steps:"
echo "  - Test your application: http://$SERVER_IP"
echo "  - Run health check: ./health-check.sh"
echo "  - View logs: ssh root@$SERVER_IP 'pm2 logs wanderlog-backend'"