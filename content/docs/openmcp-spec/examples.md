---
title: "Examples"
linkTitle: "Examples"
weight: 4
description: >
  Sample OpenMCP documents demonstrating the specification in action.
---

## Sample MCP Server

This example demonstrates a complete OpenMCP document describing a server with a tool, prompt, and resource:

```json
{
  "openmcp": "1.0.0",
  "info": {
    "title": "Sample MCP Server",
    "version": "1.0.0",
    "description": "A sample server demonstrating OpenMCP features."
  },
  "servers": [
    {
      "url": "http://localhost:8000",
      "description": "Local development server"
    }
  ],
  "tools": {
    "get_user": {
      "description": "Retrieve user details by ID",
      "input": {
        "$ref": "#/components/schemas/UserInput"
      },
      "output": {
        "$ref": "#/components/schemas/UserOutput"
      },
      "security": [
        { "bearerAuth": ["user"] }
      ]
    }
  },
  "prompts": {
    "summarize_text": {
      "description": "Summarize the provided text",
      "input": {
        "type": "object",
        "properties": {
          "text": { "type": "string" }
        },
        "required": ["text"]
      },
      "output": {
        "type": "object",
        "properties": {
          "summary": { "type": "string" }
        }
      }
    }
  },
  "resources": {
    "system_status": {
      "description": "Current system status",
      "output": {
        "type": "object",
        "properties": {
          "status": { "type": "string" },
          "uptime": { "type": "number" }
        }
      }
    }
  },
  "components": {
    "schemas": {
      "UserInput": {
        "type": "object",
        "properties": {
          "id": { "type": "string" }
        },
        "required": ["id"]
      },
      "UserOutput": {
        "type": "object",
        "properties": {
          "name": { "type": "string" },
          "email": { "type": "string" }
        }
      }
    },
    "securitySchemes": {
      "bearerAuth": {
        "type": "http",
        "scheme": "bearer"
      }
    }
  }
}
```

## Key Patterns

### Using `$ref` for Reusable Schemas

Instead of inlining schemas in every tool, define them once in `components.schemas` and reference them:

```json
{
  "tools": {
    "get_user": {
      "input": { "$ref": "#/components/schemas/UserInput" },
      "output": { "$ref": "#/components/schemas/UserOutput" }
    },
    "update_user": {
      "input": { "$ref": "#/components/schemas/UserUpdateInput" },
      "output": { "$ref": "#/components/schemas/UserOutput" }
    }
  }
}
```

### Security Bindings

Bind security requirements to individual tools:

```json
{
  "tools": {
    "admin_action": {
      "description": "Requires admin scope",
      "input": { "type": "object", "properties": {} },
      "output": { "type": "object", "properties": {} },
      "security": [
        { "bearerAuth": ["admin"] }
      ]
    }
  },
  "components": {
    "securitySchemes": {
      "bearerAuth": {
        "type": "http",
        "scheme": "bearer",
        "bearerFormat": "JWT"
      }
    }
  }
}
```

### Generating from ProdMCP

The easiest way to create an OpenMCP document is to use [ProdMCP](../../prodmcp/):

```python
from prodmcp import ProdMCP
from pydantic import BaseModel

app = ProdMCP("MyServer", version="1.0.0")

class UserInput(BaseModel):
    user_id: str

class UserOutput(BaseModel):
    name: str
    email: str

@app.tool(name="get_user", input_schema=UserInput, output_schema=UserOutput)
def get_user(user_id: str) -> dict:
    return {"name": "Alice", "email": "alice@example.com"}

# Auto-generate the OpenMCP document
spec = app.export_openmcp()
```
