---
title: "Day 5: Security Guardrails"
linkTitle: "Day 5: Security Guardrails"
weight: 50
description: >
  Validation and security auditing with MCPcrunch. Ensuring your specifications are production-ready.
---

Today, we're making our server secure. AI agents can be unpredictable, and if your tools are poorly defined, you're opening a security hole. We'll use **MCPcrunch** to audit our `openmcp.json` specification.

## 1. What is MCPcrunch?

**MCPcrunch** is like a security guard for your AI tools. It performs two types of audits:
- **Deterministic**: Checks for missing descriptions, duplicate names, or malformed schemas.
- **Semantic**: Uses an LLM to look for **Prompt Injection** or sensitive data leaks in your tool descriptions.

## 2. Running a Basic Audit

You can audit your `ProdMCP` application directly from Python.

```python
from prodmcp import ProdMCP
from mcpcrunch import MCPcrunch

app = ProdMCP("DataServer")

@app.tool()
def get_secrets(api_key: str):
    """
    DANGEROUS: Fetches user secrets.
    """
    return {"secret": "12345"}

# --- New: Audit your app ---
def run_audit():
    # 1. Export the spec
    spec = app.export_openmcp()
    
    # 2. Initialize the auditor
    crunch = MCPcrunch(schema_path="schema.json")
    report = crunch.audit(spec)
    
    # 3. Check for issues
    print(f"Overall Security Score: {report.overall_score}/100")
    for issue in report.deterministic.issues:
        print(f"[{issue.severity}] {issue.rule_id}: {issue.message}")

if __name__ == "__main__":
    run_audit()
```

## 3. Fixing Common Issues

Common audit failures and how to fix them:
- **Missing Description**: The AI won't know *when* to call your tool. Add a triple-quoted docstring.
- **Ambiguous Arguments**: Describe each argument in your docstring using the Google or NumPy style.
- **Wide Schemas**: Use specific types (e.g., `int`) instead of `any`.

## 4. Semantic Auditing (LLM-based)

To check for **Adversarial (ADV)** vulnerabilities (like a tool description that accidentally invites prompt injection), you can use the LLM provider:

```python
from mcpcrunch import GeminiProvider

# Requires an API key
llm = GeminiProvider(api_key="your-api-key")
crunch = MCPcrunch(schema_path="schema.json", llm=llm)

report = crunch.audit(spec)
```

---

## Today's Checklist
- [ ] Run a deterministic audit on your Day 3 server.
- [ ] Fix all **FMT** (Format) and **SEC** (Security) issues.
- [ ] See your compliance score reach 100/100.

**Next:** We'll master **Day 6: Enterprise Features** to add auth and middleware.

[**Next: Day 6 — Enterprise Features →**](/docs/tutorials/day-6-enterprise-features/)
