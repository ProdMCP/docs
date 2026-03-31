---
title: "Defining Tools in Depth"
linkTitle: "Tools"
weight: 3
description: >
  Everything you need to know about creating actionable MCP tools and REST endpoints.
---

Tools are the most common entity in an MCP server. They represent functions that an LLM can call to perform actions or fetch data. In ProdMCP, a **Tool** is also a **REST API Endpoint**.

### The `@app.tool` Decorator

The tool decorator defines the MCP-specific metadata for your handler:

```python
@app.tool(
    name="custom_name",        # Optional: defaults to function name
    description="Helpful doc",  # Optional: defaults to docstring
    input_schema=MyInput,       # Recommended: Validation schema
    output_schema=MyOutput,     # Recommended: Validation schema
    security=[{"auth": []}],     # Optional: Security requirements
    middleware=["logging"],     # Optional: Custom middleware
    tags={"search", "db"},      # Optional: Organization tags
    strict=True                 # Optional: Override global strict_output
)
def my_tool(param: str) -> dict:
    ...
```

### HTTP Method Decorators

ProdMCP provides standard HTTP method decorators that mirror FastAPI's syntax. These allow you to expose your handler as a REST API:

- `@app.get(path, ...)`
- `@app.post(path, ...)`
- `@app.put(path, ...)`
- `@app.delete(path, ...)`
- `@app.patch(path, ...)`

### Unified Handlers (Stacking)

The most powerful way to use tools is to stack them with REST decorators. This ensures that your logic is available to both agents and humans simultaneously.

```python
@app.tool(name="get_weather")
@app.get("/weather/{city}")
def get_weather(city: str) -> dict:
    return {"city": city, "temp": 22.5}
```

### Automatic Destructuring
ProdMCP automatically destructures your `input_schema` fields into arguments for your function. You don't need to parse the model manually.

### Async Support
ProdMCP fully supports `async def` for tools. If your tool performs I/O (like an API call or DB query), using async is highly recommended for performance, especially when using the Unified or SSE transports.

### Docstring Inheritance
If you don't provide a `description` in the decorator, ProdMCP will automatically use the function's docstring. The first line is used as the summary, and the rest as the detailed description. This metadata is shared across both the **OpenMCP Specification** and the **Swagger UI**.
