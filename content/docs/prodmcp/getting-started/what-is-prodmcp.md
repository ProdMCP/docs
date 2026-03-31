---
title: "What is ProdMCP?"
linkTitle: "What is ProdMCP?"
weight: 3
description: >
  The Unified Framework for building production-grade REST APIs and MCP Tools.
---

ProdMCP is the **Unified Framework** for building production-grade **REST APIs** and **Model Context Protocol (MCP)** servers in a single codebase.

While the MCP protocol handles the communication between LLMs and tools, ProdMCP handles the **developer experience**, **security**, and **operational reliability** required for real-world applications.

### The Problem ProdMCP Solves

Traditional MCP development often suffers from three major gaps:
1.  **Duplicate Development**: Developers find themselves building a REST API (with FastAPI) and then building a separate MCP server (with FastMCP) for the same tools, leads to a massive duplication of logic, schemas, and security code.
2.  **Security Gaps**: Most MCP implementations handle security as an afterthought. ProdMCP makes **Security Validation** a first-class citizen, ensuring that your tools are protected by production-grade authentication (API Keys, Bearer Tokens) that works identically across both REST and MCP.
3.  **Data Reliability**: Frameworks like FastMCP often lack **Output Validation**. If your tool returns malformed data, it reaches the LLM and causes hallucination. ProdMCP enforces strict Pydantic validation on every response.

### Core Pillars

1.  **Unified Architecture**: Define your logic once and expose it as a REST endpoint (`@app.get`) and an MCP Tool (`@app.tool`) simultaneously.
2.  **Schema-First (Strict)**: Every input and output is backed by a schema. ProdMCP's `strict_output` mode ensures that only valid data ever leaves your server.
3.  **Secure by Design**: First-class support for API Keys, Bearer Tokens, and Custom Auth providers that validate requests before your business logic even runs.
4.  **Pluggable Middleware**: Intercept requests and responses to add cross-cutting concerns like tracing, auditing, or rate limiting across both protocols.
5.  **Standardized (OpenMCP)**: ProdMCP introduced the **OpenMCP Specification**—a machine-readable standard (like OpenAPI) that allows your MCP server's capabilities to be discovered, tested, and integrated by any agent toolchain.

By using ProdMCP, you eliminate the boundary between your internal APIs and your AI agents.
