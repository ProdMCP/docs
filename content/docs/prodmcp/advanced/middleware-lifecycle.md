---
title: "Middleware Lifecycle"
linkTitle: "Middleware Basic"
weight: 1
description: >
  Understanding the asynchronous hooks that power ProdMCP's request interception.
---

Middleware allows you to run code **before** and **after** your handlers. ProdMCP uses a non-intrusive middleware system where you define classes that implement the specific hooks you need.

### The Middleware Hooks

A ProdMCP middleware class can implement two primary methods:

#### `async def before(self, context: MiddlewareContext) -> None`
- Runs **before** the tool/prompt/resource logic.
- Use it to: Start timers, log incoming requests, validate custom headers, or inject metadata.

#### `async def after(self, context: MiddlewareContext) -> None`
- Runs **after** the logic completes (or fails).
- Use it to: Measure execution duration, log results/errors, or perform cleanup.

### The `MiddlewareContext`
Every hook receives a context object containing:
- `entity_type`: "tool", "prompt", or "resource".
- `entity_name`: The name of the entity being called.
- `metadata`: A dictionary you can use to pass information between `before` and `after` hooks.

### Global vs Per-Entity
- **Global**: Applied to every single entity in your app using `app.add_middleware(MyMiddleware())`.
- **Per-Entity**: Applied only to specific tools or prompts using the `middleware` parameter in the decorator.
