---
title: "ProdMCP"
linkTitle: "ProdMCP"
weight: 10
description: >
  FastAPI-like production layer on top of FastMCP — schema-driven development, validation, security, middleware, and automatic OpenMCP specification generation.
---

<div align="center">
  <img src="/images/prodmcp-logo.png" alt="ProdMCP Logo" width="150">
  <br>
  <a href="https://pypi.org/project/prodmcp/"><img src="https://img.shields.io/pypi/v/prodmcp?color=blue&label=PyPI" alt="PyPI"></a>
  <a href="https://github.com/ProdMCP/ProdMCP"><img src="https://img.shields.io/badge/license-MIT-green" alt="License"></a>
  <img src="https://img.shields.io/badge/python-3.10%2B-blue" alt="Python">
</div>

ProdMCP is a **unified framework** that brings FastAPI-level developer experience to MCP (Model Context Protocol) servers. Build production-grade MCP servers with schema-first validation, security layers, middleware, and automatic OpenMCP specification generation.

📦 **Install:** `pip install prodmcp` · [View on PyPI →](https://pypi.org/project/prodmcp/) · [Source on GitHub →](https://github.com/ProdMCP/ProdMCP)

- **Getting Started** — Installation, quick start, and comparisons with FastMCP
- **Core Concepts** — Tools, prompts, resources, schemas, and the decorator API
- **Tutorials** — Real-world examples: weather APIs, database resources, migration guides
- **Security** — Bearer auth, API keys, custom auth providers, scope management, and [Azure AD / Entra ID](./security/azure-ad)
- **Advanced** — Middleware, dependency injection, FastAPI bridge, transports, and [Google ADK](./advanced/adk-integration)
- **Unified Framework** — One codebase, two protocols (REST + MCP)
- **Reference** — Configuration and exception handling

## The ProdMCP Ecosystem

ProdMCP integrates seamlessly with the rest of our open-source tools:
- 🚀 **Unified API MCP Development** — Build once with ProdMCP, and securely expose your endpoints as both REST APIs and MCP servers out of the box.
- 📜 **[OpenMCP Specification](https://github.com/ProdMCP/OpenMCP-spec)** — ProdMCP automatically generates an OpenMCP specification for your server, treating MCP definitions with the same rigor as OpenAPI.
- 🛡️ **[MCPcrunch](https://github.com/ProdMCP/MCPcrunch/wiki)** — The **1st package** to support security validation and conformance scanning for MCP. Apply deterministic rules and LLM-powered auditing to your generated specs. Learn more in the [MCPcrunch GitHub Wiki](https://github.com/ProdMCP/MCPcrunch/wiki).


## What's new in v0.3.11–v0.3.12

- 🔐 **Azure AD / Entra ID integration** — `prodmcp.integrations.azure` — plug-and-play JWT validation, role enforcement, and On-Behalf-Of token exchange ([docs →](./security/azure-ad))
- 🤖 **Google ADK compatibility** — full MCP tool security now works over the MCP protocol, not just REST ([docs →](./advanced/adk-integration))
- 🐛 **Bug fix** — `PydanticSchemaGenerationError` crash when using `Depends(auth.require_context)` with ADK tools resolved in v0.3.12
