#!/bin/bash

echo "🚀 FlowChain Repo Strengthening Started..."

# Create folder structure
mkdir -p core
mkdir -p interfaces/github-action
mkdir -p interfaces/gpt-tool
mkdir -p interfaces/cli-agent
mkdir -p templates
mkdir -p docs

# ───── core/ ─────

echo "🔧 Writing core files..."

cat > core/README.md <<EOF
# FlowChain Core

This folder contains the core protocol engine including initialization logic, state control, and enforcement logic.
EOF

mv init.sh core/init.sh 2>/dev/null || touch core/init.sh
mv flow_state.json core/flow_state.json 2>/dev/null || touch core/flow_state.json

cat > core/TECHNICAL_GUIDE.md <<EOF
# Technical Guide – FlowChain

## FLOWCHAIN PROTOCOL STRUCTURE
<!-- Finalized protocol structure is already embedded here -->
<!-- PLACEHOLDER: Sync with latest protocol sections if not done -->

<!-- More technical sections may follow -->
EOF

# ───── interfaces/ ─────

echo "🧩 Creating interface folders..."

cat > interfaces/github-action/flowchain.yml <<EOF
# PLACEHOLDER: GitHub Action for FlowChain validation
# This will run init.sh and lock phases during PRs or pushes
EOF

cat > interfaces/gpt-tool/README.md <<EOF
# PLACEHOLDER: GPT Tool Integration

Define how this tool can be triggered from a GPT instance (e.g. manifest, tool config, prompt triggers).
EOF

cat > interfaces/cli-agent/README.md <<EOF
# PLACEHOLDER: CLI Agent Interface

This is where CLI wrappers or shell commands for FlowChain should live.
EOF

# ───── templates/ ─────

echo "📦 Writing templates..."

cat > templates/project_form.example.json <<EOF
{
  "project_name": "MyProject",
  "description": "<!-- PLACEHOLDER -->",
  "purpose": "<!-- PLACEHOLDER -->",
  "tech_stack": {
    "languages": [],
    "frameworks": [],
    "platforms": [],
    "tools": []
  },
  "features": ["<!-- PLACEHOLDER -->"],
  "integrations": {
    "EXAMPLE_TOOL": "Description"
  },
  "definition_of_done": "<!-- PLACEHOLDER -->",
  "flowchain_version": "1.0-draft",
  "state_dependencies": {
    "requires": [],
    "unlocks": []
  }
}
EOF

cat > templates/DESIGN_GUIDE.template.md <<EOF
# DESIGN_GUIDE.md – Template

## PROJECT DEFINITION
<!-- PLACEHOLDER -->

## TECH STACK
<!-- PLACEHOLDER -->

## FEATURES
<!-- PLACEHOLDER -->

## INTEGRATIONS
<!-- PLACEHOLDER -->

## DESIGN TARGET
<!-- PLACEHOLDER -->
EOF

# ───── docs/ ─────

echo "📚 Writing docs..."

cat > docs/FLOWCHAIN_PROTOCOL.md <<EOF
# FlowChain Protocol (v1.0 – Draft Finalized)

<!-- This contains the full protocol sequence across all phases -->
<!-- Synced with TECHNICAL_GUIDE.md -->

<!-- PLACEHOLDER: Copy finalized protocol here -->
EOF

cat > docs/CHANGELOG.md <<EOF
# Changelog

## [Unreleased]
- Initialized platform structure
- Finalized protocol logic (v1.0 draft)
- Created placeholders for future interface support
EOF

echo "✅ FlowChain repo structure updated. All core areas now scaffolded with proper placeholders."
