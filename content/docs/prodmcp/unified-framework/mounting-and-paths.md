---
title: "Mounting & Paths"
linkTitle: "Mounting & Paths"
weight: 4
description: >
  Customizing how your Unified Server is exposed to the world.
---

When you run a **Unified ProdMCP Server**, it automatically mounts both a **REST API** and an **MCP SSE Endpoint** on the same ASGI application.

### Mounting Logic

By default, ProdMCP mounts:
-   **REST API**: Root path (`/`)
-   **MCP SSE**: Subpath (`/mcp`)
-   **Swagger Docs**: Path (`/docs`)

```python
from prodmcp import ProdMCP

# The default behavior
app = ProdMCP(title="MyServer")
app.run()
```

### Customizing the MCP Path

If you need your MCP endpoint to live somewhere else (for example, to avoid conflicts with your existing REST routes), you can customize the `mcp_path` in the `ProdMCP` constructor.

```python
# MCP endpoint will now be at http://localhost:8000/agent-gateway/sse
app = ProdMCP(title="MyServer", mcp_path="/agent-gateway")
app.run()
```

### Path Precedence

If you define a REST route that conflicts with the `mcp_path`, the REST route takes precedence. For example, if you set `mcp_path="/mcp"` and then define:

```python
@app.get("/mcp")
def get_mcp_test():
    return "This is a REST route!"
```

The REST route `@app.get("/mcp")` will respond, and the MCP SSE endpoint will not be accessible. Always ensure your `mcp_path` is distinct from your API routes.

### Transport Selection

The `app.run()` method defaults to `transport="unified"`. If you specifically want to run *only* one protocol, you can specify it:

```python
# Standard MCP over Stdin/Stdout (Claude Desktop, etc.)
app.run(transport="stdio")

# Pure MCP over SSE (no REST routes)
app.run(transport="sse")

# The default: Unified REST + MCP
app.run(transport="unified")
```

### Production Deployment

In production, your Unified Server behaves like any other FastAPI or Starlette application. You can run it behind a reverse proxy (like Nginx) or a load balancer as long as it supports long-lived HTTP connections (SSE).
