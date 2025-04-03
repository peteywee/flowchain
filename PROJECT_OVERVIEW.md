# Project Overview: Agent Orchestration System (FlowChain Integrated)

* **Project Owner:** Patrick Craven, Top Shelf Service LLC
* **Date:** 2025-04-02

## Summary

* **Goal:** Build & deploy a distributed agent system on OCI using LangGraph for orchestration. Agents (Mistral, Gemini, custom) interact via APIs & shared OCI DB Memory. Accessed via Browser Extension -> Cloudflare Tunnel.
* **Methodology:** Follows the `flowchain` 7-stage protocol (Idea -> Release) within its dedicated GitHub repo structure. Emphasizes automated documentation, issue tracking (GitHub Actions), and Well-Architected principles. No Docker.
* **Key Components:** OCI (VMs, DB, Vault), LangGraph, Python, Cloudflare Tunnel, Mistral/Gemini APIs, Browser Extension, GitHub (`flowchain` repo).
* **Current Focus (Stage 3 - Scaffold):** Set up OCI infra (Network, VM, Vault), configure Cloudflare Tunnel, establish basic GitHub Actions CI/automation within the `flowchain` repo, verify connectivity.
* **Next Steps:** Detailed Design (Stage 4), Implementation (Stage 5), Review/Audit (Stage 6), Release/Iteration (Stage 7).
* **Portability:** The definitive plan & workflow reside as version-controlled Markdown files within the `flowchain` GitHub repository (`docs/` folder or similar). This overview serves as a quick reference.

