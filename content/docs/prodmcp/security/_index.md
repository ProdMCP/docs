---
title: "Security Model"
linkTitle: "Security"
weight: 40
description: >
  Unified authentication and authorization for REST and MCP.
---

In a production environment, you cannot expose your tools and data without protection. **Security Validation** is one of the two major problems ProdMCP solves (the other being Unified Development).

### The Unified Security Manager

ProdMCP provides a comprehensive security layer that works identically across both protocols. Whether a request comes from a standard **REST API** client or an **MCP AI agent**, the same validation logic is applied.

### Why use ProdMCP Security?

-   **Parallel World Solution**: Define your security schemes once and have them enforced for both REST and MCP simultaneously.
-   **Declarative**: Assign security requirements (Scopes, API Keys, etc.) to your handlers using simple decorators.
-   **Logical OR/AND**: Supports complex requirements (e.g., "requires a Bearer Token OR an API Key").
-   **Spec-Integrated**: Security definitions are automatically included in the **OpenMCP Specification** and the **Swagger UI**.

### How it Works

When a handler with security requirements is triggered:
1.  **Extraction**: ProdMCP pulls credentials from the request context (HTTP headers for REST, or session metadata for MCP SSE).
2.  **Validation**: The `SecurityManager` verifies the credentials against your registered schemes.
3.  **Execution**: If authorized, your business logic runs with a `SecurityContext` containing the user's information.
4.  **Rejection**: If unauthorized, a `ProdMCPSecurityError` is raised **before** your handler is ever called, ensuring data safety.

### Next Steps

Check out the detailed guides for [Bearer Auth](./bearer-auth) and [API Key Auth](./api-key-auth) to start securing your Unified Server.

For enterprise deployments, see the [Azure AD / Entra ID](./azure-ad) integration guide for plug-and-play Microsoft identity support, including role enforcement and On-Behalf-Of token exchange.

> **v0.3.10+**: Security is now enforced identically for both REST routes **and** MCP protocol tool calls — no extra configuration needed.
