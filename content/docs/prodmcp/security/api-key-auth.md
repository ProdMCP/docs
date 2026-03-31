---
title: "API Key Authentication"
linkTitle: "API Key Auth"
weight: 3
description: >
  Securing endpoints with static keys in headers, queries, or cookies.
---

API Key authentication is a simple way to protect tools by requiring a specific key to be present in the request.

### Supported Locations
ProdMCP's `ApiKeyAuth` supports three locations:
1. **header**: (Default) The key is in an HTTP header (e.g., `X-API-Key`).
2. **query**: The key is a query parameter in the URI.
3. **cookie**: The key is stored in a browser/request cookie.

### Configuration

```python
from prodmcp import ApiKeyAuth

# Header-based key
app.add_security_scheme("headerKey", ApiKeyAuth(key_name="X-API-Key", location="header"))

# Query-parameter based key
app.add_security_scheme("queryKey", ApiKeyAuth(key_name="api_token", location="query"))
```

### Usage

```python
@app.tool(security=[{"headerKey": []}])
def fetch_protected_resource():
    ...
```

### How to Validate Keys?
By default, the `ApiKeyAuth` scheme only extracts the key. To actually validate it (e.g., check it against a list of valid keys), you should either:
- Create a **Dependency** that checks the extracted key.
- Use **Middleware** to validate security at the lifecycle level.
- Or use a **CustomAuth** provider that handles both extraction and verification.
