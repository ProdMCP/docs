---
title: "Python API"
linkTitle: "Python API"
weight: 4
description: >
  Integrate MCPcrunch validation directly into your Python applications and CI/CD pipelines.
---

📦 `pip install mcpcrunch` · [PyPI →](https://pypi.org/project/mcpcrunch/) · [GitHub →](https://github.com/ProdMCP/MCPcrunch)

## Quick Start

```python
import json
from mcpcrunch import MCPcrunch

# Initialize with schema
crunch = MCPcrunch(schema_path="schema.json")

# Load and audit a specification
with open("my-server.json") as f:
    spec_data = json.load(f)

report = crunch.audit(spec_data)
print(f"Score: {report.overall_score}/100")
```

## Full Engine (with Semantic Analysis)

```python
from mcpcrunch import MCPcrunch, GeminiProvider

# Initialize with LLM for semantic analysis
llm = GeminiProvider(api_key="your-gemini-key")
crunch = MCPcrunch(schema_path="schema.json", llm=llm)

# Audit with both deterministic and semantic checks
report = crunch.audit(spec_data)

# Access deterministic results
for issue in report.deterministic.issues:
    print(f"[{issue.severity}] {issue.rule_id}: {issue.message}")

# Access semantic results
for issue in report.semantic.issues:
    print(f"[{issue.severity}] {issue.rule_id}: {issue.message}")
```

## Report Object

The `audit()` method returns a structured report:

```python
report = crunch.audit(spec_data)

# Overall score (0-100)
report.overall_score

# Deterministic results
report.deterministic.issues      # List of Issue objects
report.deterministic.passed      # Number of rules passed

# Semantic results (if LLM enabled)
report.semantic.issues           # List of Issue objects
report.semantic.passed           # Number of checks passed
```

### Issue Object

Each issue contains:

| Field | Type | Description |
|-------|------|-------------|
| `rule_id` | `str` | Rule identifier (e.g., `OMCP-SEC-001`) |
| `severity` | `str` | `Critical`, `High`, or `Medium` |
| `message` | `str` | Human-readable description |
| `path` | `str` | JSON path to the offending element |

## CI/CD Integration

### GitHub Actions

```yaml
name: MCPcrunch Audit
on: [push, pull_request]

jobs:
  audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: '3.11'
      - run: pip install mcpcrunch
      - run: mcpcrunch spec.json --schema schema.json
```

### Programmatic Gate

```python
report = crunch.audit(spec_data)

if report.overall_score < 70:
    print(f"❌ Score {report.overall_score}/100 — below threshold")
    sys.exit(1)
else:
    print(f"✅ Score {report.overall_score}/100 — passed!")
```

## LLM Providers

| Provider | Class | Requires |
|----------|-------|----------|
| **Gemini** | `GeminiProvider` | `GEMINI_API_KEY` |
| **OpenAI** | `OpenAIProvider` | `OPENAI_API_KEY` |

## ConformanceRunner API

For conformance testing, use `ConformanceRunner`:

```python
from mcpcrunch import ConformanceRunner
from mcpcrunch.conformance.models import AuthConfig, TestCategory

# Static-only (no server needed)
runner = ConformanceRunner(
    spec_path="spec.json",
    schema_path="schema.json"
)
report = runner.run_static()

print(f"Score: {report.summary.score}/100")
print(f"Grade: {report.summary.grade}")
print(f"Passed: {report.summary.passed}/{report.summary.total_tests}")

# Full suite with live server
runner = ConformanceRunner(
    spec_path="spec.json",
    schema_path="schema.json",
    server_url="http://localhost:3000",
    auth=AuthConfig(bearer_token="my-token"),
)
report = runner.run_all()

# Run a single category
report = runner.run_category(TestCategory.SECURITY)
```

→ See [Conformance Testing](../conformance-testing/) for the full test catalog and scoring details.
