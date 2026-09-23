
# offensive-crab-v1

Offensive crab# Install system dependencies (Debian/Ubuntu)
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



# How to clone the repo

```bash

git clone https://github.com/Iankulani/offensive-crab-v1.git
cd offensive-crab-v1
```

# How to run
```bash
python3 


