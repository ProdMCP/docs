---
title: "Protecting Data Resources"
linkTitle: "Secure Resources"
weight: 2
description: >
  Exposing sensitive database records as authenticated MCP resources.
---

Sometimes you want to give an LLM access to a large dataset, like customer records or internal logs, but only if the request is authorized.

### 1. Setup Security

```python
from prodmcp import ProdMCP, ApiKeyAuth

app = ProdMCP("InternalDB")
app.add_security_scheme("internalKey", ApiKeyAuth(key_name="X-DB-KEY"))
```

### 2. Define the Resource
We'll use a URI template to allow the LLM to request specific sets of data.

```python
@app.resource(
    uri="db://customers/{region}",
    security=[{"internalKey": []}]
)
def get_customers_by_region(region: str):
    """Fetch customer list for a specific geographic region."""
    # region is extracted from the URI template automatically
    customers = db.query("SELECT * FROM users WHERE region = ?", region)
    return customers
```

### 3. Accessing the Resource
When the MCP client (like Claude) tries to read `db://customers/us-east`, ProdMCP will:
1. Verify the `X-DB-KEY` header exists in the transport context.
2. Extract `us-east` from the URI.
3. Execute the handler and return the validated data.

By combining **URI templates** and **Security Schemes**, you can safely expose large internal databases to your AI agents.
