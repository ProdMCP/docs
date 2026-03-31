---
title: "The @app.common() Decorator"
linkTitle: "@app.common()"
weight: 3
description: >
  DRY (Don't Repeat Yourself) shared configuration for stacked handlers.
---

When you stack multiple decorators (like `@app.tool` and `@app.get`) on the same function, you often find yourself repeating the same configuration:
-   Same **Input Schema** (Pydantic model)
-   Same **Output Schema** (Return model)
-   Same **Security Requirements** (Bearer tokens, API keys)
-   Same **Middleware** (Logging, Rate limiting)

The `@app.common()` decorator is designed to centralize this shared configuration, keeping your code clean and maintainable.

### Shared Schema Validation

Instead of defining `input_schema` in both decorators, you can define it once in `@app.common()`. ProdMCP's deferred registration system will apply it to each protocol-specific entry.

```python
from pydantic import BaseModel
from prodmcp import ProdMCP

app = ProdMCP(title="CommonDemo")

class UserData(BaseModel):
    name: str
    email: str

@app.tool(name="get_user")
@app.get("/users/{user_id}")
@app.common(output_schema=UserData)
def get_user(user_id: str) -> dict:
    return {"name": "Alice", "email": "alice@example.com"}
```

### Shared Security Validation

Security validation is one of the most critical "Parellel World" problems that ProdMCP solves. By defining your security in `@app.common()`, you ensure that the **same validation logic** is applied whether the request comes from the REST API or an MCP client.

```python
# This security requirement will be applied to both REST and MCP!
@app.tool(name="secure_tool")
@app.get("/secure-data")
@app.common(security=[{"bearerAuth": ["read"]}])
def secure_handler() -> str:
    return "This data is protected everywhere."
```

### Shared Middleware

ProdMCP middleware hooks are unified across both protocols. When you define middleware in `@app.common()`, the `before()` and `after()` hooks will execute for both REST and MCP requests.

```python
@app.common(middleware=["logging", "rate_limiter"])
@app.tool(name="heavy_op")
@app.post("/heavy-op")
def heavy_op(data: dict) -> dict:
    return {"status": "processing"}
```

### Placing @app.common()

For the best results, place `@app.common()` **at the bottom** of your decorator stack (closest to the function definition). This ensures that it is processed as the primary metadata source for the handler.
