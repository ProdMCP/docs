---
title: "MCPcrunch"
linkTitle: "MCPcrunch"
weight: 5
description: >
  Comprehensive security and structural validation framework for OpenMCP specifications — 42Crunch for MCP.
---

<div align="center">
  <img src="/images/mcpcrunch-logo.png" alt="MCPcrunch Logo" width="120">
  <br>
  <a href="https://pypi.org/project/mcpcrunch/"><img src="https://img.shields.io/pypi/v/mcpcrunch?color=blue&label=PyPI" alt="PyPI"></a>
  <a href="https://github.com/ProdMCP/MCPcrunch"><img src="https://img.shields.io/badge/license-MIT-green" alt="License"></a>
  <img src="https://img.shields.io/badge/python-3.10%2B-blue" alt="Python">
</div>

**MCPcrunch** is a comprehensive security auditing and conformance testing framework for the OpenMCP Specification. Inspired by the philosophy of [42Crunch](https://42crunch.com/) for OpenAPI, MCPcrunch applies both deterministic (static analysis) and semantic (LLM-based) validation rules to ensure your MCP specifications are robust, secure, and ready for autonomous agentic environments.

📦 **Install:** `pip install mcpcrunch` · [View on PyPI →](https://pypi.org/project/mcpcrunch/) · [Source on GitHub →](https://github.com/ProdMCP/MCPcrunch)

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

- 🔍 **Security Audit** — 24 deterministic rules covering Format (FMT), Data Quality (DAT), Security (SEC), and Documentation (DOC)
- 🧪 **Conformance Testing** — 40 tests across 10 categories validating spec integrity and runtime behavior
- 🤖 **Semantic Risk Analysis** — LLM-powered (Gemini/OpenAI) detection of adversarial threats
- 📊 **42Crunch-Style Scoring** — Instant security score (0–100) + conformance grade (A–F)
- 🛠️ **Developer Friendly** — CLI tool or Python API integration
- 📋 **Rich Reporting** — Beautiful terminal output with summary tables and JSON export

## In This Section

- [**Overview**](overview/) — What is MCPcrunch and how it works
- [**Installation**](installation/) — Install and use the CLI
- [**Validation Rules**](validation-rules/) — All 22 deterministic and semantic audit rules
- [**Conformance Testing**](conformance-testing/) — 40 conformance tests across 10 categories
- [**Python API**](python-api/) — Integrate MCPcrunch into your Python workflows
- [**Examples**](examples/) — Hands-on examples including ProdMCP integration

## What's new in v0.3.0

- 📊 **Partitioned scoring** — Security pool (/30) + Data Validation pool (/70) reported separately in CLI and Python API (`security_score`, `validation_score`)
- 🔬 **Per-capability breakdown** — Every tool, prompt, and resource now gets its own score table in the CLI output (`CapabilityScore` in the Python API)
- 📋 **Two new Documentation rules** — `OMCP-DOC-001` (missing `description`) and `OMCP-DOC-002` (missing `output_description`) penalise undocumented capabilities
- 🔒 **`OMCP-SEC-012`** — now flags OpenAPI operations with no per-operation `security` field when a global requirement is also absent
- 🧪 **288 tests** passing (up from 236)

