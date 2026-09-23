#!/bin/bash
# =====================
# OFFENSIVE-CRAB-V1 - Docker Entrypoint
# Author: Ian Carter Kulani, MSc
# Version: 1.0.0
# =====================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${RED}"
cat << "EOF"
╔══════════════════════════════════════════════════════════════════════════════╗
║        🦀 OFFENSIVE-CRAB-V1 - Docker Container                          ║
║        Ultimate Cybersecurity Command & Control Platform                  ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Configuration
CONFIG_DIR="${OFFENSIVE_CRAB_CONFIG:-/config}"
APP_DIR="${OFFENSIVE_CRAB_HOME:-/app}"

echo -e "${BLUE}[*] Container started${NC}"
echo -e "${BLUE}[*] App directory: ${APP_DIR}${NC}"
echo -e "${BLUE}[*] Config directory: ${CONFIG_DIR}${NC}"

# Ensure config directories exist
mkdir -p "${CONFIG_DIR}/payloads" \
         "${CONFIG_DIR}/reports" \
         "${CONFIG_DIR}/scans" \
         "${CONFIG_DIR}/logs" \
         "${CONFIG_DIR}/phishing_templates" \
         "${CONFIG_DIR}/captured_credentials"

# Create default config if missing
if [ ! -f "${CONFIG_DIR}/config.json" ]; then
    echo -e "${YELLOW}[*] Creating default configuration...${NC}"
    cat > "${CONFIG_DIR}/config.json" << 'CONFIGEOF'
{
    "version": "1.0.0",
    "auto_start": false,
    "auto_block_enabled": false,
    "auto_block_threshold": 5,
    "scan_timeout": 30,
    "report_format": "pdf",
    "generate_graphics": true,
    "web": {
        "enabled": true,
        "port": 5000,
        "host": "0.0.0.0"
    },
    "threat_monitor": {
        "enabled": false,
        "interval": 300
    }
}
CONFIGEOF
fi

# Check for required environment variables
echo -e "${BLUE}[*] Environment check:${NC}"
echo -e "    DOCKER_MODE: ${DOCKER_MODE:-false}"
echo -e "    WEB_PORT: ${WEB_PORT:-5000}"
echo -e "    SCAN_TARGET: ${SCAN_TARGET:-not set}"

# Handle special commands
case "$1" in
    shell|bash)
        echo -e "${GREEN}[+] Opening shell...${NC}"
        exec /bin/bash
        ;;
    check)
        echo -e "${BLUE}[*] Running dependency check...${NC}"
        exec python3 /app/requirements-check.py
        ;;
    health)
        echo -e "${BLUE}[*] Running health check...${NC}"
        exec python3 /app/healthcheck.py
        ;;
    web)
        echo -e "${GREEN}[+] Starting web dashboard only...${NC}"
        exec python3 -c "
import sys
sys.path.insert(0, '/app')
from offensive_crab_v1 import OffensiveCrabV1
app = OffensiveCrabV1()
app.web.start()
import time
while True:
    time.sleep(1)
"
        ;;
    scan)
        echo -e "${GREEN}[+] Running scan...${NC}"
        if [ -n "$SCAN_TARGET" ]; then
            exec python3 -c "
import sys
sys.path.insert(0, '/app')
from offensive_crab_v1 import OffensiveCrabV1
app = OffensiveCrabV1()
result = app.handler.execute('nmap_quick $SCAN_TARGET')
print(result.get('output', ''))
"
        else
            echo -e "${RED}[!] SCAN_TARGET not set${NC}"
            exit 1
        fi
        ;;
    help|--help|-h)
        cat << 'HELPEOF'
OFFENSIVE-CRAB-V1 Docker Container

Usage:
  docker run offensive-crab [command]

Commands:
  (none)      Start interactive mode (default)
  shell       Open bash shell
  check       Run dependency checker
  health      Run health check
  web         Start web dashboard only
  scan        Run a scan (requires SCAN_TARGET env)
  help        Show this help

Environment Variables:
  WEB_PORT          Web dashboard port (default: 5000)
  SCAN_TARGET       Target for scanning
  DOCKER_MODE       Enable Docker mode (default: false)
  OFFENSIVE_CRAB_CONFIG   Config directory (default: /config)

Examples:
  # Interactive mode
  docker run -it --rm offensive-crab

  # Web dashboard
  docker run -d -p 5000:5000 -e WEB_PORT=5000 offensive-crab web

  # Scan a target
  docker run --rm -e SCAN_TARGET=192.168.1.1 offensive-crab scan

  # With full capabilities (for raw sockets)
  docker run -it --rm --privileged --network host offensive-crab

HELPEOF
        exit 0
        ;;
esac

# Check for root/capabilities
if [ "$(id -u)" = "0" ]; then
    echo -e "${GREEN}[+] Running as root - full functionality available${NC}"
    
    # Enable IP forwarding for ARP spoofing
    echo 1 > /proc/sys/net/ipv4/ip_forward 2>/dev/null || true
    
    # Set up iptables if needed
    if [ "${SETUP_FIREWALL:-false}" = "true" ]; then
        echo -e "${BLUE}[*] Setting up firewall rules...${NC}"
        iptables -F 2>/dev/null || true
    fi
else
    echo -e "${YELLOW}[!] Running as non-root - some features may be limited${NC}"
    echo -e "${YELLOW}    Use --privileged or --cap-add for full functionality${NC}"
fi

# Check network capabilities
if [ -e /proc/net/dev ]; then
    echo -e "${GREEN}[+] Network interfaces:${NC}"
    ip addr show 2>/dev/null | grep -E '^[0-9]+:' | awk '{print "    " $2}' || true
fi

# Start application
echo -e "${GREEN}[+] Starting OFFENSIVE-CRAB-V1...${NC}"
echo ""

exec "$@"
