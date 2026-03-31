---
title: "OpenMCP Specification"
linkTitle: "OpenMCP Spec"
weight: 1
description: >
  OpenMCP is to MCP what OpenAPI is to REST — a standardized, machine-readable specification for MCP servers.
---

<div align="center">
  <img src="/images/openmcp-logo.png" alt="OpenMCP Logo" width="120">
</div>

The **OpenMCP Specification** (OMS) defines a standard, machine-readable interface to MCP (Model Context Protocol) servers. It allows both humans and machines to discover and understand the capabilities of an MCP server — including tools, prompts, and resources — without access to source code or documentation.

An **OpenMCP Description** (OMD) can be used by documentation generation tools, code generation tools, and testing suites to ensure consistency across the MCP ecosystem.

## Key Concepts

- **Tools** — Executable actions with typed input/output schemas and security bindings
- **Prompts** — Structured prompt templates for LLM interaction
- **Resources** — Data providers with defined output schemas
- **Components** — Reusable schemas and security scheme definitions
- **Security** — First-class support for bearer tokens, API keys, and more

## In This Section

- [**Overview**](overview/) — What is OpenMCP and why it matters
- [**Specification**](specification/) — The formal OpenMCP v1.0.0 specification
- [**Schemas**](schemas/) — JSON Schema for validation
- [**Examples**](examples/) — Sample OpenMCP documents
