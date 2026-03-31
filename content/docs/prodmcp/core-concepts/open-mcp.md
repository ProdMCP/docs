---
title: "The OpenMCP Specification"
linkTitle: "OpenMCP Spec"
weight: 10
description: >
  Standardizing how MCP servers describe their capabilities.
---

One of the most significant contributions of ProdMCP to the ecosystem is the **OpenMCP Specification**.

### The Origins of OpenMCP

Before ProdMCP, there was no standardized, machine-readable way to describe the full capabilities of an MCP server. While the MCP protocol handles the *communication*, it lacks a way to describe:
-   **Security Requirements**: What auth schemes are needed for each tool?
-   **Detailed Schemas**: What are the exact Pydantic models for inputs and outputs?
-   **Metadata**: Tags, descriptions, and organizational information.

This made it difficult to build automated testing tools, discovery gateways, or robust agent toolchains that could "understand" a server before connecting to it.

### What is OpenMCP?

**OpenMCP** is to the Model Context Protocol what **OpenAPI (Swagger)** is to REST APIs. It is a standard JSON/YAML format that provides a complete manifest of your server's entities.

When you call `app.export_openmcp()`, ProdMCP generates this specification automatically by inspecting your registry.

### Why is it needed?

#### 1. Discovery & Agents
Agents can use the OpenMCP spec to understand exactly what tools are available and what data they require without trial-and-error.

#### 2. Ecosystem Interoperability
OpenMCP provides a common language for the entire MCP ecosystem. Tools like **[MCPcrunch](../../advanced/mcp-crunch/)** use this spec to validate that your server is behaving correctly.

#### 3. Frontend Generation
Just like Swagger UI generates a web interface for REST APIs, OpenMCP can be used to generate administrative dashboards or control panels for your MCP servers.

### How it compares to OpenAPI

OpenMCP is inspired by OpenAPI 3.0/3.1 but is tailored specifically for the MCP lifecycle. It uses many of the same concepts:
-   **Components**: Reusable Pydantic schemas and security schemes.
-   **Security**: Standardized definitions for Bearer and API Key auth.
-   **Info**: Versioning and metadata for the whole server.

### Exporting your Spec

You can export your spec at any time from your ProdMCP application:

```python
from app import app
import json

# As a Python dict
spec = app.export_openmcp()

# As a formatted JSON string
print(app.export_openmcp_json(indent=2))
```
