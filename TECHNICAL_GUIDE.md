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

## Enforcement Mechanisms

- **Missing Files = PR Blocked**  
  GitHub Actions verify that all required files exist at each stage.

- **Out-of-Order Progression = Error**  
  The `flow_state.json` is read to determine if the current stage is valid before executing the next. Builds or reviews without reaching `design_ready` will fail checks.

- **Unfinished Steps → GitHub Issues**  
  If a required file, section, or validation item is incomplete, a GitHub Issue will be auto-generated to track it.
