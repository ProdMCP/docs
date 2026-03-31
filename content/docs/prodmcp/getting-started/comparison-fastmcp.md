---
title: "Comparison with FastMCP"
linkTitle: "FastMCP Comparison"
weight: 3
description: >
  Why choose ProdMCP over standard FastMCP?
---

While [FastMCP](https://github.com/jlowin/fastmcp) is an excellent starting point for building MCP servers, it is designed primarily for rapid prototyping. **ProdMCP** was built to take those prototypes into production by solving critical gaps in the original framework.

### Comparison Table

| Feature | FastMCP | ProdMCP |
| :--- | :--- | :--- |
| **Unified Architecture** | No (MCP Only) | **Yes (REST + MCP Combined)** |
| **Output Validation** | No | **Yes (Strict Pydantic Enforcement)** |
| **Security/Auth** | Basic / Manual | **First-Class (Bearer, ApiKey, Custom)** |
| **Middleware** | Limited | **Full Hooks (before/after/around)** |
| **Specification** | Partial | **Full OpenMCP (OpenAPI-style JSON)** |
| **Documentation** | None | **Live Swagger UI for REST API** |

### Key Advantages of ProdMCP

#### 1. The Unified Advantage
In FastMCP, your code is locked into the MCP protocol. If you need a REST API for your frontend or a third-party service, you have to rewrite your logic in FastAPI. ProdMCP eliminates this duplication: define your handler once, and serve it to both MCP agents and REST clients.

#### 2. Strict Output Validation
FastMCP validates inputs but **ignores outputs**. If your tool accidentally returns a string when the LLM expects an object, FastMCP will happily send it, leading to agent errors or hallucinations. ProdMCP's `strict_output` mode (enabled by default) ensures that your server *never* sends data that doesn't match your Pydantic schemas.

#### 3. Production-Ready Security
FastMCP has no built-in primitives for securing your tools. ProdMCP provides a full security manager that allows you to define complex authentication requirements (Scopes, OR-logic, etc.) that are validated **before** your handler is called.

#### 4. The OpenMCP Standard
Before ProdMCP, there was no standardized way to describe an MCP server's full capabilities machine-readably. ProdMCP introduced the **OpenMCP Specification**, allowing for a new ecosystem of testing and discovery tools.

Because ProdMCP wraps FastMCP, you still get all the performance and transport support of the base library, including both `stdio` and `sse` transports.
