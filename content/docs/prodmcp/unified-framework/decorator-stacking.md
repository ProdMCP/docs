---
title: "Decorator Stacking"
linkTitle: "Decorator Stacking"
weight: 2
description: >
  Expose the same handler as both an MCP Tool and a REST endpoint.
---

The most powerful feature of ProdMCP's **Unified Framework** is **Decorator Stacking**. This allows you to attach multiple protocol-specific behaviors to a single Python function.

### How it works

When you stack decorators (like `@app.tool` and `@app.get`), ProdMCP's deferred registration system stores the configuration for each protocol. It then "links" them to the same underlying handler.

```python
from prodmcp import ProdMCP
from pydantic import BaseModel

app = ProdMCP(title="StackingDemo")

class Info(BaseModel):
    id: str
    description: str

@app.tool(name="fetch_info", description="Fetch info via MCP")
@app.get("/info/{info_id}", response_model=Info)
def fetch_info(info_id: str) -> dict:
    return {"id": info_id, "description": "This is a stacked handler!"}
```

### Protocol-Specific Configuration

Each decorator can have its own protocol-specific metadata. For example:
-   The `@app.tool` decorator can have a specific MCP-only `name` or `description`.
-   The `@app.get` decorator can have REST-specific `tags`, `status_code`, or `response_model`.

### Stacking Combinations

You can stack any combination of MCP and REST decorators:
-   **Tool + GET/POST/etc.**: The most common pattern for shared actions.
-   **Resource + GET**: Expose a static or dynamic data resource via a REST path.
-   **Multiple REST methods**: Stack `@app.get` and `@app.post` on the same core logic.

### Dynamic Interaction

The order in which you stack the decorators doesn't matter for the logic, but the `@app.common()` decorator should be placed at the bottom (closest to the function) if you want it to centralize standard configuration for all of them.

```python
@app.tool(name="calc")
@app.post("/calculate")
@app.common(input_schema=CalculateInput)
def calculate(x: int, y: int) -> int:
    return x + y
```

### Security context in stacked handlers
ProdMCP's security manager automatically extracts user context regardless of how the handler was triggered. Whether the request came from a bearer token in a REST header or a session in an MCP SSE connection, the same `SecurityContext` is available to your function.
