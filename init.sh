#!/bin/bash

set -e

echo "🌀 Initializing FlowChain (without Git)..."
mkdir -p flowchain/.github/workflows
mkdir -p flowchain/.github/scripts
mkdir -p flowchain/.github/ISSUE_TEMPLATE

cd flowchain || exit

# ----------- Utilities -----------

create_if_missing() {
  local FILE="$1"
  local CONTENT="$2"
  if [ -f "$FILE" ]; then
    echo "⚠️  Skipped $FILE (already exists)"
  else
    echo -e "$CONTENT" > "$FILE"
    echo "✅ Created $FILE"
  fi
}

# ----------- Group 1: Docs -----------

create_if_missing "README.md" "# FlowChain\n\nFlowChain is an AI-native build protocol..."

create_if_missing "USER_MANUAL.md" "# User Manual – FlowChain\n\n## Purpose\n\nFlowChain is a development flow..."

create_if_missing "TECHNICAL_GUIDE.md" "# Technical Guide – FlowChain\n\n## Architecture\n\nFlowChain is a state-driven..."

create_if_missing "DESIGN_GUIDE.md" "# Design Guide – FlowChain\n\n## Inputs / Outputs\n\n### Inputs:\n- Idea..."

create_if_missing "FLEX_LOGIC.md" "# Flex Logic – FlowChain\n\n## Optional Layers\n\n- CLI runner\n- Local GPT agent..."

create_if_missing "SIMULATION_REPORT.md" "# Simulation Report – FlowChain\n\n## Simulation Summary\n\nTest: Building a task tracker..."

create_if_missing "flow_state.json" '{
  "project_name": "flowchain",
  "current_step": "scaffold_generated",
  "last_validated_score": 9,
  "docs_generated": true,
  "design_ready": false,
  "build_started": false,
  "override_flags": [],
  "history": [
    "idea_captured",
    "validation_passed",
    "scaffold_generated"
  ]
}'

# ----------- Group 2: GitHub Actions -----------

create_if_missing ".github/workflows/validate.yml" "name: Validate Project\non: [pull_request]\njobs:\n  validate:\n    runs-on: ubuntu-latest\n    steps:\n      - run: echo '✅ Validation step'"

create_if_missing ".github/workflows/scaffold-check.yml" "name: Scaffold Check\non: [pull_request]\njobs:\n  scaffold:\n    runs-on: ubuntu-latest\n    steps:\n      - run: echo '✅ Scaffold check'"

create_if_missing ".github/workflows/design-gate.yml" "name: Design Gate\non: [pull_request]\njobs:\n  gate:\n    runs-on: ubuntu-latest\n    steps:\n      - run: echo '✅ Design ready check'"

create_if_missing ".github/workflows/build-issues.yml" "name: Build Issues\non:\n  push:\n    branches: [main, build/**]\njobs:\n  build_issues:\n    runs-on: ubuntu-latest\n    steps:\n      - run: echo '📝 Would generate issues here'"

create_if_missing ".github/workflows/drift-watcher.yml" "name: Drift Watcher\non: [pull_request]\njobs:\n  drift:\n    runs-on: ubuntu-latest\n    steps:\n      - run: echo '🔍 Would check for doc/code drift'"

# ----------- Group 3: Issue Template + Script -----------

create_if_missing ".github/ISSUE_TEMPLATE/build-task.md" "---\nname: Build Task\nabout: Auto-generated FlowChain task\n---\n\n### Description\n_TODO: Fill in from DESIGN_GUIDE.md or FEATURES.md_\n\n### Checklist\n- [ ] Code written\n- [ ] Docs updated\n- [ ] Test passed"

create_if_missing ".github/scripts/generate_issues.py" "# Placeholder script\n# Would parse DESIGN_GUIDE.md + FEATURES.md\n# Call GitHub API to generate build issues"

echo "✅ FlowChain project scaffold created (no Git)."
