#!/usr/bin/env python3
"""
OFFENSIVE-CRAB-V1 - Health Check Script
Author: Ian Carter Kulani, MSc
Version: 1.0.0

Checks the health and status of the OFFENSIVE-CRAB-V1 installation.
"""

import os
import sys
import json
import socket
import platform
import subprocess
import shutil
import importlib
from pathlib import Path
from datetime import datetime


class HealthCheck:
    def __init__(self):
        self.checks = []
        self.config_dir = Path(os.environ.get(
            'OFFENSIVE_CRAB_CONFIG',
            Path.home() / '.offensive_crab_v1'
        ))
        self.app_dir = Path(os.environ.get(
            'OFFENSIVE_CRAB_HOME',
            Path(__file__).parent
        ))
    
    def check_python(self):
        """Check Python version"""
        version = sys.version_info
        if version.major >= 3 and version.minor >= 7:
            return True, f"Python {version.major}.{version.minor}.{version.micro}"
        return False, f"Python {version.major}.{version.minor} (need 3.7+)"
    
    def check_module(self, module_name, package_name=None):
        """Check if a module can be imported"""
        try:
            importlib.import_module(module_name)
            return True, package_name or module_name
        except ImportError:
            return False, package_name or module_name
    
    def check_config(self):
        """Check configuration directory"""
        if self.config_dir.exists():
            if (self.config_dir / "config.json").exists():
                return True, f"Config found at {self.config_dir}"
            return False, f"Config dir exists but no config.json"
        return False, f"Config dir missing: {self.config_dir}"
    
    def check_disk(self):
        """Check disk space"""
        try:
            stat = shutil.disk_usage(self.app_dir)
            free_gb = stat.free / (1024**3)
            if free_gb > 1:
                return True, f"{free_gb:.1f}GB free"
            return False, f"Low disk space: {free_gb:.1f}GB"
        except Exception as e:
            return False, str(e)
    
    def check_network(self):
        """Check network connectivity"""
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.settimeout(3)
            result = sock.connect_ex(('8.8.8.8', 53))
            sock.close()
            if result == 0:
                return True, "Network OK"
            return False, "No internet"
        except:
            return False, "Network error"
    
    def check_port(self, port):
        """Check if a port is available"""
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            result = sock.connect_ex(('127.0.0.1', port))
            sock.close()
            return result != 0, f"Port {port}"
        except:
            return False, f"Port {port}"
    
    def check_web_server(self):
        """Check if web server is running"""
        return self.check_port(5000)
    
    def run_all(self):
        """Run all health checks"""
        print("=" * 60)
        print("OFFENSIVE-CRAB-V1 Health Check")
        print("=" * 60)
        print(f"Time: {datetime.now().isoformat()}")
        print(f"App Dir: {self.app_dir}")
        print(f"Config Dir: {self.config_dir}")
        print("=" * 60)
        print()
        
        results = []
        
        # Python check
        ok, msg = self.check_python()
        results.append(('Python', ok, msg))
        
        # Core modules
        modules = [
            ('colorama', 'colorama'),
            ('requests', 'requests'),
            ('psutil', 'psutil'),
            ('flask', 'flask'),
            ('paramiko', 'paramiko'),
            ('scapy', 'scapy'),
            ('pynput', 'pynput'),
            ('reportlab', 'reportlab'),
            ('matplotlib', 'matplotlib'),
            ('discord', 'discord.py'),
            ('telethon', 'telethon'),
        ]
        
        for mod, pkg in modules:
            ok, msg = self.check_module(mod, pkg)
            results.append((f'Module: {pkg}', ok, msg))
        
        # Config check
        ok, msg = self.check_config()
        results.append(('Configuration', ok, msg))
        
        # Disk check
        ok, msg = self.check_disk()
        results.append(('Disk Space', ok, msg))
        
        # Network check
        ok, msg = self.check_network()
        results.append(('Network', ok, msg))
        
        # Web server check
        ok, msg = self.check_web_server()
        results.append(('Web Server', ok, msg))
        
        # System tools
        tools = ['ping', 'nmap', 'curl', 'wget', 'nc', 'ssh', 'dig', 'traceroute']
        for tool in tools:
            ok = shutil.which(tool) is not None
            results.append((f'Tool: {tool}', ok, tool if ok else 'not found'))
        
        # Print results
        passed = 0
        failed = 0
        
        for name, ok, msg in results:
            status = "✅" if ok else "❌"
            color = "\033[92m" if ok else "\033[91m"
            reset = "\033[0m"
            print(f"{color}{status}{reset} {name:<30} {msg}")
            
            if ok:
                passed += 1
            else:
                failed += 1
        
        print()
        print("=" * 60)
        print(f"Results: {passed} passed, {failed} failed")
        print("=" * 60)
        
        # Overall status
        # Critical: Python, config, at least core modules
        critical_ok = (
            self.check_python()[0] and
            self.check_config()[0]
        )
        
        if critical_ok and failed <= 5:
            print("\033[92m✅ Health check PASSED\033[0m")
            return 0
        else:
            print("\033[91m❌ Health check FAILED\033[0m")
            return 1


def main():
    """Main entry point"""
    import argparse
    
    parser = argparse.ArgumentParser(
        description='OFFENSIVE-CRAB-V1 Health Check'
    )
    parser.add_argument(
        '--json', '-j',
        action='store_true',
        help='Output as JSON'
    )
    parser.add_argument(
        '--quiet', '-q',
        action='store_true',
        help='Quiet mode (exit code only)'
    )
    
    args = parser.parse_args()
    
    checker = HealthCheck()
    
    if args.quiet:
        sys.exit(checker.run_all() if not args.json else 0)
    elif args.json:
        # JSON output mode
        results = {
            'timestamp': datetime.now().isoformat(),
            'python': checker.check_python()[0],
            'config': checker.check_config()[0],
            'network': checker.check_network()[0],
            'disk': checker.check_disk()[0],
        }
        print(json.dumps(results, indent=2))
        sys.exit(0 if all(results.values()) else 1)
    else:
        sys.exit(checker.run_all())


if __name__ == '__main__':
    main()
