---
title: "Quickstart"
linkTitle: "Quickstart"
weight: 2
description: >
  Launch a Unified Server with REST APIs and MCP Tools in minutes.
---

Let's bootstrap a **Unified ProdMCP application** that defines a handler exposed as both a REST API endpoint and an MCP Tool.

### 1. Create your application

Create a new file `app.py` in your workspace:

```python
from pydantic import BaseModel
from prodmcp import ProdMCP, BearerAuth

# 1. Initialize the App
# We provide a title (FastAPI style) and let it default to Unified mode.
app = ProdMCP(title="My Unified Server", version="1.0.0")

# 2. Register Security
# This scheme will be validated for BOTH REST and MCP requests.
app.add_security_scheme("bearer", BearerAuth(scopes=["read"]))

# 3. Define Schemas
class UserResponse(BaseModel):
    name: str
    email: str

# 4. Create the Unified Handler
# We stack decorators to expose the same logic to both protocols.
@app.tool(name="get_user", description="Get user via MCP")
@app.get("/users/{user_id}", response_model=UserResponse)
@app.common(security=[{"bearer": ["read"]}])
def get_user(user_id: str) -> dict:
    return {
        "name": "Jane Example",
        "email": "jane@example.com"
    }

# 5. Run the Server
if __name__ == "__main__":
    # By default, this starts a Unified Server:
    # - REST API at http://localhost:8000/
    # - MCP SSE at http://localhost:8000/mcp/sse
    app.run()
```

### 2. Start the Server

Install the requirements and run:

```bash
pip install "prodmcp[rest]"
python app.py
```

### 3. Verify the Protocols

#### Access the REST API
You can now hit your endpoint using `curl` or any browser. Note that security is enforced!

```bash
curl -H "Authorization: Bearer my-token" http://localhost:8000/users/123
```

#### Access via MCP
Open your favorite MCP client (like Cursor, Claude Desktop, or the MCP Inspector) and point it to:
`http://localhost:8000/mcp/sse`

### 4. Interactive Documentation
ProdMCP automatically generates **Swagger UI** for your REST routes. Visit `http://localhost:8000/docs` to see your API in action.

### 5. Machine-Readable Specs
Need the **OpenMCP** specification for your agent?
```bash
python -c "from app import app; print(app.export_openmcp_json())"
```
