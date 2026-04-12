---
title: "Google ADK Integration"
description: "Using ProdMCP with Google Agent Development Kit (ADK) — authentication, tool compatibility, and known fixes."
weight: 10
---

# Google ADK Integration

ProdMCP works as an MCP server backend for Google's [Agent Development Kit (ADK)](https://google.github.io/adk-docs/). ADK agents call ProdMCP tools over the MCP Streamable-HTTP transport.

## Setup

Run ProdMCP in **unified mode** (default) — this serves both REST and MCP on the same port:

```python
from prodmcp import ProdMCP

app = ProdMCP("my-adk-backend")

@app.tool()
def search(query: str) -> list[str]:
    """Search for results."""
    return [f"Result for: {query}"]

app.run(transport="unified", host="0.0.0.0", port=8000)
```

Point your ADK agent at:
```
http://localhost:8000/mcp
```

## Securing ADK tools with Azure AD (v0.3.11+)

ADK agents can pass an `Authorization: Bearer <token>` header when calling MCP tools. ProdMCP's Azure AD integration validates these tokens automatically:

```python
from prodmcp import ProdMCP, Depends
from prodmcp.integrations.azure import AzureADAuth, AzureADTokenContext

auth = AzureADAuth.from_env()
app  = ProdMCP("my-adk-backend")
app.add_security_scheme("bearer", auth.bearer_scheme)

@app.tool()
@app.common(security=[{"bearer": []}])
def secure_search(
    query: str,
    ctx: AzureADTokenContext = Depends(auth.require_context),
) -> list[str]:
    """Authenticated search."""
    ctx.require_role("agent")
    return [f"[{ctx.user_info['name']}] Result for: {query}"]

app.run()
```

## ADK + ProdMCP bug fix (v0.3.12)

**Problem (v0.3.11 and earlier):** When an `@app.tool()` handler used `Depends(auth.require_context)` returning an `AzureADTokenContext`, FastMCP's schema parser (`ParsedFunction.from_function`) would read `__annotations__` from the `@functools.wraps`-decorated wrapper — which included the user-defined type `AzureADTokenContext`. Since `AzureADTokenContext` contains a non-Pydantic field (`_auth: AzureADAuth`), Pydantic raised:

```
PydanticSchemaGenerationError: Unable to generate pydantic-core schema for type AzureADAuth.
```

**Fix (v0.3.12):** ProdMCP now resets `__annotations__` on the internal security wrapper to exactly what the new signature declares (only `fastmcp.Context` + the user-visible tool params). It also severs the `__wrapped__` chain so Pydantic cannot follow it back to the original function. No code changes are needed in your application.

```python
# This now works correctly in v0.3.12+ with ADK:
@app.tool()
@app.common(security=[{"bearer": []}])
def my_tool(ctx: AzureADTokenContext = Depends(auth.require_context)) -> dict:
    return ctx.user_info
```

## MCP tool security over HTTP (v0.3.10+)

Before v0.3.10, security checks **always failed** for tools called via the MCP protocol (even with valid tokens). This was because FastMCP invoked tool handlers without injecting the HTTP `Authorization` header into the security context.

**Fix:** ProdMCP wraps secured tools with a FastMCP `Context`-aware bridge that extracts HTTP headers from the MCP POST request and feeds them to the security manager. This means:

- ✅ REST `GET /data` → validates `Authorization` header
- ✅ MCP tool call `tools/call` → also validates `Authorization` header

No application changes required.

## Dependency injection with FastAPI-style dependencies

ProdMCP v0.3.5 fixed a subtle import issue: if you imported `Depends` from `fastapi` (the natural instinct), ProdMCP would silently ignore your dependencies.

Always import `Depends` from `prodmcp`:

```python
# ✅ Correct
from prodmcp import Depends

# ❌ Was silently ignored before v0.3.5
from fastapi import Depends
```

As of v0.3.5, both imports work correctly via duck-typing — but using `from prodmcp import Depends` is recommended for clarity.

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| `PydanticSchemaGenerationError` on startup | Using `Depends(auth.require_context)` in tools with ADK | Upgrade to v0.3.12+ |
| Tools always return 401 even with valid token | MCP security context bug | Upgrade to v0.3.10+ |
| Dependencies returning `None` | `from fastapi import Depends` was used | Use `from prodmcp import Depends` (v0.3.5+ fixes both) |
| `RuntimeError: Task group is not initialized` | FastMCP lifespan regression | Upgrade to v0.3.9+ |
