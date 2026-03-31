---
title: "Bearer Authentication"
linkTitle: "Bearer Auth"
weight: 2
description: >
  Implementing token-based authentication using the HTTP Authorization header.
---

Bearer authentication is a common pattern where the client sends a token (like a JWT) in the `Authorization: Bearer <token>` header.

### Setup

```python
from prodmcp import ProdMCP, BearerAuth

app = ProdMCP("SecuredServer")

# Define the scheme
bearer_scheme = BearerAuth(
    scopes=["read", "write"],
    description="Standard JWT-based bearer authentication."
)

app.add_security_scheme("jwtAuth", bearer_scheme)
```

### Extraction Logic
The `BearerAuth` class automatically looks for the `Authorization` header in the request context. It expects the format `Bearer <token>`.

### Scope Validation
If you specify scopes in your tool requirement, ProdMCP will check if the extracted `SecurityContext` contains those scopes.

```python
@app.tool(security=[{"jwtAuth": ["write"]}])
def update_data():
    ...
```

### Overriding for Custom Validation
If you need to validate the token against a database or external provider, you can subclass `BearerAuth` or use its `extract` method as a base for a `CustomAuth` scheme.

```python
class MyJWTAuth(BearerAuth):
    def extract(self, context: dict) -> 'SecurityContext':
        # 1. Call base extraction to get the token
        sec_ctx = super().extract(context)
        
        # 2. Perform your own validation
        if not my_verifier.is_valid(sec_ctx.token):
            raise ProdMCPSecurityError("Invalid JWT token")
            
        return sec_ctx
```
