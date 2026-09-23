#!/usr/bin/env bash
# =====================
# OFFENSIVE-CRAB-V1 - Bash Installation Script
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
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m'
BOLD='\033[1m'

# Configuration
TOOL_NAME="OFFENSIVE-CRAB-V1"
TOOL_VERSION="1.0.0"
INSTALL_DIR="/opt/offensive-crab-v1"
VENV_DIR="${INSTALL_DIR}/venv"
CONFIG_DIR="${HOME}/.offensive_crab_v1"
BIN_DIR="/usr/local/bin"
LOG_FILE="/tmp/offensive_crab_install.log"

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/debian_version ]; then
            OS="debian"
            PKG_MGR="apt-get"
            PKG_UPDATE="apt-get update"
            PKG_INSTALL="apt-get install -y"
        elif [ -f /etc/redhat-release ]; then
            OS="redhat"
            PKG_MGR="yum"
            PKG_UPDATE="yum check-update || true"
            PKG_INSTALL="yum install -y"
        elif [ -f /etc/arch-release ]; then
            OS="arch"
            PKG_MGR="pacman"
            PKG_UPDATE="pacman -Sy"
            PKG_INSTALL="pacman -S --noconfirm"
        elif [ -f /etc/alpine-release ]; then
            OS="alpine"
            PKG_MGR="apk"
            PKG_UPDATE="apk update"
            PKG_INSTALL="apk add"
        else
            OS="linux"
            PKG_MGR="unknown"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        PKG_MGR="brew"
        PKG_UPDATE="brew update"
        PKG_INSTALL="brew install"
    else
        OS="unknown"
    fi
    echo -e "${GREEN}✅ Detected OS: ${OS}${NC}"
}

# Print banner
print_banner() {
    clear
    echo -e "${RED}"
    cat << "EOF"
╔══════════════════════════════════════════════════════════════════════════════╗
║        🦀 OFFENSIVE-CRAB-V1 - Installation Script                       ║
║               Cybersecurity Command & Control Platform                  ║
╠══════════════════════════════════════════════════════════════════════════════╣
║  Author: Ian Carter Kulani, MSc                                          ║
║  Version: 1.0.0                                                           ║
║                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Log function
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

# Error handler
error_exit() {
    echo -e "${RED}❌ ERROR: $1${NC}" | tee -a "$LOG_FILE"
    exit 1
}

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        echo -e "${YELLOW}⚠️  Running as root. This is not recommended for security.${NC}"
        SUDO=""
    else
        SUDO="sudo"
        if ! command -v sudo &> /dev/null; then
            error_exit "sudo is required but not installed."
        fi
    fi
}

# Check Python
check_python() {
    log "Checking Python installation..."
    
    if command -v python3 &> /dev/null; then
        PYTHON_CMD="python3"
        PYTHON_VERSION=$($PYTHON_CMD --version 2>&1 | awk '{print $2}')
        log "Found Python ${PYTHON_VERSION}"
    elif command -v python &> /dev/null; then
        PYTHON_CMD="python"
        PYTHON_VERSION=$($PYTHON_CMD --version 2>&1 | awk '{print $2}')
        log "Found Python ${PYTHON_VERSION}"
    else
        log "Python not found. Installing..."
        install_python
    fi
    
    # Check version
    if ! $PYTHON_CMD -c "import sys; sys.exit(0 if sys.version_info >= (3, 7) else 1)"; then
        error_exit "Python 3.7+ required. Found: ${PYTHON_VERSION}"
    fi
    
    log "✅ Python ${PYTHON_VERSION} is compatible"
}

# Install Python
install_python() {
    case $OS in
        debian)
            $SUDO $PKG_UPDATE
            $SUDO $PKG_INSTALL python3 python3-pip python3-venv python3-dev
            ;;
        redhat)
            $SUDO $PKG_INSTALL python3 python3-pip python3-devel
            ;;
        arch)
            $SUDO $PKG_INSTALL python python-pip
            ;;
        alpine)
            $SUDO $PKG_INSTALL python3 py3-pip python3-dev
            ;;
        macos)
            $PKG_INSTALL python3
            ;;
        *)
            error_exit "Cannot install Python on ${OS}. Please install manually."
            ;;
    esac
    PYTHON_CMD="python3"
}

