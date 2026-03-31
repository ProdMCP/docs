---
title: "Security Schemes"
linkTitle: "Schemes"
weight: 1
description: >
  Registering and managing reusable authentication definitions.
---

Before you can secure a tool, you must define the **Security Schemes** your server supports. A scheme tells ProdMCP *how* to extract credentials and *what* they represent.

### Registering a Scheme

You register schemes using the `app.add_security_scheme` method.

```python
from prodmcp import BearerAuth, ApiKeyAuth

# A standard Bearer token scheme
app.add_security_scheme("bearerAuth", BearerAuth(scopes=["admin", "user"]))

# An API Key scheme passed in a custom header
app.add_security_scheme("apiKey", ApiKeyAuth(key_name="X-Internal-Key", location="header"))
```

### Logic in Requirements
Security requirements are defined as a **List of Dictionaries**.
- The **List** represents a logical **OR** (match any one dictionary).
- The **Dictionary** represents a logical **AND** (match all keys within the dictionary).

```python
@app.tool(
    name="delete_database",
    # Requirement: Must have bearer token with 'admin' scope 
    # OR must have a valid API Key.
    security=[
        {"bearerAuth": ["admin"]},
        {"apiKey": []}
    ]
)
def wipe_db() -> dict:
    ...
```

### Global vs Local Schemes
While registering named schemes is best for reusability and OpenMCP documentation, you can also use **Shorthand** configurations directly in the decorator for quick prototyping.

```python
@app.tool(
    security=[{"type": "bearer", "scopes": ["read"]}]
)
def my_quick_tool():
    ...
```
*(Shorthand schemes are automatically registered internally with unique names to keep the specification valid.)*
