---
title: "User_Manual"
env: global
version: 0.1.0
---

# User Manual – FlowChain

## Purpose

FlowChain is a development flow built for AI-native, documentation-first projects. It ensures that every stage of your build has been captured, tracked, reviewed, and enforced before proceeding to the next.

## Setup

Clone this repository and run `init.sh` to scaffold the system. Begin with Stage 0: capture your idea and validate it.

## Workflow Stages

Each stage builds on the last. You may not skip or reorder:

1. **Idea Initiation** – Define the concept clearly.
2. **Project Validation** – Use a 9-point validator to assess clarity, value, and feasibility.
3. **Scaffold Generation** – Generate `README`, `USER_MANUAL`, `DESIGN_GUIDE`, etc.
4. **Design Phase** – Define inputs, outputs, system logic, agents, fail states.
5. **Build Phase** – Only allowed after design is complete. All work becomes GitHub Issues.
6. **Review** – Check all code/doc parity and system completeness.
7. **Release** – Mark as shipped or iterate again.

## Enforcement

- If a doc is missing, your PR will fail
- If design isn’t locked, code cannot merge
- If a feature isn’t declared, it cannot be built

## Resuming Flow

FlowChain is designed to be paused/resumed any time. Your state is tracked in `flow_state.json`.

## Modifying FlowChain

See `FLEX_LOGIC.md` to declare optional plugins, tools, or extensions.
