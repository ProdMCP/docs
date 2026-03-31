---
title: "Tags & Entity Metadata"
linkTitle: "Tags & Metadata"
weight: 6
description: >
  Enriching your tools and prompts with descriptive markers for better searchability.
---

As your MCP server grows, you may have dozens of tools and prompts. Metadata helps both developers and LLMs navigate this complexity.

### Using Tags

Tags are a way to group related entities. While the core MCP protocol doesn't have a specific "tag" field, ProdMCP uses tags to organize your server's metadata and OpenMCP specification.

```python
@app.tool(
    name="add_user",
    tags={"admin", "users"}
)
def add_user(name: str) -> dict:
    ...

@app.tool(
    name="get_user",
    tags={"read-only", "users"}
)
def get_user(id: str) -> dict:
    ...
```

### Entity Descriptions
The `description` field is perhaps the most important piece of metadata. It is the primary way the LLM decides which tool to call.
- **Tools**: Describe *what* the tool does and *when* it should be used.
- **Prompts**: Describe the *intent* of the template.
- **Resources**: Describe the *data* being provided.

### Introspection API
ProdMCP provides several methods to inspect your server's metadata programmatically:

```python
# List all registered tool names
tools = app.list_tools()

# Get full metadata for a specific tool
meta = app.get_tool_meta("add_user")
print(meta["tags"])
print(meta["description"])
```

This introspection is also used by the `export_openmcp()` method to generate the comprehensive JSON specification.
