---
title: "Understanding Transports"
linkTitle: "Transports"
weight: 10
description: >
  Choosing the right communication protocol for your Model Context Protocol (MCP) server.
---

ProdMCP supports three primary transport modes, each suited for different use cases. In **v0.3.0**, the default mode is **Unified**, which serves both REST and MCP.

### 1. Unified (Default)
The recommended way to run ProdMCP. It starts a single ASGI server that multiplexes both protocols:
-   **REST API**: Root path (`/`) with Swagger UI at `/docs`.
-   **MCP SSE**: Subpath (`/mcp/sse`).

```python
app.run(transport="unified") # The default
```

### 2. Standard I/O (`stdio`)
This is the traditional way to run MCP servers for local desktop use. The server communicates via `stdin` and `stdout`. This is the required mode for:
-   **Claude Desktop**
-   **Cursor** (local tools)

```python
app.run(transport="stdio")
```

### 3. Server-Sent Events (`sse`)
A pure HTTP-based transport for MCP. This is similar to Unified mode but **only** exposes the MCP protocol (no side REST routes).

```python
app.run(transport="sse")
```

### Choosing the right transport

| Use Case | Recommended Transport |
| :--- | :--- |
| Local AI Coding Assistant (Claude, Cursor) | `stdio` |
| Hybrid Web App + AI Agent Backend | `unified` |
| Dedicated Remote MCP Gateway | `sse` |
| Internal Company Toolchain | `unified` |

### Performance Tip
When using the SSE transport with many concurrent requests, ensure your handlers are `async def` to avoid blocking the web server's event loop.
