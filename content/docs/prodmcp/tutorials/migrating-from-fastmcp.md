---
title: "Migrating from FastMCP"
linkTitle: "From FastMCP"
weight: 20
description: >
  Enhance your FastMCP prototype with Unified REST + Security Validation.
---

Prototyping with **FastMCP** is great, but moving to production requires tools for security, validation, and unified deployment.

### Step 1: Update your Imports

ProdMCP is a drop-in replacement for FastMCP. Simply change your imports.

```python
# Before
from fastmcp import FastMCP

# After
from prodmcp import ProdMCP as FastMCP
```

### Step 2: Use Unified Mode

In FastMCP, you're usually limited to being a "sidecar" to an existing server. In ProdMCP, you are the **primary server**.

```python
# Before
mcp = FastMCP("MyToolhub")
mcp.run() # Starts stdio or sse sidecar

# After
app = FastMCP("MyToolhub")
app.run() # Starts the Unified REST + MCP Server
```

### Why Migrate?

#### 1. Added Security
FastMCP does not include validation for authentication. In ProdMCP, you can easily secure your tools.

```python
@app.tool(security=[{"bearerAuth": ["read"]}])
def get_secure_data():
    return "This tool is protected."
```

#### 2. Strict Output Validation
FastMCP validates your inputs but ignores your outputs. If you accidentally return malformed data, it reaches the LLM and causes hallucination. ProdMCP's `strict_output` (enabled by default) enforces that all responses match your Pydantic models.

#### 3. Real-Time REST APIs
Expose any of your tools as a standard REST API with zero code change by adding the `@app.get` decorator.

```python
@app.tool(name="inventory")
@app.get("/inventory/{id}")
def check_inventory(id: str):
    return {"id": id, "status": "ok"}
```

#### 4. Automatic Swagger UI
Once you add REST decorators, your server will automatically generate interactive documentation at `/docs`, which is extremely helpful for debugging and developer collaboration.

### The OpenMCP spec
By migrating to ProdMCP, your server now automatically generates the **OpenMCP Specification**. This allows your tools to be machine-readable by any agent-first toolchain.
