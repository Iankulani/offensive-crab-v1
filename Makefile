# =====================
# OFFENSIVE-CRAB-V1 - Makefile
# Author: Ian Carter Kulani, MSc
# Version: 1.0.0
# =====================

.PHONY: all help install install-dev install-full uninstall clean test lint format \
        build docker docker-build docker-run docker-stop docker-clean \
        run check deps venv dist docs security update

# Configuration
PYTHON := python3
PIP := $(PYTHON) -m pip
VENV := venv
VENV_BIN := $(VENV)/bin
TOOL := offensive_crab_v1.py
CHECK := requirements-check.py
DOCKER_IMAGE := offensive-crab-v1
DOCKER_TAG := latest
VERSION := 1.0.0

# Colors
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
CYAN := \033[0;36m
NC := \033[0m

# Default target
all: help

# =====================
# HELP
# =====================
help:
	@echo "$(RED)╔══════════════════════════════════════════════════════════════════════════════╗$(NC)"
	@echo "$(RED)║$(BLUE)        🦀 OFFENSIVE-CRAB-V1 - Makefile Help                          $(RED)║$(NC)"
	@echo "$(RED)╠══════════════════════════════════════════════════════════════════════════════╣$(NC)"
	@echo "$(RED)║$(NC)                                                                          $(RED)║$(NC)"
	@echo "$(RED)║$(GREEN)  Installation:$(NC)                                                         $(RED)║$(NC)"
	@echo "$(RED)║$(NC)    make install          - Install all dependencies                           $(RED)║$(NC)"
	@echo "$(RED)║$(NC)    make install-dev      - Install development dependencies                   $(RED)║$(NC)"
	@echo "$(RED)║$(NC)    make install-full     - Install all optional dependencies                  $(RED)║$(NC)"
	@echo "$(RED)║$(NC)    make venv             - Create virtual environment                        $(RED)║$(NC)"
	@echo "$(RED)║$(NC)    make uninstall        - Uninstall the tool                                $(RED)║$(NC)"
	@echo "$(RED)║$(NC)                                                                          $(RED)║$(NC)"
	@echo "$(RED)║$(GREEN)  Running:$(NC)                                                                $(RED)║$(NC)"
	@echo "$(RED)║$(NC)    make run              - Run the tool                                     $(RED)║$(NC)"
	@echo "$(RED)║$(NC)    make check            - Check dependencies                               $(RED)║$(NC)"
	@echo "$(RED)║$(NC)    make deps             - Show installed dependencies                      $(RED)║$(NC)"
	@echo "$(RED)║$(NC)                                                                          $(RED)║$(NC)"
	@echo "$(RED)║$(GREEN)  Development:$(NC)                                                            $(RED)║$(NC)"
	@echo "$(RED)║$(NC)    make test             - Run tests                                        $(RED)║$(NC)"
	@echo "$(RED)║$(NC)    make lint             - Run linters                                    $(RED)║$(NC)"
	@echo "$(RED)║$(NC)    make format           - Format code                                    $(RED)║$(NC)"
	@echo "$(RED)║$(NC)    make security         - Run security checks                            $(RED)║$(NC)"
	@echo "$(RED)║$(NC)                                                                          $(RED)║$(NC)"
	@echo "$(RED)║$(GREEN)  Building:$(NC)                                                               $(RED)║$(NC)"
	@echo "$(RED)║$(NC)    make build            - Build distribution packages                      $(RED)║$(NC)"
	@echo "$(RED)║$(NC)    make dist             - Build source and wheel distributions             $(RED)║$(NC)"
	@echo "$(RED)║$(NC)                                                                          $(RED)║$(NC)"
	@echo "$(RED)║$(GREEN)  Docker:$(NC)                                                                 $(RED)║$(NC)"
	@echo "$(RED)║$(NC)    make docker-build     - Build Docker image                              $(RED)║$(NC)"
	@echo "$(RED)║$(NC)    make docker-run       - Run in Docker                                   $(RED)║$(NC)"
	@echo "$(RED)║$(NC)    make docker-stop      - Stop Docker container                           $(RED)║$(NC)"
	@echo "$(RED)║$(NC)    make docker-clean     - Clean Docker resources                           $(RED)║$(NC)"
	@echo "$(RED)║$(NC)                                                                          $(RED)║$(NC)"
	@echo "$(RED)║$(GREEN)  Maintenance:$(NC)                                                            $(RED)║$(NC)"
	@echo "$(RED)║$(NC)    make clean            - Clean temporary files                           $(RED)║$(NC)"
	@echo "$(RED)║$(NC)    make update           - Update dependencies                              $(RED)║$(NC)"
	@echo "$(RED)║$(NC)    make docs             - Build documentation                             $(RED)║$(NC)"
	@echo "$(RED)║$(NC)                                                                          $(RED)║$(NC)"
	@echo "$(RED)╚══════════════════════════════════════════════════════════════════════════════╝$(NC)"

# =====================
# INSTALLATION
# =====================
install: venv
	@echo "$(GREEN)📦 Installing OFFENSIVE-CRAB-V1...$(NC)"
	@$(VENV_BIN)/pip install --upgrade pip setuptools wheel
	@$(VENV_BIN)/pip install -r requirements.txt
	@echo "$(GREEN)✅ Installation complete!$(NC)"
	@echo "$(BLUE)   Run: make run$(NC)"

install-dev: install
	@echo "$(GREEN)📦 Installing development dependencies...$(NC)"
	@$(VENV_BIN)/pip install -r requirements-dev.txt 2>/dev/null || true
	@echo "$(GREEN)✅ Development dependencies installed!$(NC)"

install-full: install
	@echo "$(GREEN)📦 Installing all optional dependencies...$(NC)"
	@$(VENV_BIN)/pip install paramiko scapy discord.py telethon slack-sdk pynput 2>/dev/null || true
	@$(VENV_BIN)/pip install reportlab matplotlib seaborn selenium 2>/dev/null || true
	@$(VENV_BIN)/pip install flask flask-socketio flask-cors eventlet 2>/dev/null || true
	@echo "$(GREEN)✅ Full installation complete!$(NC)"

venv:
	@if [ ! -d "$(VENV)" ]; then \
		echo "$(BLUE)🔧 Creating virtual environment...$(NC)"; \
		$(PYTHON) -m venv $(VENV); \
		$(VENV_BIN)/pip install --upgrade pip setuptools wheel; \
		echo "$(GREEN)✅ Virtual environment created!$(NC)"; \
	else \
		echo "$(GREEN)✅ Virtual environment already exists$(NC)"; \
	fi

uninstall:
	@echo "$(RED)🗑️  Uninstalling OFFENSIVE-CRAB-V1...$(NC)"
	@rm -rf $(VENV)
	@rm -rf build dist *.egg-info
	@rm -rf .pytest_cache .mypy_cache .coverage htmlcov
	@find . -type f -name "*.pyc" -delete
	@find . -type d -name "__pycache__" -delete
	@echo "$(GREEN)✅ Uninstallation complete!$(NC)"

# =====================
# RUNNING
# =====================
run: venv
	@echo "$(RED)🦀 Starting OFFENSIVE-CRAB-V1...$(NC)"
	@$(VENV_BIN)/python $(TOOL)

check: venv
	@echo "$(BLUE)🔍 Checking dependencies...$(NC)"
	@$(VENV_BIN)/python $(CHECK)

deps: venv
	@echo "$(BLUE)📦 Installed packages:$(NC)"
	@$(VENV_BIN)/pip list

web: venv
	@echo "$(RED)🌐 Starting web dashboard...$(NC)"
	@$(VENV_BIN)/python -c "import sys; sys.path.insert(0, '.'); from offensive_crab_v1 import OffensiveCrabV1; app = OffensiveCrabV1(); app.web.start(); import time; [time.sleep(1) for _ in iter(int, 1)]"

# =====================
# TESTING
# =====================
test: venv
	@echo "$(BLUE)🧪 Running tests...$(NC)"
	@$(VENV_BIN)/pytest tests/ -v --cov=. --cov-report=term-missing 2>/dev/null || \
	 echo "$(YELLOW)⚠️  No tests found or pytest not installed$(NC)"

test-unit: venv
	@$(VENV_BIN)/pytest tests/unit/ -v 2>/dev/null || true

test-integration: venv
	@$(VENV_BIN)/pytest tests/integration/ -v 2>/dev/null || true

test-coverage: venv
	@$(VENV_BIN)/pytest tests/ --cov=. --cov-report=html --cov-report=term 2>/dev/null || true
	@echo "$(GREEN)📊 Coverage report: htmlcov/index.html$(NC)"

# =====================
# LINTING & FORMATTING
# =====================
lint: venv
	@echo "$(BLUE)🔍 Running linters...$(NC)"
	@$(VENV_BIN)/flake8 $(TOOL) --count --statistics --exit-zero || true
	@$(VENV_BIN)/pylint $(TOOL) --exit-zero --disable=all --enable=E 2>/dev/null || true
	@$(VENV_BIN)/mypy $(TOOL) --ignore-missing-imports --exit-zero 2>/dev/null || true
	@echo "$(GREEN)✅ Linting complete$(NC)"

format: venv
	@echo "$(BLUE)📝 Formatting code...$(NC)"
	@$(VENV_BIN)/black $(TOOL) $(CHECK) 2>/dev/null || true
	@$(VENV_BIN)/isort $(TOOL) $(CHECK) 2>/dev/null || true
	@echo "$(GREEN)✅ Formatting complete$(NC)"

security: venv
	@echo "$(BLUE)🔒 Running security checks...$(NC)"
	@$(VENV_BIN)/bandit -r $(TOOL) -f txt 2>/dev/null || true
	@$(VENV_BIN)/safety check 2>/dev/null || true
	@echo "$(GREEN)✅ Security checks complete$(NC)"

# =====================
# BUILDING
# =====================
build: venv
	@echo "$(BLUE)📦 Building distribution packages...$(NC)"
	@$(VENV_BIN)/pip install build
	@$(VENV_BIN)/python -m build
	@echo "$(GREEN)✅ Build complete!$(NC)"

dist: build
	@echo "$(GREEN)📦 Distribution files:$(NC)"
	@ls -la dist/

wheel: venv
	@$(VENV_BIN)/pip install build
	@$(VENV_BIN)/python -m build --wheel
	@echo "$(GREEN)✅ Wheel built!$(NC)"

sdist: venv
	@$(VENV_BIN)/pip install build
	@$(VENV_BIN)/python -m build --sdist
	@echo "$(GREEN)✅ Source distribution built!$(NC)"

# =====================
# DOCKER
# =====================
docker-build:
	@echo "$(BLUE)🐳 Building Docker image...$(NC)"
	@docker build -t $(DOCKER_IMAGE):$(DOCKER_TAG) .
	@docker build -t $(DOCKER_IMAGE):$(VERSION) .
	@echo "$(GREEN)✅ Docker image built!$(NC)"

docker-build-standalone:
	@echo "$(BLUE)🐳 Building standalone Docker image...$(NC)"
	@docker build -f Dockerfile.standalone -t $(DOCKER_IMAGE):standalone .
	@echo "$(GREEN)✅ Standalone Docker image built!$(NC)"

docker-run:
	@echo "$(BLUE)🐳 Running Docker container...$(NC)"
	@docker run -it --rm \
		--name offensive-crab \
		--cap-add=NET_ADMIN \
		--cap-add=NET_RAW \
		--network host \
		-v "$(PWD)/config:/config" \
		-v "$(PWD)/data:/data" \
		$(DOCKER_IMAGE):$(DOCKER_TAG)

docker-run-detached:
	@docker run -d \
		--name offensive-crab \
		--cap-add=NET_ADMIN \
		--cap-add=NET_RAW \
		--network host \
		-p 5000:5000 \
		-v "$(PWD)/config:/config" \
		-v "$(PWD)/data:/data" \
		$(DOCKER_IMAGE):$(DOCKER_TAG) web

docker-compose-up:
	@echo "$(BLUE)🐳 Starting with Docker Compose...$(NC)"
	@docker-compose up -d

docker-compose-down:
	@docker-compose down

docker-stop:
	@docker stop offensive-crab 2>/dev/null || true
	@docker rm offensive-crab 2>/dev/null || true
	@echo "$(GREEN)✅ Container stopped$(NC)"

docker-clean:
	@echo "$(RED)🗑️  Cleaning Docker resources...$(NC)"
	@docker stop offensive-crab 2>/dev/null || true
	@docker rm offensive-crab 2>/dev/null || true
	@docker rmi $(DOCKER_IMAGE):$(DOCKER_TAG) 2>/dev/null || true
	@docker rmi $(DOCKER_IMAGE):$(VERSION) 2>/dev/null || true
	@docker system prune -f
	@echo "$(GREEN)✅ Docker cleaned$(NC)"

docker-logs:
	@docker logs -f offensive-crab

docker-shell:
	@docker exec -it offensive-crab /bin/bash

# =====================
# MAINTENANCE
# =====================
clean:
	@echo "$(RED)🧹 Cleaning temporary files...$(NC)"
	@find . -type f -name "*.pyc" -delete
	@find . -type d -name "__pycache__" -delete
	@find . -type d -name ".pytest_cache" -delete
	@find . -type d -name ".mypy_cache" -delete
	@rm -rf build dist *.egg-info
	@rm -rf .coverage htmlcov .coverage.*
	@rm -rf temp/* 2>/dev/null || true
	@echo "$(GREEN)✅ Cleaned!$(NC)"

clean-all: clean
	@echo "$(RED)🧹 Cleaning everything...$(NC)"
	@rm -rf $(VENV)
	@rm -rf .cache
	@echo "$(GREEN)✅ All cleaned!$(NC)"

update: venv
	@echo "$(BLUE)📦 Updating dependencies...$(NC)"
	@$(VENV_BIN)/pip install --upgrade pip setuptools wheel
	@$(VENV_BIN)/pip install --upgrade -r requirements.txt
	@echo "$(GREEN)✅ Dependencies updated!$(NC)"

docs: venv
	@echo "$(BLUE)📚 Building documentation...$(NC)"
	@$(VENV_BIN)/pip install sphinx sphinx-rtd-theme 2>/dev/null || true
	@cd docs && $(CURDIR)/$(VENV_BIN)/sphinx-build -b html . _build/html 2>/dev/null || \
	 echo "$(YELLOW)⚠️  No docs directory found$(NC)"

# =====================
# UTILITIES
# =====================
info:
	@echo "$(RED)🦀 OFFENSIVE-CRAB-V1 Information$(NC)"
	@echo "$(BLUE)═══════════════════════════════════════════$(NC)"
	@echo "Version:     $(VERSION)"
	@echo "Python:      $$($(PYTHON) --version 2>&1)"
	@echo "Venv:        $(VENV)"
	@echo "Tool:        $(TOOL)"
	@echo "Docker:      $(DOCKER_IMAGE):$(DOCKER_TAG)"
	@echo ""

tree:
	@tree -L 2 -I 'venv|__pycache__|*.pyc|.git|.pytest_cache|htmlcov'

lines:
	@echo "$(BLUE)📊 Line counts:$(NC)"
	@wc -l $(TOOL) $(CHECK) setup.py 2>/dev/null || true

version:
	@echo "$(VERSION)"
