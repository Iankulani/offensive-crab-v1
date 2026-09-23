#!/usr/bin/env python3
"""
OFFENSIVE-CRAB-V1 - Requirements Checker
Author: Ian Carter Kulani, MSc
Version: 1.0.0

Checks all dependencies and reports missing packages.
"""

import sys
import subprocess
import importlib
import shutil
import platform
import os
from pathlib import Path

# ANSI Colors
class Colors:
    RED = '\033[91m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    MAGENTA = '\033[95m'
    WHITE = '\033[97m'
    RESET = '\033[0m'
    BOLD = '\033[1m'
    DIM = '\033[2m'


def print_banner():
    banner = f"""
{Colors.RED}╔══════════════════════════════════════════════════════════════════════════════╗
║{Colors.BLUE}        🦀 OFFENSIVE-CRAB-V1 - Requirements Checker                     {Colors.RED}║
╠══════════════════════════════════════════════════════════════════════════════╣
║{Colors.CYAN}  Python Version: {sys.version.split()[0]:<58}{Colors.RED}║
║{Colors.CYAN}  Platform: {platform.system()} {platform.release():<50}{Colors.RED}║
║{Colors.CYAN}  Architecture: {platform.machine():<56}{Colors.RED}║
╚══════════════════════════════════════════════════════════════════════════════╝{Colors.RESET}
"""
    print(banner)


# Python package requirements
PYTHON_PACKAGES = {
    # Core
    'colorama': ('colorama', 'Terminal colors'),
    'requests': ('requests', 'HTTP library'),
    'psutil': ('psutil', 'System monitoring'),
    
    # Crypto
    'cryptography': ('cryptography', 'Cryptography'),
    
    # SSH
    'paramiko': ('paramiko', 'SSH client'),
    
    # Networking
    'scapy': ('scapy', 'Packet manipulation'),
    'dns': ('dnspython', 'DNS resolution'),
    
    # Web
    'flask': ('flask', 'Web framework'),
    'flask_socketio': ('flask-socketio', 'WebSocket support'),
    'flask_cors': ('flask-cors', 'CORS support'),
    'eventlet': ('eventlet', 'Async support'),
    
    # Platform bots
    'discord': ('discord.py', 'Discord bot'),
    'telethon': ('telethon', 'Telegram bot'),
    'slack_sdk': ('slack-sdk', 'Slack bot'),
    
    # Web automation
    'selenium': ('selenium', 'Browser automation'),
    'webdriver_manager': ('webdriver-manager', 'WebDriver manager'),
    
    # Keylogger
    'pynput': ('pynput', 'Keyboard/mouse control'),
    
    # Visualization
    'matplotlib': ('matplotlib', 'Plotting'),
    'seaborn': ('seaborn', 'Statistical plots'),
    'numpy': ('numpy', 'Numerical computing'),
    
    # PDF
    'reportlab': ('reportlab', 'PDF generation'),
    
    # Utilities
    'qrcode': ('qrcode', 'QR code generation'),
    'PIL': ('pillow', 'Image processing'),
    'pyshorteners': ('pyshorteners', 'URL shortening'),
    'bs4': ('beautifulsoup4', 'HTML parsing'),
    'lxml': ('lxml', 'XML/HTML parser'),
    'pyperclip': ('pyperclip', 'Clipboard access'),
    'pygetwindow': ('pygetwindow', 'Window management'),
    'pyautogui': ('pyautogui', 'GUI automation'),
    'whois': ('whois', 'WHOIS lookup'),
    'tabulate': ('tabulate', 'Table formatting'),
    'tqdm': ('tqdm', 'Progress bars'),
    'dotenv': ('python-dotenv', 'Environment variables'),
}

# System tools requirements
SYSTEM_TOOLS = {
    # Networking
    'ping': ('ping', 'Network connectivity', True),
    'nmap': ('nmap', 'Port scanning', False),
    'curl': ('curl', 'HTTP requests', True),
    'wget': ('wget', 'File downloads', True),
    'nc': ('netcat', 'Network connections', False),
    'ncat': ('ncat', 'Network connections (nmap)', False),
    'dig': ('dnsutils', 'DNS queries', False),
    'nslookup': ('dnsutils', 'DNS queries', False),
    'traceroute': ('traceroute', 'Network path tracing', False),
    'mtr': ('mtr-tiny', 'Network diagnostics', False),
    'ssh': ('openssh-client', 'SSH client', False),
    'ssh-keygen': ('openssh-client', 'SSH key generation', False),
    'sftp': ('openssh-client', 'SFTP client', False),
    'arp': ('net-tools', 'ARP table', True),
    
    # Security
    'nikto': ('nikto', 'Web vulnerability scanner', False),
    'hashcat': ('hashcat', 'Password cracking', False),
    'john': ('john', 'Password cracking', False),
    'hydra': ('hydra', 'Login cracking', False),
    'sqlmap': ('sqlmap', 'SQL injection', False),
    'metasploit': ('metasploit-framework', 'Exploitation', False),
    
    # Container
    'docker': ('docker.io', 'Containerization', False),
    
    # Messaging
    'signal-cli': ('signal-cli', 'Signal messaging', False),
    
    # Other
    'iptables': ('iptables', 'Firewall', False),
    'ufw': ('ufw', 'Firewall', False),
}


def check_python_version():
    """Check Python version"""
    version = sys.version_info
    if version.major < 3 or (version.major == 3 and version.minor < 7):
        print(f"{Colors.RED}❌ Python 3.7+ required. Current: {version.major}.{version.minor}{Colors.RESET}")
        return False
    print(f"{Colors.GREEN}✅ Python {version.major}.{version.minor}.{version.micro}{Colors.RESET}")
    return True


def check_python_package(import_name, package_name, description):
    """Check if a Python package is installed"""
    try:
        module = importlib.import_module(import_name)
        version = getattr(module, '__version__', 'unknown')
        print(f"{Colors.GREEN}  ✅ {package_name:<30} v{version:<15} {description}{Colors.RESET}")
        return True
    except ImportError:
        print(f"{Colors.RED}  ❌ {package_name:<30} {'MISSING':<15} {description}{Colors.RESET}")
        return False


def check_system_tool(tool_name, package_name, description, required=True):
    """Check if a system tool is available"""
    if shutil.which(tool_name):
        print(f"{Colors.GREEN}  ✅ {tool_name:<30} {'found':<15} {description}{Colors.RESET}")
        return True
    else:
        status = "REQUIRED" if required else "optional"
        color = Colors.RED if required else Colors.YELLOW
        print(f"{color}  ⚠️  {tool_name:<30} {status:<15} {description}{Colors.RESET}")
        return False


def check_pip():
    """Check pip availability"""
    try:
        result = subprocess.run([sys.executable, '-m', 'pip', '--version'],
                              capture_output=True, text=True)
        if result.returncode == 0:
            version = result.stdout.split()[1]
            print(f"{Colors.GREEN}✅ pip {version}{Colors.RESET}")
            return True
    except:
        pass
    print(f"{Colors.RED}❌ pip not available{Colors.RESET}")
    return False


def check_venv():
    """Check venv availability"""
    try:
        import venv
        print(f"{Colors.GREEN}✅ venv available{Colors.RESET}")
        return True
    except ImportError:
        print(f"{Colors.YELLOW}⚠️  venv not available{Colors.RESET}")
        return False


def get_install_command(packages):
    """Get the pip install command"""
    return f"{sys.executable} -m pip install {' '.join(packages)}"


def get_system_install_command(tools, os_name):
    """Get system package install command"""
    if os_name == 'linux':
        # Detect distro
        if os.path.exists('/etc/debian_version'):
            return f"sudo apt-get install -y {' '.join(tools)}"
        elif os.path.exists('/etc/redhat-release'):
            return f"sudo yum install -y {' '.join(tools)}"
        elif os.path.exists('/etc/arch-release'):
            return f"sudo pacman -S --noconfirm {' '.join(tools)}"
        elif os.path.exists('/etc/alpine-release'):
            return f"apk add {' '.join(tools)}"
    elif os_name == 'darwin':
        return f"brew install {' '.join(tools)}"
    elif os_name == 'windows':
        return f"winget install {' '.join(tools)}"
    return f"# Install manually: {' '.join(tools)}"


def main():
    print_banner()
    
    os_name = platform.system().lower()
    missing_python = []
    missing_system = []
    missing_system_optional = []
    
    # Check Python version
    print(f"\n{Colors.BOLD}{Colors.BLUE}🐍 Python Environment:{Colors.RESET}")
    python_ok = check_python_version()
    pip_ok = check_pip()
    venv_ok = check_venv()
    
    if not python_ok:
        print(f"\n{Colors.RED}❌ Python version not supported. Please upgrade Python.{Colors.RESET}")
        sys.exit(1)
    
    # Check Python packages
    print(f"\n{Colors.BOLD}{Colors.BLUE}📦 Python Packages:{Colors.RESET}")
    for import_name, (package_name, description) in PYTHON_PACKAGES.items():
        if not check_python_package(import_name, package_name, description):
            missing_python.append(package_name)
    
    # Check system tools
    print(f"\n{Colors.BOLD}{Colors.BLUE}🔧 System Tools:{Colors.RESET}")
    for tool_name, (package_name, description, required) in SYSTEM_TOOLS.items():
        if not check_system_tool(tool_name, package_name, description, required):
            if required:
                missing_system.append(package_name)
            else:
                missing_system_optional.append(package_name)
    
    # Summary
    print(f"\n{Colors.BOLD}{Colors.BLUE}{'='*70}{Colors.RESET}")
    print(f"{Colors.BOLD}{Colors.BLUE}📊 SUMMARY{Colors.RESET}")
    print(f"{Colors.BOLD}{Colors.BLUE}{'='*70}{Colors.RESET}")
    
    total_python = len(PYTHON_PACKAGES)
    installed_python = total_python - len(missing_python)
    
    print(f"\n{Colors.CYAN}Python Packages: {installed_python}/{total_python} installed{Colors.RESET}")
    
    if missing_python:
        print(f"\n{Colors.RED}❌ Missing Python packages ({len(missing_python)}):{Colors.RESET}")
        for pkg in missing_python:
            print(f"   • {pkg}")
        
        print(f"\n{Colors.YELLOW}💡 Install missing packages with:{Colors.RESET}")
        print(f"{Colors.WHITE}{get_install_command(missing_python)}{Colors.RESET}")
        
        # Also suggest pip install -r requirements.txt
        print(f"\n{Colors.YELLOW}💡 Or install all from requirements.txt:{Colors.RESET}")
        print(f"{Colors.WHITE}{sys.executable} -m pip install -r requirements.txt{Colors.RESET}")
    else:
        print(f"{Colors.GREEN}✅ All Python packages installed!{Colors.RESET}")
    
    if missing_system:
        print(f"\n{Colors.RED}❌ Missing required system tools ({len(missing_system)}):{Colors.RESET}")
        for tool in missing_system:
            print(f"   • {tool}")
        
        print(f"\n{Colors.YELLOW}💡 Install missing tools with:{Colors.RESET}")
        print(f"{Colors.WHITE}{get_system_install_command(missing_system, os_name)}{Colors.RESET}")
    else:
        print(f"{Colors.GREEN}✅ All required system tools installed!{Colors.RESET}")
    
    if missing_system_optional:
        print(f"\n{Colors.YELLOW}⚠️  Missing optional system tools ({len(missing_system_optional)}):{Colors.RESET}")
        for tool in missing_system_optional:
            print(f"   • {tool}")
        print(f"\n{Colors.DIM}   These are optional but recommended for full functionality.{Colors.RESET}")
    
    # Overall status
    print(f"\n{Colors.BOLD}{Colors.BLUE}{'='*70}{Colors.RESET}")
    if not missing_python and not missing_system:
        print(f"{Colors.GREEN}{Colors.BOLD}✅ ALL REQUIREMENTS SATISFIED!{Colors.RESET}")
        print(f"{Colors.GREEN}   You can run: python offensive_crab_v1.py{Colors.RESET}")
    else:
        print(f"{Colors.YELLOW}{Colors.BOLD}⚠️  SOME REQUIREMENTS MISSING{Colors.RESET}")
        print(f"{Colors.YELLOW}   Install missing packages and run this check again.{Colors.RESET}")
    
    print(f"{Colors.BOLD}{Colors.BLUE}{'='*70}{Colors.RESET}\n")
    
    # Return exit code
    return 0 if (not missing_python and not missing_system) else 1


if __name__ == "__main__":
    sys.exit(main())
