---
title: "Scopes & Permissions"
linkTitle: "Scopes"
weight: 5
description: >
  Managing granular access control using OAuth2-style scopes.
---

Scopes provide a way to define granular permissions within your MCP server. Instead of just checking if a user is authenticated, you can check if they have permission to perform a specific action (e.g., `read:users`, `write:logs`).

### Defining Scopes in Schemes
When you register a security scheme, you can define the list of available scopes.

```python
from prodmcp import BearerAuth

app.add_security_scheme("bearer", BearerAuth(
    scopes={
        "read": "Read-only access to resources",
        "write": "Permission to modify data",
        "admin": "Full administrative access"
    }
))
```

### Requiring Scopes on Tools
You specify the required scopes for a tool in the `security` list.

```python
@app.tool(security=[{"bearer": ["write"]}])
def update_product_price(product_id: str, price: float):
    ...
```

### How Scopes are Validated
1. **Extraction**: Your security scheme's `extract` method returns a `SecurityContext` containing a list of `scopes`.
2. **Comparison**: ProdMCP checks if the tool's required scopes are a subset of the context's scopes.
3. **Enforcement**: If any required scope is missing, a `ProdMCPSecurityError` is raised.

### Dynamic Scopes
If your scopes are stored in a database or depend on the user's role, ensure your custom extractor or dependency handles the mapping of roles to the `scopes` list in the `SecurityContext`.

```python
def my_extractor(context: dict) -> SecurityContext:
    user = db.get_user(context['token'])
    # Map roles like 'manager' to granular scopes
    scopes = ["read", "write"] if user.role == "manager" else ["read"]
    return SecurityContext(user=user, scopes=scopes)
```
