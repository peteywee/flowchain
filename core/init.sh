#!/bin/bash
set -e

# ══════════════════════════════════════════════
# 🌀 FLOWCHAIN INIT SCRIPT
# Version: 1.0
# Author: FlowChain Protocol
# Purpose: Scaffold + validate compliance of AI-native projects
# ══════════════════════════════════════════════

# ────────────────────────────────
# 📁 INITIAL PROJECT STRUCTURE
# ────────────────────────────────

echo "🌀 Initializing FlowChain project..."
mkdir -p flowchain/.github/{workflows,scripts,ISSUE_TEMPLATE}
cd flowchain || exit 1

# ────────────────────────────────
# 🔧 FILE GENERATOR FUNCTION
# ────────────────────────────────

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

# ────────────────────────────────
# 📄 CORE DOCUMENTATION FILES
# ────────────────────────────────

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
  "history": ["idea_captured", "validation_passed", "scaffold_generated"]
}'

# ────────────────────────────────
# ⚙️ GITHUB WORKFLOWS
# ────────────────────────────────

create_if_missing ".github/workflows/validate.yml" "name: Validate Project\non: [pull_request]\njobs:\n  validate:\n    runs-on: ubuntu-latest\n    steps:\n      - run: echo '✅ Validation step'"
create_if_missing ".github/workflows/scaffold-check.yml" "name: Scaffold Check\non: [pull_request]\njobs:\n  scaffold:\n    runs-on: ubuntu-latest\n    steps:\n      - run: echo '✅ Scaffold check'"
create_if_missing ".github/workflows/design-gate.yml" "name: Design Gate\non: [pull_request]\njobs:\n  gate:\n    runs-on: ubuntu-latest\n    steps:\n      - run: echo '✅ Design ready check'"
create_if_missing ".github/workflows/build-issues.yml" "name: Build Issues\non:\n  push:\n    branches: [main, build/**]\njobs:\n  build_issues:\n    runs-on: ubuntu-latest\n    steps:\n      - run: echo '📝 Would generate issues here'"
create_if_missing ".github/workflows/drift-watcher.yml" "name: Drift Watcher\non: [pull_request]\njobs:\n  drift:\n    runs-on: ubuntu-latest\n    steps:\n      - run: echo '🔍 Would check for doc/code drift'"

# ────────────────────────────────
# 🧩 TEMPLATE + PLACEHOLDER SCRIPT
# ────────────────────────────────

create_if_missing ".github/ISSUE_TEMPLATE/build-task.md" "---\nname: Build Task\nabout: Auto-generated FlowChain task\n---\n\n### Description\n_TODO: Fill in from DESIGN_GUIDE.md or FEATURES.md_\n\n### Checklist\n- [ ] Code written\n- [ ] Docs updated\n- [ ] Test passed"
create_if_missing ".github/scripts/generate_issues.py" "# Placeholder script\n# Would parse DESIGN_GUIDE.md + FEATURES.md\n# Call GitHub API to generate build issues"

echo ""
echo "✅ FlowChain project scaffold created."

# ────────────────────────────────
# 🧪 FLOWCHAIN COMPLIANCE VALIDATOR
# ────────────────────────────────

echo ""
echo "🚀 Running FlowChain compliance validation..."
echo "─────────────────────────────────────────────"

CORE_FILES=("README.md" "TECHNICAL_GUIDE.md" "USER_MANUAL.md" "DESIGN_GUIDE.md" "FLEX_LOGIC.md" "SIMULATION_REPORT.md" "flow_state.json")

UPPERCASE_SECTION_REGEX='^## [A-Z0-9_ ]+$'
PLACEHOLDER_MARKER='<!-- PLACEHOLDER -->'
MISSING_SECTION_MARKER='<!-- MISSING_SECTION:'
CONTRADICTION_MARKER='🚨 CONTRADICTION'

print_legend() {
  echo ""
  echo "🧾 FlowChain Compliance Legend"
  echo "  ✅ LEVEL 0: Fully valid"
  echo "  ⚠  LEVEL 1: Placeholder present"
  echo "  ❌ LEVEL 2: Missing section"
  echo "  🚨 LEVEL 3: Contradiction detected"
  echo "  🛑 LEVEL 4: File missing"
  echo ""
}

check_file() {
  local file="$1"

  if [ ! -f "$file" ]; then
    echo "🛑 LEVEL 4: $file is missing"
    return 4
  fi

  local level=0
  local has_uppercase_section=false

  while IFS= read -r line; do
    [[ $line =~ $UPPERCASE_SECTION_REGEX ]] && has_uppercase_section=true
    [[ "$line" == *"$PLACEHOLDER_MARKER"* ]] && (( level < 1 )) && level=1
    [[ "$line" == *"$MISSING_SECTION_MARKER"* ]] && (( level < 2 )) && level=2
    [[ "$line" == *"$CONTRADICTION_MARKER"* ]] && (( level < 3 )) && level=3
  done < "$file"

  [ "$has_uppercase_section" = false ] && (( level < 2 )) && level=2

  case $level in
    0) echo "✅ LEVEL 0: $file is valid" ;;
    1) echo "⚠  LEVEL 1: $file contains placeholders" ;;
    2) echo "❌ LEVEL 2: Missing sections or UPPERCASE headers" ;;
    3) echo "🚨 LEVEL 3: Contradictions found" ;;
    *) echo "🛑 LEVEL 4: Unknown error in $file" ;;
  esac

  return $level
}

overall_status=0
for file in "${CORE_FILES[@]}"; do
  check_file "$file"
  result=$?
  (( result > overall_status )) && overall_status=$result
done

print_legend

echo "📦 Final Enforcement Level: $overall_status"
exit $overall_status
