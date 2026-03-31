---
title: "Exception Reference"
linkTitle: "Exceptions"
weight: 1
description: >
  Understanding and handling ProdMCP's internal error types.
---

When something goes wrong in ProdMCP, it raises specialized exceptions that help you understand whether the issue is with data shapes, authentication, or the framework itself.

### Base Exception: `ProdMCPError`
The parent class for all exceptions in the library. Catching this will capture any ProdMCP-specific error.

### `ProdMCPValidationError`
Raised when a tool, prompt, or resource fails schema validation.

**Attributes**:
- `message`: A summary of the validation error.
- `errors`: A list of dictionaries containing the Pydantic-style error details (loc, msg, type).
- `field`: The specific field that caused the initial failure (if applicable).

### `ProdMCPSecurityError`
Raised when a security requirement is not met.

**Attributes**:
- `message`: Defaults to "Authentication required".
- `scheme`: The name of the security scheme that failed.

### `ProdMCPMiddlewareError`
Raised if a middleware hook encounters an unrecoverable failure or is configured incorrectly.

### Handling Exceptions in your App
You can use standard Python `try-except` blocks. If you use the FastAPI bridge, these exceptions are automatically converted into HTTP 422 (Validation) and HTTP 403 (Security) status codes.