# Install system dependencies
install_system_deps() {
    log "Installing system dependencies..."
    
    case $OS in
        debian)
            $SUDO $PKG_UPDATE
            $SUDO $PKG_INSTALL \
                build-essential \
                libssl-dev \
                libffi-dev \
                python3-dev \
                libpcap-dev \
                libnetfilter-queue-dev \
                libxml2-dev \
                libxslt1-dev \
                zlib1g-dev \
                libjpeg-dev \
                libpng-dev \
                libfreetype6-dev \
                pkg-config \
                git \
                curl \
                wget \
                net-tools \
                dnsutils \
                traceroute \
                iputils-ping \
                netcat-openbsd \
                nmap \
                whois \
                openssh-client \
                iptables \
                tcpdump \
                arp-scan \
                macchanger \
                nikto \
                hashcat \
                john \
                sqlmap \
                hydra \
                || log "⚠️  Some packages may have failed to install"
            ;;
        redhat)
            $SUDO $PKG_INSTALL \
                gcc \
                gcc-c++ \
                openssl-devel \
                libffi-devel \
                python3-devel \
                libpcap-devel \
                libxml2-devel \
                libxslt-devel \
                zlib-devel \
                libjpeg-turbo-devel \
                libpng-devel \
                freetype-devel \
                git \
                curl \
                wget \
                net-tools \
                bind-utils \
                traceroute \
                iputils \
                nmap \
                whois \
                openssh-clients \
                iptables \
                tcpdump \
                || log "⚠️  Some packages may have failed to install"
            ;;
        arch)
            $SUDO $PKG_INSTALL \
                base-devel \
                openssl \
                libffi \
                python \
                libpcap \
                libxml2 \
                libxslt \
                zlib \
                libjpeg-turbo \
                libpng \
                freetype2 \
                git \
                curl \
                wget \
                net-tools \
                bind \
                traceroute \
                iputils \
                nmap \
                whois \
                openssh \
                iptables \
                tcpdump \
                || log "⚠️  Some packages may have failed to install"
            ;;
        alpine)
            $SUDO $PKG_INSTALL \
                build-base \
                openssl-dev \
                libffi-dev \
                python3-dev \
                libpcap-dev \
                libxml2-dev \
                libxslt-dev \
                zlib-dev \
                jpeg-dev \
                libpng-dev \
                freetype-dev \
                git \
                curl \
                wget \
                net-tools \
                bind-tools \
                traceroute \
                iputils \
                nmap \
                whois \
                openssh-client \
                iptables \
                tcpdump \
                || log "⚠️  Some packages may have failed to install"
            ;;
        macos)
            $PKG_INSTALL \
                openssl \
                libffi \
                libpcap \
                libxml2 \
                libxslt \
                zlib \
                jpeg \
                libpng \
                freetype \
                git \
                curl \
                wget \
                nmap \
                whois \
                openssh \
                || log "⚠️  Some packages may have failed to install"
            ;;
        *)
            log "⚠️  Unknown OS. Please install dependencies manually."
            ;;
    esac
    
    log "✅ System dependencies installed"
}

# Install optional tools
install_optional_tools() {
    log "Installing optional security tools..."
    
    case $OS in
        debian)
            $SUDO $PKG_INSTALL \
                metasploit-framework \
                aircrack-ng \
                wireshark \
                ettercap-text-only \
                dsniff \
                hping3 \
                slowhttptest \
                siege \
                apache2-utils \
                || log "⚠️  Some optional tools failed to install"
            ;;
        redhat)
            $SUDO $PKG_INSTALL \
                aircrack-ng \
                wireshark \
                hping3 \
                httpd-tools \
                || log "⚠️  Some optional tools failed to install"
            ;;
        arch)
            $SUDO $PKG_INSTALL \
                metasploit \
                aircrack-ng \
                wireshark-qt \
                ettercap \
                dsniff \
                hping \
                || log "⚠️  Some optional tools failed to install"
            ;;
        macos)
            $PKG_INSTALL \
                hping \
                aircrack-ng \
                || log "⚠️  Some optional tools failed to install"
            ;;
    esac
    
    log "✅ Optional tools installation complete"
}

