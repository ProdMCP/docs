---
title: "MCPcrunch"
linkTitle: "MCPcrunch"
weight: 5
description: >
  Comprehensive security and structural validation framework for OpenMCP specifications — 42Crunch for MCP.
---

<div align="center">
  <img src="/images/mcpcrunch-logo.png" alt="MCPcrunch Logo" width="120">
</div>

**MCPcrunch** is a comprehensive security and structural validation framework for the OpenMCP Specification. Inspired by the philosophy of [42Crunch](https://42crunch.com/) for OpenAPI, MCPcrunch applies both deterministic (static analysis) and semantic (LLM-based) validation rules to ensure your MCP specifications are robust, secure, and ready for autonomous agentic environments.

### Example: Direct Export & Audit (The "Forward" Path)

Build a ProdMCP application, generate its specification, and audit it with MCPcrunch in one step:

```python
from prodmcp import ProdMCP
from mcpcrunch import MCPcrunch

app = ProdMCP("SecurityTool", version="1.0.0")

@app.tool()
def get_user_data(user_id: str):
    """Fetch sensitive user information."""
    return {"id": user_id, "status": "active"}

# 1. Export the specification
spec = app.export_openmcp()

# 2. Audit with MCPcrunch
crunch = MCPcrunch(schema_path="schema.json")
report = crunch.audit(spec)

print(f"Specification Score: {report.overall_score}/100")
```

### Continuous Reliability

By combining **ProdMCP**'s strict runtime validation with **MCPcrunch**'s deep specification auditing, you create a "Closed-Loop Agreement" between your server and your AI agents. This ensures that your agents never encounter malformed data or insecure tool definitions.

## Key Features

- 🔍 **Deterministic Auditing** — 20+ rules covering Format (FMT), Data Quality (DAT), and Security (SEC)
- 🤖 **Semantic Risk Analysis** — LLM-powered (Gemini/OpenAI) detection of adversarial threats
- 📊 **42Crunch-Style Scoring** — Instant security score (0–100) based on severity-weighted issues
- 🛠️ **Developer Friendly** — CLI tool or Python API integration
- 📋 **Rich Reporting** — Beautiful terminal output with summary tables

## In This Section

- [**Overview**](overview/) — What is MCPcrunch and how it works
- [**Installation**](installation/) — Install and use the CLI
- [**Validation Rules**](validation-rules/) — All 20+ deterministic and semantic rules
- [**Python API**](python-api/) — Integrate MCPcrunch into your Python workflows
- [**Examples**](examples/) — Hands-on examples including ProdMCP integration

