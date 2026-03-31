---
title: "Testing your MCP Servers"
linkTitle: "Testing"
weight: 3
description: >
  Best practices for ensuring your handlers are bug-free using Pytest.
---

Because MCP servers are often the bridge between an LLM and your sensitive infrastructure, testing is critical.

### Unit Testing Handlers
Since ProdMCP handlers are just standard Python functions, you can test them directly.

```python
import pytest
from app import get_weather

@pytest.mark.asyncio
async def test_weather_logic():
    result = await get_weather(city="London", unit="celsius")
    assert "temperature" in result
    assert isinstance(result["temperature"], float)
```

### Testing Validation & Security
You can also test how ProdMCP wraps your functions by using its internal registry.

```python
from app import app

def test_tool_metadata():
    meta = app.get_tool_meta("get_weather")
    assert meta["input_schema"] is not None
    assert "city" in meta["input_schema"].model_fields

def test_security_enforcement():
    # Attempt to call a secured tool without context
    with pytest.raises(ProdMCPSecurityError):
        app.mcp.call_tool("delete_user", {"id": 1})
```

### Pro-Tip: Mocking
When testing tools that call external APIs, always use a library like `respx` or `unittest.mock` to ensure your tests are deterministic and don't rely on network availability.
