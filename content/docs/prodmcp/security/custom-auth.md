---
title: "Custom Auth Extractors"
linkTitle: "Custom Auth"
weight: 4
description: >
  Writing proprietary authentication logic for non-standard systems.
---

If your authentication system doesn't fit standard patterns (like custom signature headers or legacy protocols), you can implement a `CustomAuth` scheme.

### The `CustomAuth` Class
`CustomAuth` accepts an `extractor` callable that receives the request context and must return a `SecurityContext`.

### Example: Signature-based Authentication

```python
from prodmcp import CustomAuth
from prodmcp.security import SecurityContext

def verify_signature(context: dict) -> SecurityContext:
    # context['headers'] contains all request headers
    signature = context.get("headers", {}).get("X-Signature")
    payload = context.get("body", {})
    
    if not my_crypto.verify(payload, signature):
        from prodmcp.exceptions import ProdMCPSecurityError
        raise ProdMCPSecurityError("Invalid package signature")
        
    return SecurityContext(user={"id": "signer_1"}, scopes=["admin"])

# Register it
app.add_security_scheme("sigAuth", CustomAuth(extractor=verify_signature))
```

### What's in the `context`?
When running through the FastAPI bridge or SSE transport, the `context` dictionary usually contains:
- `headers`: A dictionary of HTTP headers.
- `query_params`: A dictionary of URL query parameters.
- `cookies`: A dictionary of request cookies.
- `body`: The JSON payload (if applicable).

When running through `stdio`, the context is typically provided by the MCP client environment.