# Setup installation directory
setup_install_dir() {
    log "Setting up installation directory: ${INSTALL_DIR}"
    
    if [ -d "$INSTALL_DIR" ]; then
        log "Directory exists. Updating..."
    else
        $SUDO mkdir -p "$INSTALL_DIR"
    fi
    
    $SUDO chown -R $(whoami):$(whoami) "$INSTALL_DIR" 2>/dev/null || true
    
    # Copy tool files
    if [ -f "offensive_crab_v1.py" ]; then
        cp offensive_crab_v1.py "$INSTALL_DIR/"
    else
        error_exit "offensive_crab_v1.py not found in current directory"
    fi
    
    # Copy requirements
    for file in requirements.txt requirements-dev.txt requirements-check.py healthcheck.py setup.py; do
        if [ -f "$file" ]; then
            cp "$file" "$INSTALL_DIR/"
        fi
    done
    
    # Copy README and LICENSE
    for file in README.md LICENSE; do
        if [ -f "$file" ]; then
            cp "$file" "$INSTALL_DIR/"
        fi
    done
    
    log "✅ Installation directory ready"
}

# Create virtual environment
create_venv() {
    log "Creating virtual environment..."
    
    if [ -d "$VENV_DIR" ]; then
        log "Virtual environment exists. Recreating..."
        rm -rf "$VENV_DIR"
    fi
    
    $PYTHON_CMD -m venv "$VENV_DIR"
    
    # Activate venv
    source "${VENV_DIR}/bin/activate"
    
    # Upgrade pip
    pip install --upgrade pip setuptools wheel
    
    log "✅ Virtual environment created"
}

