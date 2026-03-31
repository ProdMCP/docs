---
title: "The Unified Framework"
linkTitle: "Unified Framework"
weight: 30
description: >
  Build REST APIs and MCP Tools from a single codebase.
---

ProdMCP's core innovation is its **Unified Framework** architecture. It allows you to build modern, production-grade backends that are natively accessible to both humans (via REST) and AI agents (via MCP).

### Why Unified?

In the early days of MCP development, developers had to choose:
1.  Build a **FastAPI** app for their web frontend.
2.  Build a **FastMCP** app for their AI agents.

This created a "Parallel World" problem: duplicate schemas, duplicate security logic, and duplicate business code. ProdMCP eliminates this boundary entirely.

### Core Architecture

At its heart, ProdMCP is a meta-framework that wraps both **FastAPI** and **FastMCP**. When you define a handler in ProdMCP:
-   It is registered in the **Unified Registry**.
-   It can be exposed as a **REST endpoint** with automatic Swagger docs.
-   It can be exposed as an **MCP Tool** with automatic OpenMCP specs.

### Key Features

-   **[One Codebase, Two Protocols](./one-codebase-two-protocols)**: The philosophy of unified development.
-   **[Decorator Stacking](./decorator-stacking)**: Mixing `@app.get` and `@app.tool` on the same function.
-   **[@app.common() Shared Config](./common-decorator)**: Centralized management for stacked handlers.
-   **[Mounting & Paths](./mounting-and-paths)**: Customizing how your server is exposed to the world.
