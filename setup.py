#!/usr/bin/env python3
"""
OFFENSIVE-CRAB-V1 - Python Package Setup
Author: Ian Carter Kulani, MSc
Version: 1.0.0
"""

from setuptools import setup, find_packages
from pathlib import Path
import os
import sys

# Ensure Python 3.7+
if sys.version_info < (3, 7):
    sys.exit("Python 3.7 or higher is required.")

# Read README
readme_path = Path(__file__).parent / "README.md"
long_description = ""
if readme_path.exists():
    long_description = readme_path.read_text(encoding="utf-8")

# Read requirements
requirements_path = Path(__file__).parent / "requirements.txt"
requirements = []
if requirements_path.exists():
    with open(requirements_path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith("#") and not line.startswith("-"):
                requirements.append(line)

# Read dev requirements
dev_requirements_path = Path(__file__).parent / "requirements-dev.txt"
dev_requirements = []
if dev_requirements_path.exists():
    with open(dev_requirements_path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith("#") and not line.startswith("-"):
                dev_requirements.append(line)

setup(
    name="offensive-crab-v1",
    version="1.0.0",
    author="Ian Carter Kulani, MSc",
    author_email="ian.kulani@offensive-crab.dev",
    description="🦀 Ultimate Cybersecurity Command & Control Platform",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/iankulani/offensive-crab-v1",
    project_urls={
        "Bug Tracker": "https://github.com/iankulani/offensive-crab-v1/issues",
        "Documentation": "https://github.com/iankulani/offensive-crab-v1/wiki",
        "Source Code": "https://github.com/iankulani/offensive-crab-v1",
    },
    license="MIT",
    
    # Package configuration
    py_modules=["offensive_crab_v1"],
    packages=find_packages(exclude=["tests", "tests.*", "docs", "scripts"]),
    
    # Python version
    python_requires=">=3.7",
    
    # Dependencies
    install_requires=requirements,
    extras_require={
        "dev": dev_requirements,
        "full": [
            "paramiko>=3.4.0",
            "scapy>=2.5.0",
            "discord.py>=2.3.0",
            "telethon>=1.34.0",
            "slack-sdk>=3.26.0",
            "pynput>=1.7.6",
            "reportlab>=4.0.0",
            "matplotlib>=3.8.0",
            "seaborn>=0.13.0",
            "selenium>=4.15.0",
        ],
        "web": [
            "flask>=3.0.0",
            "flask-socketio>=5.3.0",
            "flask-cors>=4.0.0",
            "eventlet>=0.35.0",
        ],
        "bots": [
            "discord.py>=2.3.0",
            "telethon>=1.34.0",
            "slack-sdk>=3.26.0",
        ],
        "security": [
            "cryptography>=41.0.0",
            "paramiko>=3.4.0",
            "scapy>=2.5.0",
            "pynput>=1.7.6",
        ],
    },
    
    # Entry points
    entry_points={
        "console_scripts": [
            "offensive-crab=offensive_crab_v1:main",
            "offensive-crab-check=requirements_check:main",
            "offensive-crab-health=healthcheck:main",
        ],
    },
    
    # Classifiers
    classifiers=[
        "Development Status :: 4 - Beta",
        "Intended Audience :: Information Technology",
        "Intended Audience :: System Administrators",
        "Intended Audience :: Telecommunications Industry",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
        "Operating System :: POSIX :: Linux",
        "Operating System :: MacOS",
        "Operating System :: Microsoft :: Windows",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.7",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "Programming Language :: Python :: 3.12",
        "Topic :: Security",
        "Topic :: System :: Networking",
        "Topic :: System :: Networking :: Monitoring",
        "Topic :: System :: Systems Administration",
        "Topic :: Utilities",
        "Environment :: Console",
        "Environment :: Web Environment",
    ],
    
    # Keywords
    keywords=[
        "cybersecurity", "penetration-testing", "security", "hacking",
        "network", "scanner", "nmap", "phishing", "keylogger", "pentest",
        "red-team", "blue-team", "soc", "threat-detection", "vulnerability",
        "cracking", "arp-spoofing", "ddos", "botnet", "c2", "command-control"
    ],
    
    # Package data
    include_package_data=True,
    package_data={
        "": ["*.txt", "*.md", "*.json", "*.yml", "*.yaml", "*.cfg", "*.ini"],
    },
    data_files=[
        ("share/offensive-crab", ["requirements.txt", "README.md", "LICENSE"]),
    ],
    
    # Zip safe
    zip_safe=False,
    
    # Platforms
    platforms=["any"],
)
