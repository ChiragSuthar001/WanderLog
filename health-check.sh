#!/bin/bash

# WanderLog Health Check Script
# This script connects to the server and performs comprehensive health checks

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
INFO="ℹ️"
ROCKET="🚀"

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
    echo -e "${CYAN}${INFO} $1${NC}"
}

# Check if sshpass is installed
if ! command -v sshpass &> /dev/null; then
    error "sshpass is not installed. Please install it first:"
    echo "  macOS: brew install sshpass"
    echo "  Ubuntu: sudo apt-get install sshpass"
    echo "  CentOS: sudo yum install sshpass"
    exit 1
fi

log "${ROCKET} Starting WanderLog Health Check..."
echo

# Create comprehensive health check command
HEALTH_CHECK_CMD="
# Colors for remote output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e '${BLUE}============================================${NC}'
echo -e '${BLUE}           WANDERLOG HEALTH CHECK          ${NC}'
echo -e '${BLUE}============================================${NC}'
echo

# System Information
echo -e '${CYAN}📊 SYSTEM INFORMATION${NC}'
echo '----------------------------------------'
echo \"Hostname: \$(hostname)\"
echo \"Uptime: \$(uptime | cut -d',' -f1)\"
echo \"Load Average: \$(uptime | awk -F'load average:' '{print \$2}')\"
echo \"Memory Usage: \$(free -h | awk 'NR==2{printf \"%.1f%%\", \$3/\$2 * 100.0}')\"
echo \"Disk Usage: \$(df -h / | awk 'NR==2{print \$5}')\"
echo

