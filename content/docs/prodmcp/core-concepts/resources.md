---
title: "Resource Management"
linkTitle: "Resources"
weight: 5
description: >
  Exposing static and dynamic data via URI-based resources.
---

Resources in MCP are a way for servers to expose data that the LLM can read. Unlike tools, which are usually transactional, resources are identifiable by a URI and are often used for providing context or documents.

### Defining a Resource

Use the `@app.resource` decorator to register a data provider.

```python
@app.resource(
    uri="data://inventory",
    name="product_inventory",
    description="Current stock levels for all products.",
    output_schema=InventorySchema
)
def get_inventory() -> list:
    """Fetch all products and their stock."""
    return [
        {"id": "p1", "stock": 50},
        {"id": "p2", "stock": 10}
    ]
```

### Resource URIs
Resources are identified by unique URIs. While you can use any scheme, common ones include `data://`, `file://`, or `mcp://`. You can also use URI templates to create dynamic resources.

```python
@app.resource(uri="data://logs/{date}")
def get_logs_for_date(date: str) -> str:
    # Logic to fetch logs for a specific date
    ...
```

### Output Validation
Just like tools, resources support the `output_schema` parameter. ProdMCP will validate the returned data against this schema before sending it to the client, ensuring the LLM receives well-structured information.

### MIME Types
You can specify a `mime_type` for your resource to help the client understand how to render or process the data.

```python
@app.resource(
    uri="file://report.pdf",
    mime_type="application/pdf"
)
def get_report() -> bytes:
    ...
```
*(Note: For binary data, ensure your handler returns bytes or a base64 encoded string depending on your client's capabilities.)*
