---
title: "Manual Bridge (Testing)"
linkTitle: "Manual Bridge"
weight: 5
description: >
  Explicitly mapping your MCP server into a standalone FastAPI app for testing.
---

> [!IMPORTANT]
> Since v0.3.0, ProdMCP includes a **Unified Server** (the default) that handles both REST and MCP protocols natively. You should use the Unified Server for majority of production use cases.

The **Manual Bridge** is a specialized tool for scenarios where you need to auto-map your MCP entities (Tools, Prompts, Resources) into a separate, standalone FastAPI instance, typically for unit testing or legacy integration.

### The `test_mcp_as_fastapi()` Method

This method (formerly `as_fastapi()`) generates a complete FastAPI application by inspecting your ProdMCP registry and creating standard REST routes for every MCP entity.

```python
import uvicorn
from prodmcp import ProdMCP

app = ProdMCP("TestBridge")

@app.tool(name="calc")
def calc(x: int, y: int) -> int:
    return x + y

# Generate the standalone FastAPI app
# This is an alias for the legacy as_fastapi() method.
fastapi_app = app.test_mcp_as_fastapi()

if __name__ == "__main__":
    uvicorn.run(fastapi_app)
```

### Auto-Mapping Logic

The bridge automatically creates the following paths:
-   **Tools**: `POST /tools/{name}`
-   **Prompts**: `POST /prompts/{name}`
-   **Resources**: `GET /resources/{uri:path}`

### Unified vs Manual Bridge

| Feature | Unified Server (Default) | Manual Bridge (Testing) |
| :--- | :--- | :--- |
| **Primary Use** | Production Hybrid Apps | Testing & Auto-mapping |
| **REST Syntax** | Standard `@app.get` style | Auto-generated `/tools/` paths |
| **Flexibility** | High (Custom paths/tags) | Automatic (Fixed paths) |
| **Access** | `app.run()` | `app.test_mcp_as_fastapi()` |

If you want to manually define your REST routes with specific paths and tags while sharing logic with MCP, use the **[Unified Framework](../../unified-framework/)** instead.
