#!/bin/bash

# ==============================================================================
# Script Name:   add_project_files.sh
# Description:   Creates initial project documentation files for the
#                Agent Orchestration System project.
# Author:        Patrick Craven (Top Shelf Service LLC)
# Project Owner: Patrick Craven (Top Shelf Service LLC)
# Date Created:  2025-04-02
# OS:            Linux Debian 12
# ==============================================================================

# --- Configuration ---
OVERVIEW_FILENAME="PROJECT_OVERVIEW.md"
WORKFLOW_FILENAME="DETAILED_WORKFLOW.md"
PROJECT_NAME="Agent Orchestration System (FlowChain Integrated)"
OWNER_INFO="Patrick Craven, Top Shelf Service LLC"
CURRENT_DATE=$(date +"%Y-%m-%d")

# --- Create PROJECT_OVERVIEW.md ---
echo "Creating ${OVERVIEW_FILENAME}..."
cat << EOF > "${OVERVIEW_FILENAME}"
# Project Overview: ${PROJECT_NAME}

* **Project Owner:** ${OWNER_INFO}
* **Date:** ${CURRENT_DATE}

## Summary

* **Goal:** Build & deploy a distributed agent system on OCI using LangGraph for orchestration. Agents (Mistral, Gemini, custom) interact via APIs & shared OCI DB Memory. Accessed via Browser Extension -> Cloudflare Tunnel.
* **Methodology:** Follows the \`flowchain\` 7-stage protocol (Idea -> Release) within its dedicated GitHub repo structure. Emphasizes automated documentation, issue tracking (GitHub Actions), and Well-Architected principles. No Docker.
* **Key Components:** OCI (VMs, DB, Vault), LangGraph, Python, Cloudflare Tunnel, Mistral/Gemini APIs, Browser Extension, GitHub (\`flowchain\` repo).
* **Current Focus (Stage 3 - Scaffold):** Set up OCI infra (Network, VM, Vault), configure Cloudflare Tunnel, establish basic GitHub Actions CI/automation within the \`flowchain\` repo, verify connectivity.
* **Next Steps:** Detailed Design (Stage 4), Implementation (Stage 5), Review/Audit (Stage 6), Release/Iteration (Stage 7).
* **Portability:** The definitive plan & workflow reside as version-controlled Markdown files within the \`flowchain\` GitHub repository (\`docs/\` folder or similar). This overview serves as a quick reference.

EOF

# --- Create DETAILED_WORKFLOW.md ---
echo "Creating ${WORKFLOW_FILENAME}..."
cat << EOF > "${WORKFLOW_FILENAME}"
# Detailed Project Workflow: ${PROJECT_NAME}

* **Project Owner:** ${OWNER_INFO}
* **Date:** ${CURRENT_DATE}
* **Guiding Principles:** Adherence to the \`flowchain\` 7-stage protocol, OCI Well-Architected Framework, automation via GitHub Actions, documentation-first approach, no Docker containerization.

---

## Phase 1: Conceptualization & Validation (Stages 1 & 2)

### 1. Stage 1: Idea Initiation (Conceptually Complete)
* **Activity:** Define the core concept of the distributed agent orchestration system.
* **Output:** Initial project vision, high-level goals.
* **Flowchain Action:** Document initial idea in \`README.md\` or \`docs/INTRODUCTION.md\`. Update \`flow_state.json\` to reflect Stage 1 completion.

### 2. Stage 2: Project Validation (Largely Complete -> Finalization)
* **Activity:** Refine the system plan, select core technologies, define architecture, identify constraints, and integrate the \`flowchain\` protocol.
* **Steps:**
    * Confirm technology stack: LangGraph (Orchestration), OCI (VMs, Database for Memory, Vault), Cloudflare Tunnel (Entrypoint), Mistral AI & Google Gemini (Core AI), GitHub (\`flowchain\` repo for Versioning/Workflow).
    * Solidify high-level architecture: Browser Extension -> Tunnel -> Orchestrator (LangGraph on OCI VM) -> Specialized Agents (Processes/OCI Functions) <-> OCI Memory DB & AI APIs.
    * Explicitly document constraint: Avoid Docker containerization for agent processes.
    * Define the input mechanism: Browser Extension capturing user commands and interacting with the backend.
    * Formally adopt the \`flowchain\` repository structure and 7-stage protocol.
    * Create placeholder documents within the \`flowchain/docs\` structure (e.g., \`USER_MANUAL.md\`, \`TECHNICAL_GUIDE.md\`, \`DESIGN_GUIDE.md\`).
* **Output:** Validated project plan, confirmed architecture, technology choices, defined constraints, initial \`flowchain\` documentation structure.
* **Flowchain Action:** Update \`flow_state.json\` to reflect Stage 2 completion. Ensure initial required docs exist (even if empty).

---

## Phase 2: Foundation & Design (Stages 3 & 4)

### 3. Stage 3: Scaffold Generation (Immediate Focus)
* **Activity:** Set up the foundational OCI infrastructure, configure secure access, and activate initial \`flowchain\` automation.
* **Steps:**
    * Setup/Configure OCI Account & IAM.
    * Design and Provision OCI Networking (VCN, Subnets, Security Lists). *Consider using Terraform checked into the repo (\`flowchain/infrastructure\`?).*
    * Provision initial OCI Compute Instance (VM); Install prerequisites (Python, pip, git).
    * Set up OCI Vault; Store initial secrets (placeholders or actual keys if available); Configure IAM policies for VM access.
    * Install \`cloudflared\` on the VM.
    * Create and Configure Cloudflare Tunnel; Assign DNS record.
    * Deploy a minimal "Hello World" web service on the VM (e.g., using Python Flask/FastAPI) as a temporary endpoint.
    * Verify end-to-end connectivity via the public Tunnel URL.
    * Configure initial GitHub Actions (\`.github/workflows\`) within the \`flowchain\` repo for:
        * Basic CI (Linting Python code).
        * \`flowchain\` state validation (Check \`flow_state.json\`).
        * Potential triggers for issue linking/creation (based on commits/PRs).
    * Commit infrastructure code (Terraform), setup scripts, and notes into the \`flowchain\` repo.
* **Output:** Operational OCI base infrastructure, secure access via Cloudflare Tunnel, basic CI/automation active, infrastructure-as-code committed.
* **Flowchain Action:** Update \`flow_state.json\` to reflect progress/completion of Stage 3. Ensure infrastructure code follows repo structure.

### 4. Stage 4: Design Phase
* **Activity:** Perform detailed design of all system components within the established \`flowchain\` structure.
* **Steps:**
    * Design the LangGraph state machine: Define states, transitions, agent invocation logic, error handling, and parallel execution paths.
    * Design Specialized Agent interfaces and logic: Define inputs, outputs, core processing for Mistral, Gemini, Memory interaction agents. Specify how they run (OS processes, OCI Functions).
    * Design the OCI Database schema for Memory; Define access patterns.
    * Design the Browser Extension UI/UX: Mockups, user flow for command input, status display, project management integration. Define the API contract between Extension and Orchestrator.
    * Document heavily: Populate \`flowchain/docs/DESIGN_GUIDE.md\` with detailed architecture diagrams (component, sequence, data flow), API specifications, state machine diagrams, Memory schema.
* **Output:** Detailed design specifications for all components, comprehensive design documentation.
* **Flowchain Action:** Update \`flow_state.json\`. Potentially configure GitHub Actions to require \`DESIGN_GUIDE.md\` review/approval before allowing merge of build-phase code.

---

## Phase 3: Implementation & Verification (Stages 5 & 6)

### 5. Stage 5: Build Phase
* **Activity:** Implement the core application logic based on the designs, integrating automated documentation and issue tracking.
* **Steps:**
    * Code the LangGraph Orchestrator Agent (\`flowchain/core\` or \`flowchain/orchestrator\`).
    * Code the Specialized Agents (\`flowchain/agents\`), ensuring they adhere to defined interfaces and run method (processes/Functions).
    * Implement Memory interaction logic using the chosen OCI Database.
    * Develop the Browser Extension prototype, connecting it to the Tunnel endpoint.
    * Integrate OCI Vault for secure retrieval of API keys and secrets.
    * Implement templating for repetitive agent tasks.
    * Write unit and integration tests for all components.
    * Implement code-level documentation (docstrings).
    * Configure automated documentation generation (e.g., Sphinx) via GitHub Actions to build and publish docs to \`flowchain/docs\` based on docstrings.
    * Configure GitHub Actions to scan code for specific markers (e.g., \`TODO:\`, \`FIXME:\`) and automatically create/link GitHub Issues.
* **Output:** Working code for Orchestrator, Agents, Memory access, Browser Extension prototype; Test suite; Auto-generated documentation; Auto-created task issues.
* **Flowchain Action:** Update \`flow_state.json\`. GitHub Actions run tests, check docs, create issues on commits/PRs.

### 6. Stage 6: Review & Audit
* **Activity:** Conduct thorough testing, reviews, and audits before release.
* **Steps:**
    * Execute End-to-End Testing: Simulate user commands from Browser Extension through the entire system and back.
    * Perform Performance Testing: Identify and address bottlenecks under load.
    * Conduct Code Reviews: Ensure code quality, adherence to design, and best practices.
    * Perform Security Audit: Review API key handling, IAM policies, Tunnel security, input validation, dependencies.
    * Conduct OCI Well-Architected Review: Assess against principles (Security, Reliability, Performance, Cost, Operations).
    * Update \`flowchain/docs/TECHNICAL_GUIDE.md\` and \`flowchain/docs/USER_MANUAL.md\` with accurate information based on the built system.
    * Triage and address/plan all open GitHub Issues generated during the build phase.
* **Output:** Tested and validated system, security/architecture review findings, updated user/technical documentation, resolved critical issues.
* **Flowchain Action:** Update \`flow_state.json\`. GitHub Actions may enforce test pass rates, security scan results, and issue resolution status before allowing progression.

---

## Phase 4: Deployment & Iteration (Stage 7)

### 7. Stage 7: Iteration / Release
* **Activity:** Deploy the system, monitor, scale, and iteratively add features and improvements based on feedback and requirements.
* **Steps:**
    * Deploy the application to the OCI production environment.
    * Implement scaling mechanisms (e.g., multiple VMs, OCI Functions for agents) based on performance testing and anticipated load.
    * Configure production monitoring, logging, and alerting (OCI Monitoring, application-level logs).
    * Develop and deploy additional specialized agents as needed.
    * Finalize Browser Extension features and UI.
    * Establish operational procedures for maintenance, updates, and incident response.
    * Gather user feedback.
    * For new features or major changes: Initiate a new cycle starting from Stage 1 (Idea) or Stage 4 (Design), following the established \`flowchain\` workflow (documentation, issue tracking, automated checks).
* **Output:** Deployed, operational system; Monitoring in place; Scalability plan executed; Ongoing development process for new features.
* **Flowchain Action:** \`flow_state.json\` reflects "Released" or loops back to earlier stages for new iterations. Workflow automation continues to support development cycles.

EOF

# --- Completion Message ---
echo "Successfully created:"
echo "- ${OVERVIEW_FILENAME}"
echo "- ${WORKFLOW_FILENAME}"
echo "Script finished."

# --- Make the script executable (optional, run manually if preferred) ---
# chmod +x add_project_files.sh
# echo "Run this script using: ./add_project_files.sh"