# MongoDB Health Check
echo -e '${CYAN}🍃 MONGODB STATUS${NC}'
echo '----------------------------------------'
MONGO_STATUS=\$(systemctl is-active mongod 2>/dev/null || echo 'inactive')
if [ \"\$MONGO_STATUS\" = 'active' ]; then
    echo -e '${GREEN}✅ MongoDB Service: \$MONGO_STATUS${NC}'
    
    # Test MongoDB connection
    if mongosh --quiet --eval 'db.adminCommand({ismaster:1}).ismaster' >/dev/null 2>&1; then
        echo -e '${GREEN}✅ MongoDB Connection: OK${NC}'
    else
        echo -e '${RED}❌ MongoDB Connection: Failed${NC}'
    fi
    
    # Check MongoDB port
    if netstat -tlnp | grep :27017 >/dev/null 2>&1; then
        echo -e '${GREEN}✅ MongoDB Port 27017: Listening${NC}'
    else
        echo -e '${RED}❌ MongoDB Port 27017: Not listening${NC}'
    fi
else
    echo -e '${RED}❌ MongoDB Service: \$MONGO_STATUS${NC}'
fi
echo

# Backend Service Health Check
echo -e '${CYAN}⚙️ BACKEND SERVICE STATUS${NC}'
echo '----------------------------------------'
if command -v pm2 >/dev/null 2>&1; then
    PM2_STATUS=\$(pm2 jlist 2>/dev/null | jq -r '.[0].pm2_env.status // \"not found\"' 2>/dev/null || echo 'pm2 error')
    echo -e \"PM2 Status: \$PM2_STATUS\"
    
    if [ \"\$PM2_STATUS\" = 'online' ]; then
        echo -e '${GREEN}✅ Backend Process: Running${NC}'
        
        # Check backend port
        if netstat -tlnp | grep :5001 >/dev/null 2>&1; then
            echo -e '${GREEN}✅ Backend Port 5001: Listening${NC}'
        else
            echo -e '${RED}❌ Backend Port 5001: Not listening${NC}'
        fi
        
        # Test backend health endpoint
        BACKEND_HEALTH=\$(curl -s -o /dev/null -w '%{http_code}' http://localhost:5001/api/health 2>/dev/null || echo '000')
        if [ \"\$BACKEND_HEALTH\" = '200' ]; then
            echo -e '${GREEN}✅ Backend Health Check: OK (HTTP \$BACKEND_HEALTH)${NC}'
        else
            echo -e '${RED}❌ Backend Health Check: Failed (HTTP \$BACKEND_HEALTH)${NC}'
        fi
        
        # Test backend API
        API_RESPONSE=\$(curl -s -o /dev/null -w '%{http_code}' http://localhost:5001/api/posts 2>/dev/null || echo '000')
        if [ \"\$API_RESPONSE\" = '200' ]; then
            echo -e '${GREEN}✅ Backend API: OK (HTTP \$API_RESPONSE)${NC}'
        else
            echo -e '${RED}❌ Backend API: Failed (HTTP \$API_RESPONSE)${NC}'
        fi
    else
        echo -e '${RED}❌ Backend Process: \$PM2_STATUS${NC}'
    fi
    
    # Show PM2 process list
    echo
    echo 'PM2 Process List:'
    pm2 status 2>/dev/null || echo 'PM2 status unavailable'
else
    echo -e '${RED}❌ PM2 not installed${NC}'
fi
echo

# Nginx Health Check
echo -e '${CYAN}🌐 NGINX STATUS${NC}'
echo '----------------------------------------'
NGINX_STATUS=\$(systemctl is-active nginx 2>/dev/null || echo 'inactive')
if [ \"\$NGINX_STATUS\" = 'active' ]; then
    echo -e '${GREEN}✅ Nginx Service: \$NGINX_STATUS${NC}'
    
    # Test Nginx configuration
    if nginx -t >/dev/null 2>&1; then
        echo -e '${GREEN}✅ Nginx Configuration: Valid${NC}'
    else
        echo -e '${RED}❌ Nginx Configuration: Invalid${NC}'
    fi
    
    # Check Nginx port
    if netstat -tlnp | grep :80 >/dev/null 2>&1; then
        echo -e '${GREEN}✅ Nginx Port 80: Listening${NC}'
    else
        echo -e '${RED}❌ Nginx Port 80: Not listening${NC}'
    fi
    
    # Test frontend access
    FRONTEND_RESPONSE=\$(curl -s -o /dev/null -w '%{http_code}' http://localhost/ 2>/dev/null || echo '000')
    if [ \"\$FRONTEND_RESPONSE\" = '200' ]; then
        echo -e '${GREEN}✅ Frontend Access: OK (HTTP \$FRONTEND_RESPONSE)${NC}'
    else
        echo -e '${RED}❌ Frontend Access: Failed (HTTP \$FRONTEND_RESPONSE)${NC}'
    fi
    
    # Test API proxy
    PROXY_RESPONSE=\$(curl -s -o /dev/null -w '%{http_code}' http://localhost/api/posts 2>/dev/null || echo '000')
    if [ \"\$PROXY_RESPONSE\" = '200' ]; then
        echo -e '${GREEN}✅ API Proxy: OK (HTTP \$PROXY_RESPONSE)${NC}'
    else
        echo -e '${RED}❌ API Proxy: Failed (HTTP \$PROXY_RESPONSE)${NC}'
    fi
else
    echo -e '${RED}❌ Nginx Service: \$NGINX_STATUS${NC}'
fi
echo

# Application Configuration Check
echo -e '${CYAN}🔧 APPLICATION CONFIGURATION${NC}'
echo '----------------------------------------'
if [ -f '$PROJECT_DIR/backend/.env' ]; then
    echo -e '${GREEN}✅ Backend .env file: Exists${NC}'
    echo 'Configuration:'
    cat $PROJECT_DIR/backend/.env | sed 's/^/  /'
else
    echo -e '${RED}❌ Backend .env file: Missing${NC}'
fi
echo

# Recent Logs
echo -e '${CYAN}📄 RECENT LOGS${NC}'
echo '----------------------------------------'
echo 'Backend logs (last 5 lines):'
if command -v pm2 >/dev/null 2>&1; then
    pm2 logs wanderlog-backend --lines 5 --nostream 2>/dev/null | tail -10 || echo 'No backend logs available'
else
    echo 'PM2 not available'
fi
echo

echo 'Nginx error logs (last 3 lines):'
if [ -f '/var/log/nginx/error.log' ]; then
    tail -3 /var/log/nginx/error.log 2>/dev/null || echo 'No recent nginx errors'
else
    echo 'Nginx error log not found'
fi
echo

# External Access Test
echo -e '${CYAN}🌍 EXTERNAL ACCESS TEST${NC}'
echo '----------------------------------------'
PUBLIC_IP=\$(curl -s --max-time 5 ifconfig.me 2>/dev/null || curl -s --max-time 5 ipinfo.io/ip 2>/dev/null || echo 'unknown')
echo \"Public IP: \$PUBLIC_IP\"

# Summary
echo -e '${BLUE}============================================${NC}'
echo -e '${BLUE}                SUMMARY                    ${NC}'
echo -e '${BLUE}============================================${NC}'

# Overall health score
HEALTH_SCORE=0
[ \"\$MONGO_STATUS\" = 'active' ] && HEALTH_SCORE=\$((HEALTH_SCORE + 1))
[ \"\$PM2_STATUS\" = 'online' ] && HEALTH_SCORE=\$((HEALTH_SCORE + 1))
[ \"\$NGINX_STATUS\" = 'active' ] && HEALTH_SCORE=\$((HEALTH_SCORE + 1))
[ \"\$BACKEND_HEALTH\" = '200' ] && HEALTH_SCORE=\$((HEALTH_SCORE + 1))
[ \"\$PROXY_RESPONSE\" = '200' ] && HEALTH_SCORE=\$((HEALTH_SCORE + 1))

echo \"Health Score: \$HEALTH_SCORE/5\"
if [ \$HEALTH_SCORE -eq 5 ]; then
    echo -e '${GREEN}🎉 All systems operational!${NC}'
elif [ \$HEALTH_SCORE -ge 3 ]; then
    echo -e '${YELLOW}⚠️ Some issues detected, but service is partially functional${NC}'
else
    echo -e '${RED}🚨 Critical issues detected! Service may be down${NC}'
fi

echo
echo \"Application URL: http://\$PUBLIC_IP\"
echo \"Timestamp: \$(date)\"
"

# Execute health check on remote server
log "🔗 Connecting to server $SERVER_IP for health check..."
echo

if sshpass -p "$SERVER_PASSWORD" ssh -o StrictHostKeyChecking=no "$SERVER_USER@$SERVER_IP" "$HEALTH_CHECK_CMD"; then
    echo
    success "Health check completed successfully!"
else
    echo
    error "Health check failed or server unreachable!"
    exit 1
fi

echo
log "🎯 Health check process completed!"
echo
echo "💡 Quick actions:"
echo "  - Restart services: ssh root@$SERVER_IP 'systemctl restart mongod && pm2 restart wanderlog-backend && systemctl restart nginx'"
echo "  - View live logs: ssh root@$SERVER_IP 'pm2 logs wanderlog-backend'"
echo "  - Run update: ./deploy-to-server.sh"