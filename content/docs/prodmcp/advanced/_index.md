---
title: "Advanced Features"
linkTitle: "Advanced"
weight: 50
description: >
  Deeper dives into ProdMCP internals.
---

Once you've mastered the core concepts of tools and security, ProdMCP offers advanced features to help you build enterprise-grade MCP servers.

### Middleware
Intercept and modify requests and responses globally or per-entity. Perfect for observability and cross-cutting concerns.

### Dependency Injection
A clean, FastAPI-inspired way to manage shared resources like database connections, configurations, and user state.

### Transports & Networking
Deep dive into how ProdMCP communicates over `stdio` and `sse` (Server-Sent Events), and how to configure them for high performance.

### FastAPI Bridge
Instantly turn your MCP server into a standard REST API with auto-generated documentation.

### Google ADK Integration
Run ProdMCP as an MCP backend for Google Agent Development Kit agents, with full Azure AD authentication and compatibility notes for v0.3.10–v0.3.12.