# Install Python dependencies
install_python_deps() {
    log "Installing Python dependencies..."
    
    source "${VENV_DIR}/bin/activate"
    
    if [ -f "${INSTALL_DIR}/requirements.txt" ]; then
        pip install -r "${INSTALL_DIR}/requirements.txt" || {
            log "⚠️  Some packages failed. Trying individual installs..."
            while IFS= read -r line; do
                [[ "$line" =~ ^#.*$ ]] && continue
                [[ -z "$line" ]] && continue
                [[ "$line" =~ ^-.*$ ]] && continue
                pkg=$(echo "$line" | sed 's/[<>=].*//' | tr -d ' ')
                pip install "$line" 2>/dev/null || log "⚠️  Failed: $pkg"
            done < "${INSTALL_DIR}/requirements.txt"
        }
    fi
    
    # Install the package itself
    if [ -f "${INSTALL_DIR}/setup.py" ]; then
        pip install -e "$INSTALL_DIR" 2>/dev/null || true
    fi
    
    log "✅ Python dependencies installed"
}

# Create configuration
create_config() {
    log "Creating configuration..."
    
    mkdir -p "$CONFIG_DIR"
    
    if [ ! -f "${CONFIG_DIR}/config.json" ]; then
        cat > "${CONFIG_DIR}/config.json" << 'EOF'
{
    "version": "1.0.0",
    "auto_start": false,
    "auto_block_enabled": false,
    "auto_block_threshold": 5,
    "scan_timeout": 30,
    "report_format": "pdf",
    "generate_graphics": true,
    "threat_monitor": {
        "enabled": true,
        "interval": 300,
        "targets": [],
        "scan_types": ["quick", "vuln"],
        "auto_block": false,
        "block_threshold": "high",
        "report_enabled": true,
        "report_interval": 3600
    },
    "keylogger": {
        "enabled": false,
        "hotkey": "f10",
        "log_file": "~/.offensive_crab_v1/keylog.txt",
        "c2_server": "",
        "upload_interval": 30,
        "exfil_methods": ["file", "email", "c2"],
        "screenshot_interval": 60,
        "capture_clipboard": true
    },
    "web": {
        "enabled": true,
        "port": 5000,
        "host": "0.0.0.0",
        "secret_key": "",
        "require_auth": false,
        "username": "admin",
        "password_hash": ""
    }
}
EOF
        log "✅ Default configuration created"
    else
        log "✅ Configuration already exists"
    fi
}

# Create launcher script
create_launcher() {
    log "Creating launcher script..."
    
    LAUNCHER="${BIN_DIR}/offensive-crab"
    
    cat > "/tmp/offensive-crab-launcher" << EOF
#!/usr/bin/env bash
# OFFENSIVE-CRAB-V1 Launcher
export OFFENSIVE_CRAB_HOME="${INSTALL_DIR}"
source "${VENV_DIR}/bin/activate"
cd "${INSTALL_DIR}"
exec python3 "${INSTALL_DIR}/offensive_crab_v1.py" "\$@"
EOF
    
    $SUDO cp "/tmp/offensive-crab-launcher" "$LAUNCHER"
    $SUDO chmod +x "$LAUNCHER"
    rm -f "/tmp/offensive-crab-launcher"
    
    # Create check launcher
    cat > "/tmp/offensive-crab-check-launcher" << EOF
#!/usr/bin/env bash
export OFFENSIVE_CRAB_HOME="${INSTALL_DIR}"
source "${VENV_DIR}/bin/activate"
exec python3 "${INSTALL_DIR}/requirements-check.py" "\$@"
EOF
    
    $SUDO cp "/tmp/offensive-crab-check-launcher" "${BIN_DIR}/offensive-crab-check"
    $SUDO chmod +x "${BIN_DIR}/offensive-crab-check"
    rm -f "/tmp/offensive-crab-check-launcher"
    
    log "✅ Launcher scripts created"
}

# Setup desktop entry
create_desktop_entry() {
    if [ "$OS" == "linux" ] && [ -d "/usr/share/applications" ]; then
        log "Creating desktop entry..."
        
        cat > "/tmp/offensive-crab.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=OFFENSIVE-CRAB-V1
Comment=Ultimate Cybersecurity Command & Control Platform
Exec=x-terminal-emulator -e ${BIN_DIR}/offensive-crab
Icon=utilities-terminal
Terminal=true
Categories=Security;Network;Development;
Keywords=security;hacking;pentest;network;
EOF
        
        $SUDO cp "/tmp/offensive-crab.desktop" "/usr/share/applications/"
        rm -f "/tmp/offensive-crab.desktop"
        
        log "✅ Desktop entry created"
    fi
}

# Verify installation
verify_installation() {
    log "Verifying installation..."
    
    source "${VENV_DIR}/bin/activate"
    
    if $PYTHON_CMD -c "import sys; sys.path.insert(0, '${INSTALL_DIR}'); import offensive_crab_v1; print('OK')" 2>/dev/null | grep -q "OK"; then
        log "✅ Main module imports successfully"
    else
        log "⚠️  Main module import test failed (may need dependencies)"
    fi
    
    if command -v offensive-crab &> /dev/null; then
        log "✅ Launcher available"
    else
        log "⚠️  Launcher not in PATH"
    fi
    
    log "✅ Installation verified"
}

# Print completion
print_completion() {
    echo -e "${GREEN}"
    cat << "EOF"
╔══════════════════════════════════════════════════════════════════════════════╗
║        ✅ OFFENSIVE-CRAB-V1 Installation Complete!                       ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                          ║
║  🚀 Run the tool:    offensive-crab                                      ║
║  🔍 Check deps:      offensive-crab-check                                ║
║  📁 Install dir:     /opt/offensive-crab-v1                              ║
║  ⚙️  Config dir:      ~/.offensive_crab_v1                                ║
║  📝 Log file:        /tmp/offensive_crab_install.log                    ║
║                                                                          ║
║  💡 First run will prompt for configuration                              ║
║  💡 Use 'sudo offensive-crab' for full functionality                     ║
║                                                                          ║
║  ⚠️  FOR AUTHORIZED SECURITY TESTING ONLY                                ║
║                                                                          ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Main installation
main() {
    print_banner
    check_root
    detect_os
    check_python
    
    log "Starting installation..."
    
    # Ask user for options
    read -p "$(echo -e ${BLUE})"Install optional security tools (nikto, hashcat, john, etc.)? [y/N]: "$(echo -e ${NC})" install_optional
    
    install_system_deps
    
    if [[ "$install_optional" =~ ^[Yy]$ ]]; then
        install_optional_tools
    fi
    
    setup_install_dir
    create_venv
    install_python_deps
    create_config
    create_launcher
    create_desktop_entry
    verify_installation
    print_completion
}

# Run
main "$@"
