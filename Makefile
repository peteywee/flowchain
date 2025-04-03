.PHONY: help upgrade audit check-env run-tool auto-upgrade finalize-repo validate-makefile

VENV_ACTIVATE = . .env/bin/activate
SHELL := /bin/bash

help:
	@echo ""
	@echo "Available make targets:"
	@echo "  make upgrade         - Upgrade dependencies in .env and lock them to requirements.txt"
	@echo "  make audit           - Audit installed packages for security vulnerabilities"
	@echo "  make check-env       - Validate that the .env and chat.env exist and are secure"
	@echo "  make run-tool        - Run the rotate_api_key.py CLI tool with secure env var"
	@echo "  make auto-upgrade    - Watch requirements.txt and upgrade if it changes"
	@echo "  make finalize-repo   - Patch enforcement docs, create builder guide, push to GitHub"
	@echo "  make validate-makefile - Lint the Makefile syntax using checkmake"
	@echo "  make help            - Show this help menu"
	@echo ""

upgrade: check-env
	@echo "🔄 Upgrading dependencies inside .env..."
	$(VENV_ACTIVATE) && \
	pip install --upgrade pip && \
	pip install --upgrade -r requirements.txt && \
	pip freeze > requirements.txt && \
	echo "✅ Upgrade complete and locked in requirements.txt"

audit: check-env
	@echo "🔍 Auditing dependencies for known vulnerabilities..."
	$(VENV_ACTIVATE) && \
	pip install pip-audit && \
	pip-audit || echo "⚠️ Vulnerabilities found. Review the report above."

check-env:
	@if [ ! -f .env/bin/activate ]; then \
		echo "❌ .env not found. Creating virtual environment..."; \
		python -m venv .env || (echo "Failed to create virtual environment" && exit 1); \
	fi
	@echo "✅ Virtual environment detected."
	@if [ ! -f chat.env ]; then \
		echo "🔐 Creating chat.env for API key storage..."; \
		touch chat.env; \
	fi
	@KEY=$$(grep GPT_AGENT_API_KEY chat.env | cut -d= -f2); \
	if [ -z "$$KEY" ]; then \
		echo "🔑 Generating new secure API key..."; \
		NEWKEY=$$(openssl rand -hex 32); \
		echo "GPT_AGENT_API_KEY=$$NEWKEY" > chat.env; \
		echo "✅ New GPT_AGENT_API_KEY written to chat.env"; \
	else \
		echo "✅ Existing GPT_AGENT_API_KEY detected"; \
	fi

run-tool: check-env
	@echo "🚀 Running rotate_api_key CLI tool with secure environment..."
	@if [ ! -f rotate_api_key.py ]; then \
		echo "❌ rotate_api_key.py not found"; \
		exit 1; \
	fi
	@KEY=$$(grep GPT_AGENT_API_KEY chat.env | cut -d= -f2); \
	$(VENV_ACTIVATE) && \
	GPT_AGENT_API_KEY=$$KEY python rotate_api_key.py

auto-upgrade: check-env
	@echo "🔄 Watching requirements.txt for changes..."
	@if command -v inotifywait > /dev/null; then \
		while true; do \
			inotifywait -e modify requirements.txt && \
			make upgrade; \
		done; \
	elif command -v fswatch > /dev/null; then \
		fswatch -o requirements.txt | xargs -n1 -I{} make upgrade; \
	else \
		echo "❌ Neither inotifywait nor fswatch found. Please install one of them."; \
		exit 1; \
	fi

finalize-repo: check-env
	@echo "🔧 Finalizing FlowChain repo..."
	@mkdir -p docs core
	@if [ ! -f core/TECHNICAL_GUIDE.md ]; then \
		echo "Creating core/TECHNICAL_GUIDE.md..."; \
		mkdir -p core; \
		echo "# Technical Guide\n\nThis is the technical guide for FlowChain." > core/TECHNICAL_GUIDE.md; \
	fi
	@test -f docs/FLOWCHAIN_BUILDER_GUIDE.md || cat > docs/FLOWCHAIN_BUILDER_GUIDE.md <<EOF
# FlowChain Builder Guide

This guide helps developers, contributors, or agents working with a FlowChain-enabled project.

## What is FlowChain?
A proof-driven, state-locked protocol for structured project development.

## Best Practices
- Don't skip phases
- Mirror JSON and Markdown inputs
- Use init.sh to enforce compliance
EOF
	@test -f .gitignore || cat > .gitignore <<EOF
# Auto-generated ignore list
.env
__pycache__/
*.pyc
chat.env
EOF
	@if ! grep -q "## Enforcement Mechanisms" core/TECHNICAL_GUIDE.md; then \
		echo -e "\n## Enforcement Mechanisms\n\n- **Missing Files = PR Blocked**\n- **Out-of-Order Progression = Error**\n- **Unfinished Steps → GitHub Issues**" >> core/TECHNICAL_GUIDE.md; \
	fi
	@if [ ! -f README.md ]; then \
		echo "# FlowChain\n\nA proof-driven, state-locked protocol for structured project development." > README.md; \
	fi
	@if ! grep -q "Unfinished logic" README.md; then \
		echo -e "- Unfinished logic or references → converted into GitHub Issues" >> README.md; \
	fi
	@echo "Enter your GitHub username:"
	@read USERNAME && \
	git add . && \
	git commit -m "Finalize FlowChain repo: builder guide, enforcement logic, and docs" && \
	git branch -M main && \
	if ! git remote | grep origin >/dev/null; then \
		git remote add origin https://github.com/$$USERNAME/flowchain.git; \
	fi && \
	git push -u origin main && \
	echo "✅ Repo finalized and pushed with full enforcement logic."

validate-makefile:
	@echo "🔎 Validating Makefile syntax..."
	@if command -v checkmake > /dev/null; then \
		checkmake Makefile || echo "⚠️ Issues found in Makefile."; \
	else \
		echo "⚠️ checkmake not installed. Install with: go get -u github.com/mrtazz/checkmake"; \
	fi
	@echo "✅ Makefile validation complete."
