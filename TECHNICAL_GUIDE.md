# Technical Guide – FlowChain

## Architecture

FlowChain is a state-driven, documentation-enforced build protocol.

## Core Components

- `flow_state.json` – Controls what phase the system is in
- `.github/workflows/` – CI-level enforcement of gates
- `DESIGN_GUIDE.md` – Defines agent logic and execution strategy
- `generate_issues.py` – Script to parse docs and auto-create build issues

## Agent Model

Agents operate through simulation or GPT. Each has a defined role:

- Validator Agent
- Scaffold Agent
- Review Agent
- Build Agent
- Extension Agent

Each agent must use **2 methods** for validation (e.g., internal logic + external search).

## State Machine

```json
{
  "idea_captured": true,
  "validation_passed": true,
  "scaffold_generated": true,
  "design_ready": false,
  "build_started": false
}
