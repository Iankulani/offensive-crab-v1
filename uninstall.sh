#!/usr/bin/env bash
# =====================
# OFFENSIVE-CRAB-V1 - Uninstall Script
# Author: Ian Carter Kulani, MSc
# Version: 1.0.0
# =====================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

INSTALL_DIR="/opt/offensive-crab-v1"
CONFIG_DIR="${HOME}/.offensive_crab_v1"
BIN_DIR="/usr/local/bin"

echo -e "${RED}"
cat << "EOF"
╔══════════════════════════════════════════════════════════════════════════════╗
║        🦀 OFFENSIVE-CRAB-V1 - Uninstaller                                ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

read -p "$(echo -e ${YELLOW})Are you sure you want to uninstall? [y/N]: $(echo -e ${NC})" confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}Uninstall cancelled.${NC}"
    exit 0
fi

echo -e "${BLUE}[*] Removing files...${NC}"

# Remove installation directory
if [ -d "$INSTALL_DIR" ]; then
    sudo rm -rf "$INSTALL_DIR"
    echo -e "${GREEN}✅ Removed $INSTALL_DIR${NC}"
fi

# Remove launchers
for f in offensive-crab offensive-crab-check; do
    if [ -f "${BIN_DIR}/$f" ]; then
        sudo rm -f "${BIN_DIR}/$f"
        echo -e "${GREEN}✅ Removed $f${NC}"
    fi
done

# Remove desktop entry
if [ -f "/usr/share/applications/offensive-crab.desktop" ]; then
    sudo rm -f "/usr/share/applications/offensive-crab.desktop"
    echo -e "${GREEN}✅ Removed desktop entry${NC}"
fi

# Ask about config
read -p "$(echo -e ${YELLOW})Remove configuration and data? [y/N]: $(echo -e ${NC})" remove_config
if [[ "$remove_config" =~ ^[Yy]$ ]]; then
    if [ -d "$CONFIG_DIR" ]; then
        # Backup first
        BACKUP="${HOME}/offensive_crab_backup_$(date +%Y%m%d_%H%M%S).tar.gz"
        tar -czf "$BACKUP" -C "$(dirname "$CONFIG_DIR")" "$(basename "$CONFIG_DIR")" 2>/dev/null || true
        echo -e "${BLUE}[*] Backup saved to: $BACKUP${NC}"
        
        rm -rf "$CONFIG_DIR"
        echo -e "${GREEN}✅ Removed $CONFIG_DIR${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Configuration preserved at: $CONFIG_DIR${NC}"
fi

# Remove Docker images
if command -v docker &> /dev/null; then
    read -p "$(echo -e ${YELLOW})Remove Docker images? [y/N]: $(echo -e ${NC})" remove_docker
    if [[ "$remove_docker" =~ ^[Yy]$ ]]; then
        docker rmi offensive-crab-v1:latest 2>/dev/null || true
        docker rmi offensive-crab-v1:full 2>/dev/null || true
        docker rmi offensive-crab-v1:standalone 2>/dev/null || true
        echo -e "${GREEN}✅ Docker images removed${NC}"
    fi
fi

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════════════════╗"
echo -e "║        ✅ OFFENSIVE-CRAB-V1 Uninstalled Successfully                     ║"
echo -e "╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
