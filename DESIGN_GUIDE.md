
---

### 📄 `DESIGN_GUIDE.md`

```markdown
# Design Guide – FlowChain

## Inputs / Outputs

### Inputs:
- Idea (via user prompt)
- Markdown docs (via scaffold)
- `flow_state.json`

### Outputs:
- Structured final product
- Build artifacts
- Validated documentation
- Closed GitHub Issues

## Agent Logic

- GPT-simulated multi-agent structure
- Each agent must use 2 validation methods
- Review agent runs independently

## Data Flow

1. Idea → Validation
2. Validation → Scaffold
3. Scaffold → Design
4. Design → Build (as issues)
5. Build → Review
6. Review → Release

## Interfaces

- CLI (optional)
- GitHub Web
- GPT UI (recommended)

## Enforcement Rules

- No build before design complete
- All features must be declared
- Unresolved items automatically become GitHub Issues
