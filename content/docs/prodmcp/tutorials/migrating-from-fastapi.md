---
title: "Migrating from FastAPI"
linkTitle: "From FastAPI"
weight: 10
description: >
  Turn your existing REST API into an MCP-capable Unified Server.
---

Migrating from **FastAPI** to **ProdMCP** is a drop-in experience. Since ProdMCP v0.3.0, the core class supports the same constructor and method decorators as FastAPI.

### Step 1: Update your Imports

Change your import line from `fastapi` to `prodmcp`. You can use an alias to keep the rest of your code unchanged.

```python
# Before
from fastapi import FastAPI, Depends, HTTPException

# After
from prodmcp import ProdMCP as FastAPI, Depends, HTTPException
```

### Step 2: Update your Application Instance

The `ProdMCP` constructor is compatible with standard FastAPI parameters.

```python
app = FastAPI(
    title="MySecureAPI",
    version="1.0.0",
    description="A legacy API getting an MCP upgrade."
)
```

### Step 3: Run your Server

Update your entry point. By default, `app.run()` starts the **Unified Server** (REST + MCP).

```python
if __name__ == "__main__":
    # This will now serve REST at http://localhost:8000/
    # AND MCP at http://localhost:8000/mcp/sse
    app.run()
```

### Step 4: Add MCP capabilities

Now the magic happens. You can take any of your existing REST endpoints and make them available to AI agents by adding the `@app.tool()` decorator.

```python
@app.tool(name="check_inventory")
@app.get("/inventory/{item_id}")
async def get_inventory(item_id: str):
    return {"id": item_id, "status": "in-stock"}
```

### Why Migrate?

1.  **Zero Duplication**: You no longer need a separate "sidecar" server for MCP.
2.  **Unified Security**: Your existing `Depends()` and security schemes are automatically validated for both REST and MCP.
3.  **Future-Proof**: Your API is now natively discoverable by any agent toolchain using the **OpenMCP Specification**.

### Compatibility Note

If you have a very complex FastAPI app with many custom Starlette routes or low-level ASGI middleware, you can still use the **[Testing Bridge](../../advanced/fastapi-bridge/)** to auto-map your MCP entities into a separate FastAPI instance.
