---
title: "Configuration Reference"
linkTitle: "Configuration"
weight: 2
description: >
  Full API reference for the ProdMCP application class.
---

The `ProdMCP` class defines the primary interface for building your server.

### `class ProdMCP(...)`

#### Constructor Arguments
- **`name`** (str): The name of your server (e.g., `"SearchServer"`).
- **`version`** (str): Version string for discovery.
- **`description`** (str): Overall description of the server's purpose.
- **`strict_output`** (bool): If `True` (default), all tool and resource returns are validated before being sent.
- **`**fastmcp_kwargs`**: Additional keyword arguments passed directly to the base `FastMCP` constructor.

#### Methods

- **`tool(...)`**: Decorator to register an actionable tool.
- **`prompt(...)`**: Decorator to register a conversational prompt.
- **`resource(...)`**: Decorator to register a data resource URI.
- **`add_security_scheme(name, scheme)`**: Registers a globally reusable security definition.
- **`add_middleware(middleware, name=None)`**: Registers a request/response interceptor.
- **`as_fastapi()`**: Returns a standards-compliant `FastAPI` instance.
- **`export_openmcp()`**: Returns the OpenMCP specification as a Python dictionary.
- **`run(**kwargs)`**: Starts the server on the specified transport (stdio/sse).
