
# offensive-crab-v1

<img width="360" height="360" alt="crabx" src="https://github.com/user-attachments/assets/d9e06d13-2043-4596-a27a-286a980f1b92" />


Offensive crab

# Install system dependencies (Debian/Ubuntu)
```bash
sudo apt-get update
sudo apt-get install -y python3 python3-pip python3-venv \
    build-essential libssl-dev libffi-dev python3-dev \
    libpcap-dev libnetfilter-queue-dev libxml2-dev \
    libxslt1-dev zlib1g-dev libjpeg-dev libpng-dev \
    libfreetype6-dev pkg-config git curl wget \
    net-tools dnsutils traceroute iputils-ping \
    netcat-openbsd nmap whois openssh-client \
    iptables tcpdump
```

# Create virtual environment
```bash
python3 -m venv venv
source venv/bin/activate
```

# Upgrade pip
```bash
pip install --upgrade pip setuptools wheel
```

# Install Python dependencies
```bash
pip install -r requirements.txt
```

# Install the tool
```bash
pip install -e .
```

# Run
```bash
python3 offensive_crab_v1.py

```
# Windows
Automated Installation
Download the repository

Right-click install.bat and select Run as Administrator

Follow the prompts

Manual Installation

# Install Python 3.11+ from https://python.org

# Clone repository
git clone https://github.com/iankulani/offensive-crab-v1.git
cd offensive-crab-v1

# Create virtual environment
python -m venv venv
.\venv\Scripts\activate

# Upgrade pip
python -m pip install --upgrade pip setuptools wheel

# Install dependencies
```bash
pip install -r requirements.txt
```
           
# Install the tool
```bash
pip install -e .
```

# Run
```bash
python offensive_crab_v1.py
