---
title: "Day 3: Schema Excellence"
linkTitle: "Day 3: Schema Excellence"
weight: 30
description: >
  Deep dive into Pydantic and how ProdMCP auto-generates your OpenMCP specification.
---

Today, we're making our tools robust. In production, tools should never fail because of malformed data. We'll use **Pydantic** to define strict schemas for our inputs and outputs.

## 1. Why `Pydantic`?

Pydantic is the backbone of **ProdMCP**. It provides:
- **Type Checking**: Ensures inputs are integers, strings, or specific models.
- **Data Validation**: Enforces ranges, patterns, and required fields.
- **Serialization**: Converts your clean Python objects into JSON and back.

## 2. Advanced Tool Schema

Update your `server.py` with more complex models:

```python
from pydantic import BaseModel, Field
from typing import List, Optional

class UserProfile(BaseModel):
    user_id: int = Field(..., description="The unique ID of the user")
    name: str
    email: Optional[str] = None
    tags: List[str] = Field(default_factory=list)

class CreateUserResponse(BaseModel):
    success: bool
    user: UserProfile

@app.tool()
def create_user(name: str, email: str, tags: Optional[List[str]] = None) -> CreateUserResponse:
    """
    Create a new user in the system with optional tags.
    """
    user_id = 99  # Simulated ID generation
    user = UserProfile(user_id=user_id, name=name, email=email, tags=tags or [])
    
    return CreateUserResponse(success=True, user=user)
```

## 3. Auto-Spec Generation

When you use Pydantic models with `@app.tool()`, **ProdMCP** automatically inspects them and generates an **OpenMCP-compliant specification**.

### The Manifest
You can view your server's manifest at `http://localhost:8000/content/openmcp.json`.

```json
{
  "tools": [
    {
      "name": "create_user",
      "description": "Create a new user in the system with optional tags.",
      "input_schema": {
        "properties": {
          "name": { "type": "string" },
          "email": { "type": "string" },
          "tags": { "items": { "type": "string" }, "type": "array" }
        },
        "required": ["name", "email"],
        "type": "object"
      }
    }
  ]
}
```

## 4. Input Coercion

If you send `"123"` to a field defined as an `int`, Pydantic will automatically coerce it into the correct type. This "loosely strict" behavior is essential for AI-agent interactions where types might be slightly off.

---

## Today's Checklist
- [ ] Implement a `PostModel` and a `get_posts` tool.
- [ ] Use `app.export_openmcp()` to print your spec to the console.
- [ ] Experiment with `Optional` and default values.

**Next:** We'll master **Day 4: Prompts & Resources** to provide richer data to the AI.

[**Next: Day 4 — Prompts & Resources →**](/docs/tutorials/day-4-prompts-resources/)
