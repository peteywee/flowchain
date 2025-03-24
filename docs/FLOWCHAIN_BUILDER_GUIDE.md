# FlowChain Builder Guide

This guide helps developers, contributors, or agents working with a FlowChain-enabled project.

---

## 1. What is FlowChain?

A proof-driven, state-locked protocol for managing structured project development across distinct phases:
- Bootstrap
- Init
- Design
- Build
- Drift & Validation
- Completion

---

## 2. Core Concepts

- **Enforcement Levels** (0–4)
- **State Locking** via `flow_state.json`
- **Validation Engine** in `init.sh`
- **Proof Chain**: irreversible phase transitions

---

## 3. Directory Structure

```
/core/         → Protocol logic
/docs/         → Documentation
/interfaces/   → GPT, CLI, GitHub integration layers
/templates/    → Starter forms and markdowns
```

---

## 4. Developer Workflow

```bash
./core/init.sh             # Scaffold + validate files
vim docs/DESIGN_GUIDE.md   # Define project
cat core/flow_state.json   # Check current phase
```

---

## 5. Agent Behavior (Optional)

- Read `project_form.json`
- Confirm state from `flow_state.json`
- Avoid forward progression unless unlocked

---

## 6. Best Practices

- Don’t skip phases
- Mirror JSON and Markdown inputs
- Rely on `init.sh` to enforce compliance

---

## 7. Versioning

Use Git tags to mark protocol progress:
`git tag v1.0`

