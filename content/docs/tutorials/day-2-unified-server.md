---
title: "Day 2: The Unified Server"
linkTitle: "Day 2: The Unified Server"
weight: 20
description: >
  Building your first application with ProdMCP. Serving both HTTP and MCP with the same Python code.
---

Today, we're building a "Unified Server" for the **ProdMCP-org** ecosystem. We'll start with a basic tool that fetches user information and see how `ProdMCP` handles the rest.

## 1. What is a "Unified" Application?

Most MCP servers only support the MCP protocol, which is great for agents but hard for traditional web apps or monitoring tools to talk to. **ProdMCP** solves this by providing a single framework that speaks:
1.  **JSON-RPC (MCP)** for AI Agents.
2.  **REST (HTTP)** for your web dashboards and API clients.

## 2. Your First Tool: `UserServer`

Create a file named `server.py`:

```python
from prodmcp import ProdMCP
from pydantic import BaseModel

# 1. Initialize the app
app = ProdMCP("UserServer", version="1.0.0")

# 2. Define a data schema (Pydantic is best!)
class UserRequest(BaseModel):
    user_id: int

# 3. Create a tool with the @app.tool() decorator
@app.tool()
def get_user_profile(user_id: int):
    """
    Fetch a user's profile and subscription status.
    Args:
        user_id: The unique ID for the user.
    """
    # In a real app, this would be a database call
    users = {
        1: {"name": "Alice", "role": "Admin", "active": True},
        2: {"name": "Bob", "role": "User", "active": False}
    }
    
    if user_id not in users:
        return {"error": "User not found"}
    
    return users[user_id]

# 4. Run the server
if __name__ == "__main__":
    app.run()
```

## 3. Running and Testing

### Start the Server
```bash
python server.py
```
By default, the server runs on `http://localhost:8000`.

### Testing via HTTP
You can call your tool using a regular `curl` request:
```bash
curl -X POST http://localhost:8000/tools/get_user_profile -d '{"user_id": 1}'
```

### Testing via MCP
If you have the `mcp-cli` installed, you can connect directly:
```bash
mcp-cli connect http://localhost:8000/mcp
```

## 4. Why Use `@app.tool()`?

The `@app.tool()` decorator does the heavy lifting:
- **Auto-Discovery**: Registers the function as an MCP tool.
- **Auto-Spec**: Reads your docstrings and type hints to generate an OpenMCP specification entry.
- **REST Bridging**: Automatically creates an HTTP route for the tool.

---

## Today's Checklist
- [ ] Create your `server.py` file and run it.
- [ ] Verify the tool works via an HTTP `curl` request.
- [ ] Observe how `ProdMCP` handles the serialization of your data.

**Next:** We'll dive deep into **Day 3: Schema Excellence** to see how Pydantic makes your tools bulletproof.

[**Next: Day 3 — Schema Excellence →**](/docs/tutorials/day-3-schema-excellence/)
