---
title: "Day 6: Enterprise Features"
linkTitle: "Day 6: Enterprise Features"
weight: 60
description: >
  Adding authentication, custom middleware, and observability to your ProdMCP server.
---

Today, we're making our server enterprise-ready. In a real-world scenario, you don't just leave your tools open to the public; you protect them with **Authentication** and add **Middleware** for things like logging.

## 1. Authentication (ProdMCP Security)

ProdMCP supports multiple security schemes. We'll add an **API Key** check to our server.

```python
from prodmcp import ProdMCP, Security

# 1. Initialize with an API Key security scheme
app = ProdMCP("SecureServer", security=Security.api_key(name="X-API-KEY"))

@app.tool()
def super_secret_action():
    """
    Perform an action that requires high authority.
    """
    return {"status": "authorized"}
```

## 2. Using Bearer Tokens (OAuth2)

If you're using an external identity provider, you can use **Bearer Tokens**:

```python
from prodmcp import Security

# Initialize with Bearer Token
app = ProdMCP("EnterpriseServer", security=Security.bearer_auth())
```

## 3. Custom Middleware

Middleware allows you to intercept calls and add logic (like logging or rate limiting) across all tools.

```python
from prodmcp import Request, Response

@app.middleware()
def logging_middleware(request: Request, next_call):
    # Before the tool runs
    print(f"Calling tool: {request.tool_name} with params: {request.params}")
    
    response = next_call()
    
    # After the tool runs
    print(f"Tool {request.tool_name} finished with status: {response.status}")
    return response
```

## 4. Observability

Track how your AI agents are interacting with your server. ProdMCP automatically supports:
- **Request ID Tracking**: Correlation across logs.
- **Timing Headers**: Measure how long each tool call takes.
- **Error Propagation**: Clean error messages for both agents and web clients.

---

## Today's Checklist
- [ ] Implement an API Key check for one of your tools.
- [ ] Add a `logging_middleware` that prints every tool call to the terminal.
- [ ] Try calling your tool without a key and see the `401 Unauthorized` response.

**Next:** We'll master **Day 7: Production Deployment** to ship our server to the world.

[**Next: Day 7 — Production Deployment →**](/docs/tutorials/day-7-production-deployment/)
