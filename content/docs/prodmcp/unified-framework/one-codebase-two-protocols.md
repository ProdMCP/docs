---
title: "One Codebase, Two Protocols"
linkTitle: "One Codebase, Two Protocols"
weight: 1
description: >
  The philosophy behind Unified REST + MCP development.
---

The biggest problem that ProdMCP solves is **Combined Development**. Most modern organizations need their internal tools and services to be accessible in two ways:
1.  **For Humans**: Via a standard **REST API** (used by front-end applications, integrations, etc.).
2.  **For Agents**: Via the **Model Context Protocol (MCP)** (used by LLMs, AI agents, etc.).

In the past, this meant maintaining two separate codebases—one with **FastAPI** and one with **FastMCP**.

### The Inefficiency of Parallel Worlds

Managing two separate servers for the same tools leads to:
-   **Schema Duplication**: You have to define your Pydantic models twice.
-   **Security Gaps**: You have to implement authentication logic twice.
-   **Maintenance Hell**: If the backend logic changes, you have to remember to update both servers.
-   **Testing Friction**: You need different testing strategies for REST and MCP.

### The ProdMCP Solution

ProdMCP eliminates this boundary entirely. It treats REST and MCP as **two different views of the same business logic**.

```python
from prodmcp import ProdMCP

app = ProdMCP(title="InventoryManager")

@app.tool(name="check_stock", description="Check stock level (MCP)")
@app.get("/stock/{item_id}", description="Check stock level (REST)")
def check_stock(item_id: str) -> dict:
    # This logic is shared!
    return {"id": item_id, "count": 42}
```

### Benefits of the Unified Approach

#### 1. Security Consolidation
You can apply the same security requirements to both protocols. If a user is authorized for the REST endpoint, they are authorized for the MCP tool.

#### 2. Schema Integrity
Inputs and outputs are validated once using Pydantic. ProdMCP's **Strict Output Validation** ensures that whether the data is going to a browser or an agent, it is always correct and well-formed.

#### 3. Automatic Documentation
-   **For REST**: You get a live **Swagger UI** (OpenAPI) at `/docs`.
-   **For MCP**: You get a machine-readable **OpenMCP Specification** via `app.export_openmcp()`.

#### 4. Simplified Operations
Run one process, manage one set of logs, and deploy one container. ProdMCP handles the multiplexing for you.
