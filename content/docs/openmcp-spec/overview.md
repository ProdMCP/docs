---
title: "What is OpenMCP?"
linkTitle: "Overview"
weight: 1
description: >
  Understand the OpenMCP specification — the open standard that brings OpenAPI-style discoverability to MCP servers.
---

## The Problem

MCP (Model Context Protocol) servers expose tools, prompts, and resources — but there's no standardized way to describe what a server offers without inspecting its source code. This makes it hard for:

- **AI agents** to discover and understand server capabilities programmatically
- **Security tools** to audit MCP endpoints for vulnerabilities
- **Documentation generators** to produce human-readable API docs
- **Testing frameworks** to validate server behavior against a contract

## The Solution: OpenMCP

**OpenMCP** is a specification format that describes MCP servers in a structured, machine-readable way — much like OpenAPI (Swagger) describes REST APIs.

> **OpenMCP is to MCP what OpenAPI is to REST.**

An OpenMCP document describes:

| Component | Description |
|-----------|-------------|
| **Info** | Server metadata (name, version, description, license) |
| **Servers** | Connection endpoints (URLs and descriptions) |
| **Tools** | Executable actions with typed I/O schemas and security bindings |
| **Prompts** | Structured prompt templates for LLM interaction |
| **Resources** | Data providers with defined output schemas |
| **Components** | Reusable schemas and security scheme definitions |

## Design Principles

1. **Machine-First** — Documents are JSON/YAML for programmatic consumption
2. **Human-Readable** — Clear structure with CommonMark descriptions
3. **Schema-Driven** — JSON Schema Draft 7 for all data type definitions
4. **Security-Aware** — First-class support for authentication and authorization
5. **Extensible** — Custom `x-` fields for vendor-specific extensions

## How It Fits In the Ecosystem

```text
┌─────────────────────────────────────────────┐
│  ProdMCP (Framework)                        │
│  ┌─────────────────────────────────────┐    │
│  │  @app.tool() / @app.prompt() /      │    │
│  │  @app.resource()                    │    │
│  └───────────────┬─────────────────────┘    │
│                  │ export_openmcp()          │
│                  ▼                           │
│  ┌─────────────────────────────────────┐    │
│  │  OpenMCP Specification (JSON/YAML)  │────┼──▶ MCPcrunch (Audit)
│  └─────────────────────────────────────┘    │
└─────────────────────────────────────────────┘
```

- **ProdMCP** generates OpenMCP documents automatically from decorated code
- **MCPcrunch** validates and audits OpenMCP documents for security and correctness
- **OpenMCP Spec** is the shared contract between tools, servers, and agents

## Current Version

The current stable version is **OpenMCP v1.0.0**. See the [Specification](../specification/) for the full formal document.
