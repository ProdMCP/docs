---
title: "Core Concepts"
linkTitle: "Core Concepts"
weight: 20
description: >
  The fundamental building blocks of the ProdMCP Unified Framework.
---

To build effective applications, you need to understand how ProdMCP manages your logic and handles requests across multiple protocols. This section breaks down the primary entities and standards.

### The Unified Framework
ProdMCP treats REST and MCP as two different views of the same business logic. You define your handlers once and expose them everywhere.

### The Application (`ProdMCP`)
The central coordinator that manages your tools, prompts, resources, security schemes, and middleware. It is compatible with both FastAPI and FastMCP initialization styles.

### The OpenMCP Specification
A machine-readable standard for describing an MCP server's full capabilities—including security and deep schemas.

### Entities
- **Tools**: Actionable functions that perform work (REST GET/POST or MCP Tool).
- **Prompts**: Template-based conversational guides.
- **Resources**: Static or dynamic data URIs.

### Reliability & Integrity
- **Schemas**: Deep Pydantic validation for both inputs and **outputs**.
- **Security**: Production-grade auth that works identically for REST and MCP.
