---
title: "Dependency Injection"
linkTitle: "Depends"
weight: 3
description: >
  Managing shared state and resources cleanly with FastAPI-style Depends().
---

As your server grows, passing around database connections or configuration objects becomes tedious. ProdMCP's `Depends()` system allows you to inject these resources directly into your handlers.

### Basic Usage

```python
from prodmcp import Depends

def get_db():
    return MyDatabaseConnection()

@app.tool()
def fetch_user(user_id: str, db=Depends(get_db)):
    # 'db' is automatically resolved and injected
    return db.query_user(user_id)
```

### Creating Context-Aware Dependencies
Dependencies can also access the request `context` (headers, security info, etc.).

```python
async def get_current_user(context: dict):
    token = context.get("headers", {}).get("Authorization")
    return await auth_service.verify(token)

@app.tool()
async def delete_item(item_id: str, user=Depends(get_current_user)):
    if user.role != "admin":
        raise Exception("Unauthorized")
    ...
```

### Key Features
- **Caching**: By default, dependencies are only calculated **once per request**. If multiple handlers (or nested dependencies) require the same dependency, the cached result is reused.
- **Async Support**: Dependencies can be `async def` or standard `def`.
- **Nesting**: Dependencies can depend on other dependencies.
- **Security Integration**: You can use `Depends()` alongside security requirements to get the fully validated user object.
