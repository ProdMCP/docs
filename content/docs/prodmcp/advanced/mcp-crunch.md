---
title: "MCPcrunch Validation"
linkTitle: "MCPcrunch"
weight: 100
description: >
  Comprehensive security and structural validation for the OpenMCP Specification.
---

Production-grade AI tools require more than just a running server—they require **guaranteed schema integrity and security**.

### What is MCPcrunch?

**[MCPcrunch](https://pypi.org/project/mcpcrunch/)** is an open-source security and structural validation framework for the **OpenMCP Specification**. It is the official companion to ProdMCP for ensuring your specifications are robust, secure, and ready for autonomous agentic environments.

### Key Capabilities

MCPcrunch goes beyond simple schema matching by performing deep audits:

1.  **Deterministic Auditing**: 20+ built-in rules covering **Format (FMT)**, **Data Quality (DAT)**, and **Security (SEC)**.
2.  **Semantic Risk Analysis**: Leverages LLMs (like Gemini or OpenAI) to detect **Adversarial (ADV)** threats such as Prompt Injection in tool descriptions or prompt templates.
3.  **Security Scoring**: Provides an instant security score (0-100) inspired by the 42Crunch standard for OpenAPI, giving you a clear benchmark for production readiness.
4.  **Rich Reporting**: Generates detailed terminal reports with summary tables and specific issue breakdowns.

### Installation

Install MCPcrunch via PyPI:

```bash
pip install mcpcrunch
```

### Usage

#### Command Line Interface (CLI)

You can audit your `openmcp.json` file directly from the terminal.

**Basic Audit (Deterministic only):**
```bash
mcpcrunch openmcp.json --schema schema.json
```

**Full Audit (Deterministic + Semantic):**
```bash
# Requires an LLM provider and API key
mcpcrunch openmcp.json --llm gemini --api-key YOUR_GEMINI_API_KEY
```

#### Python API

Integrate validation directly into your testing suite or deployment pipeline:

```python
from mcpcrunch import MCPcrunch, GeminiProvider
import json

# Load your spec
with open("openmcp.json") as f:
    spec_data = json.load(f)

# Initialize the auditor
crunch = MCPcrunch(
    schema_path="schema.json", 
    llm=GeminiProvider(api_key="your-api-key")
)

# Run the audit
report = crunch.audit(spec_data)

print(f"Overall Security Score: {report.overall_score}/100")
for issue in report.issues:
    print(f"[{issue.severity}] {issue.code}: {issue.message}")
```

#### Dynamic Audit from ProdMCP

You can audit your application's specification directly from your Python code, allowing for "pre-flight" security checks before your server starts.

```python
from prodmcp import ProdMCP
from mcpcrunch import MCPcrunch

app = ProdMCP("MyServer", version="1.0.0")

# ... define your tools, prompts, etc. ...

def startup_check():
    # 1. Export the spec
    spec = app.export_openmcp()
    
    # 2. Audit it immediately
    crunch = MCPcrunch(schema_path="schema.json")
    report = crunch.audit(spec)
    
    if report.overall_score < 80:
        raise RuntimeError(f"Specification security score {report.overall_score} is too low!")
    print(f"✅ Security check passed: {report.overall_score}/100")

if __name__ == "__main__":
    startup_check()
    app.run()
```

### Continuous Reliability

By combining **ProdMCP**'s strict runtime validation with **MCPcrunch**'s deep specification auditing, you create a "Closed-Loop Agreement" between your server and your AI agents. This ensures that your agents never encounter malformed data or insecure tool definitions.

