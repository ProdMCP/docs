---
title: "Building Custom Middleware"
linkTitle: "Custom Middleware"
weight: 2
description: >
  A step-by-step guide to creating your own request interceptors.
---

Let's build a practical middleware that logs the execution time of every tool call.

### 1. Define the Middleware Class
Inherit from `prodmcp.Middleware`.

```python
import time
from prodmcp import Middleware, MiddlewareContext

class TimerMiddleware(Middleware):
    async def before(self, context: MiddlewareContext) -> None:
        # Save the start time in the context metadata
        context.metadata["start_time"] = time.perf_counter()
        print(f"DEBUG: Starting {context.entity_name}")

    async def after(self, context: MiddlewareContext) -> None:
        # Calculate duration
        start = context.metadata.get("start_time")
        if start:
            duration = time.perf_counter() - start
            print(f"DEBUG: {context.entity_name} took {duration:.4f}s")
```

### 2. Register Your Middleware

#### Globally
```python
app.add_middleware(TimerMiddleware())
```

#### Named (for specific use)
```python
app.add_middleware(TimerMiddleware(), name="timer")

@app.tool(middleware=["timer"])
def slow_operation():
    ...
```

### Error Handling in Middleware
If a `before` hook raises an exception, the tool's execution is aborted, and the `after` hooks of all *previously* executed middleware are still called, ensuring cleanup still happens.
