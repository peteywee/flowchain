# FlowChain

FlowChain is an AI-native build protocol that guides projects from raw idea to release with structured checkpoints, enforced validation, and documentation-first execution. It prevents broken systems, preserves developer flow, and ensures long-term traceability.

## Core Concepts

- 7 Stages of Enforcement (Idea → Release)
- Required documentation gates
- State tracking via `flow_state.json`
- GitHub Actions block incomplete progress
- Issues auto-generated for build tasks and missed steps

## FlowChain Stages

1. **Idea Initiation**
2. **Project Validation**
3. **Scaffold Generation**
4. **Design Phase**
5. **Build Phase**
6. **Review & Audit**
7. **Iteration / Release**

## Enforced Rules

- ❌ Cannot skip validation
- ❌ Cannot start build before design is locked
- ✅ Optional components allowed only if documented in `FLEX_LOGIC.md`
- ✅ All build tasks and unresolved steps become GitHub Issues

## File Structure

- `README.md` – system overview
- `USER_MANUAL.md` – how to use FlowChain
- `TECHNICAL_GUIDE.md` – agent and state logic
- `DESIGN_GUIDE.md` – architecture, data flow, fail states
- `flow_state.json` – live state tracker
- `.github/` – GitHub Actions and issue templates

## Planned Features (v2)

- Semantic versioning in `flow_state.json`
- Features → Issues → Enforcement
- Agent simulation runners
