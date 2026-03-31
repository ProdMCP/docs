---
title: "App Initialization"
linkTitle: "Initialization"
weight: 1
description: >
  Configuring your Unified ProdMCP application.
---

The `ProdMCP` class is the central coordinator of your application. In v0.3.0, it has been expanded to support a unified architecture that mirrors both **FastAPI** and **FastMCP**.

### Constructor Patterns

ProdMCP is designed to be a drop-in replacement for your existing frameworks.

#### FastAPI Style
If you are coming from FastAPI, you can use the `title` and `version` parameters as you would in a standard API project.

```python
from prodmcp import ProdMCP as FastAPI

app = FastAPI(
    title="LogisticsAPI",
    version="2.4.0",
    description="Manages global logistics and tracking."
)
```

#### FastMCP Style
If you are coming from FastMCP, you can use the positional name argument.

```python
from prodmcp import ProdMCP as FastMCP

app = FastMCP("LogisticsServer")
```

### Configuration Options

#### `title` / `name` (str)
The human-readable name of your application. This is shared with the client during MCP discovery and appears in the Swagger documentation.

#### `mcp_path` (str)
The base path for the MCP SSE endpoint. Defaults to `/mcp`. For example, with the default settings, your MCP clients will connect to `http://localhost:8000/mcp/sse`.

#### `strict_output` (bool)
Defaults to `True`. One of the major differences from FastMCP is that ProdMCP **validates your outputs**. If your handler returns data that doesn't match its schema, a `ProdMCPValidationError` is raised. This prevents malformed data from reaching your agents.

#### `**fastmcp_kwargs`
Any additional keyword arguments are passed directly to the underlying `FastMCP` instance, allowing you to configure low-level transport settings if needed.

### Running the Server

The `app.run()` method is the main entry point for your application. Since v0.3.0, it defaults to **Unified Mode**.

```python
if __name__ == "__main__":
    # Serves both REST API (root) and MCP (at /mcp)
    app.run(host="0.0.0.0", port=8000)
```

You can choose other transports if you don't need the unified server:
- `transport="stdio"`: For local standard I/O (Claude Desktop, etc.).
- `transport="sse"`: For pure MCP SSE (no REST routes).
- `transport="unified"`: The default (REST + MCP).
