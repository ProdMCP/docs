---
title: "Schema-First Validation"
linkTitle: "Schemas"
weight: 2
description: >
  Using Pydantic for robust data validation and auto-documentation.
---

ProdMCP is built on the principle that **data shapes should be explicit**. Instead of handling raw dictionaries, you define schemas that represent exactly what your tools expect and return.

### Why use Schemas?
1. **Safety**: Catch malformed requests before they hit your logic.
2. **Clarity**: Self-documenting code that LLMs can interpret accurately.
3. **Spec Generation**: Automatic conversion to JSON Schema for the OpenMCP specification.

### Using Pydantic
Pydantic is the recommended way to define schemas in ProdMCP.

```python
from pydantic import BaseModel, Field

class SearchQuery(BaseModel):
    query: str = Field(..., min_length=3, description="The search term")
    limit: int = Field(default=10, ge=1, le=100)

class SearchResult(BaseModel):
    items: list[str]
    total_found: int
```

### Applying Schemas to Tools
When you assign these to a tool, ProdMCP takes care of the rest.

```python
@app.tool(
    input_schema=SearchQuery,
    output_schema=SearchResult
)
def search_database(query: str, limit: int) -> dict:
    # ProdMCP validates 'query' and 'limit' before this runs
    return {"items": ["result1", "result2"], "total_found": 2}
```

### Validation Failures
If an LLM or client sends invalid data, ProdMCP raises a `ProdMCPValidationError`. This exception contains a structured list of errors (field, message, type) that can be returned to the client for debugging.
