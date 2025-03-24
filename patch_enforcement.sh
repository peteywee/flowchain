#!/bin/bash

set -e

echo "🔧 Applying FlowChain enforcement logic patch..."

# Inject into TECHNICAL_GUIDE.md
if grep -q "## Enforcement Mechanisms" TECHNICAL_GUIDE.md; then
  echo "⚠️  Enforcement section already exists in TECHNICAL_GUIDE.md"
else
  echo "➕ Adding to TECHNICAL_GUIDE.md..."
  cat >> TECHNICAL_GUIDE.md << 'EOF'

## Enforcement Mechanisms

- **Missing Files = PR Blocked**  
  GitHub Actions verify that all required files exist at each stage.

- **Out-of-Order Progression = Error**  
  The `flow_state.json` is read to determine if the current stage is valid before executing the next. Builds or reviews without reaching `design_ready` will fail checks.

- **Unfinished Steps → GitHub Issues**  
  If a required file, section, or validation item is incomplete, a GitHub Issue will be auto-generated to track it.
EOF
fi

# Inject into README.md
if grep -q "## Enforced Rules" README.md && grep -q "Unfinished logic" README.md; then
  echo "⚠️  Enforcement summary already exists in README.md"
else
  echo "➕ Updating README.md summary..."
  sed -i '' -e '/## Enforced Rules/a\
- Unfinished logic or references → converted into GitHub Issues\
' README.md 2>/dev/null || sed -i '/## Enforced Rules/a\
- Unfinished logic or references → converted into GitHub Issues\
' README.md
fi

# Stage and commit
echo "📦 Staging and committing changes..."
git add TECHNICAL_GUIDE.md README.md
git commit -m "Add enforcement logic section to TECHNICAL_GUIDE and README"

echo "✅ Enforcement logic patch complete."
