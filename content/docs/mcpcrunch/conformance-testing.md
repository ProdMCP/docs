---
title: "Conformance Testing"
linkTitle: "Conformance Testing"
weight: 6
description: >
  Does your MCP server actually do what the spec says? 40 conformance tests to find out.
---

## What is Conformance Testing?

**Security auditing** checks whether your OpenMCP *specification* is well-formed and secure. **Conformance testing** goes further — it validates whether a *running MCP server* actually implements the contract defined in its spec.

> **Audit** answers: _"Is this spec secure?"_
> **Conformance** answers: _"Does this server behave like its spec says it should?"_

MCPcrunch ships both capabilities in a single package — [`mcpcrunch` on PyPI](https://pypi.org/project/mcpcrunch/).

---

## Architecture

```text
┌──────────────┐     ┌───────────────────┐     ┌───────────────────┐
│  OpenMCP     │────▶│  ConformanceRunner │────▶│   Live MCP Server │
│  Spec (JSON) │     │                   │     │   (JSON-RPC 2.0)  │
└──────────────┘     │  ┌─────────────┐  │     └───────────────────┘
                     │  │Static Tests │  │              ▲
                     │  │ (CT-3.8.x)  │  │              │
                     │  └─────────────┘  │     Mutations: missing fields,
                     │  ┌─────────────┐  │     type violations, injections,
                     │  │Runtime Tests│  │     bad auth, unknown tools...
                     │  │ (CT-3.1–3.10)│ │              │
                     │  └─────────────┘  │──────────────┘
                     └────────┬──────────┘
                              │
                              ▼
                     ┌───────────────────┐
                     │ Conformance Report │
                     │ Score: 85/100  [B] │
                     │ 11/13 tests passed │
                     └───────────────────┘
```

MCPcrunch works in two modes:

| Mode | Requires Server | What it tests |
|------|:-:|---|
| **Static** (`--static-only`) | ❌ | Spec integrity, schema quality, security declarations |
| **Full** | ✅ | Everything above + runtime behavior against a live server |

---

## Quick Start

### Install

```bash
pip install mcpcrunch
```

📦 [View on PyPI →](https://pypi.org/project/mcpcrunch/) · 📂 [Source on GitHub →](https://github.com/ProdMCP/MCPcrunch)

### CLI — Static Tests (No Server Needed)

```bash
# Run all 13 static conformance tests
mcpcrunch conformance spec.json --schema schema.json --static-only
```

### CLI — Full Suite Against a Live Server

```bash
# Full 40-test suite against a running MCP server
mcpcrunch conformance spec.json \
  --server-url https://api.example.com/mcp \
  --bearer-token $MCP_TOKEN

# Export JSON report
mcpcrunch conformance spec.json \
  --schema schema.json \
  --static-only \
  --output conformance-report.json
```

### Python API

```python
from mcpcrunch import ConformanceRunner
from mcpcrunch.conformance.models import AuthConfig

# Static-only (no server)
runner = ConformanceRunner(
    spec_path="spec.json",
    schema_path="schema.json"
)
report = runner.run_static()

print(f"Score: {report.summary.score}/100")
print(f"Grade: {report.summary.grade}")
print(f"Passed: {report.summary.passed}/{report.summary.total_tests}")

# Full suite against a live server
runner = ConformanceRunner(
    spec_path="spec.json",
    schema_path="schema.json",
    server_url="http://localhost:3000",
    auth=AuthConfig(bearer_token="my-token"),
)
report = runner.run_all()

for failure in report.failures:
    print(f"❌ {failure.test_id}: {failure.message}")
```

---

## Test Catalog

MCPcrunch defines **40 conformance tests** across **10 categories**. Of these, **13 are static** (run without a server) and **27 are runtime** (require a live MCP server).

### Summary

| Category | ID Range | Count | Type |
|:---|:---|:---:|:---:|
| Schema Input Conformance | CT-3.1.1 – CT-3.1.7 | 7 | Runtime |
| Output Conformance | CT-3.2.1 – CT-3.2.5 | 5 | Runtime |
| Tool Invocation Contract | CT-3.3.1 – CT-3.3.4 | 4 | Runtime |
| Prompt Conformance | CT-3.4.1 – CT-3.4.3 | 3 | Runtime |
| Resource Conformance | CT-3.5.1 – CT-3.5.3 | 3 | Runtime |
| Security Conformance | CT-3.6.1 – CT-3.6.4 | 4 | Runtime + Static |
| Server Contract | CT-3.7.1 – CT-3.7.3 | 3 | Runtime |
| Spec Integrity (Static) | CT-3.8.1 – CT-3.8.13 | 13 | Static |
| Error Handling | CT-3.9.1 – CT-3.9.3 | 3 | Runtime |
| Determinism | CT-3.10.1 – CT-3.10.3 | 3 | Runtime |
| **Total** | | **40+** | |

---

### Static Tests (CT-3.8) — No Server Required

These 13 tests validate the spec document itself. They run instantly and catch the most common issues before you ever spin up a server.

| Test ID | Name | Severity | What it checks |
|:--|:--|:--:|:--|
| CT-3.8.1 | Schema Validity | High | Spec validates against the OpenMCP JSON Schema |
| CT-3.8.2 | Component References | High | All `$ref` pointers resolve to valid targets |
| CT-3.8.3 | Circular References | High | No infinite cycles in `$ref` graphs |
| CT-3.8.4 | Unused Components | High | No dead component definitions in `components` |
| CT-3.8.5 | Name Collisions | High | Unique names across tools, prompts, and resources |
| CT-3.8.6 | Schema Strictness | Critical | Input schemas set `additionalProperties: false` |
| CT-3.8.7 | String Boundaries | High | All string properties have `maxLength` |
| CT-3.8.8 | Array Boundaries | High | All array properties have `maxItems` |
| CT-3.8.9 | Numeric Boundaries | Medium | All numbers have `minimum` / `maximum` |
| CT-3.8.10 | Security Coverage | High | All tools have security bindings |
| CT-3.8.11 | Bearer Format | Medium | Bearer auth schemes specify `bearerFormat` |
| CT-3.8.12 | Transport Security | High | Server URLs use `https://` or `wss://` |
| CT-3.8.13 | Description Quality | Medium | All entities have meaningful descriptions |

---

### Runtime Tests — Requires a Live Server

#### Schema Input Conformance (CT-3.1)

Validates that the server correctly enforces its input schema. MCPcrunch sends **mutated inputs** — missing fields, wrong types, constraint violations — and verifies the server rejects them properly.

| Test ID | Name | Severity | Attack vector |
|:--|:--|:--:|:--|
| CT-3.1.1 | Valid Input (Happy Path) | Critical | Baseline — valid input should succeed |
| CT-3.1.2 | Missing Required Fields | Critical | Drop each required field, one at a time |
| CT-3.1.3 | Additional Properties Injection | High | Inject `{"__injected": "malicious"}` |
| CT-3.1.4 | Type Violations | Critical | Send `string` → `number`, `object` → `array`, etc. |
| CT-3.1.5 | Constraint Violations | High | Exceed `maxLength`, violate `enum`, break `pattern` |
| CT-3.1.6 | Nullability Violations | High | Send `null` for non-nullable fields |
| CT-3.1.7 | Deep Object Violations | High | Break nested schema, not just top-level |

#### Output Conformance (CT-3.2)

Validates that server responses match the declared output schema.

| Test ID | Name | Severity |
|:--|:--|:--:|
| CT-3.2.1 | Output Schema Validation | Critical |
| CT-3.2.2 | Missing Output Fields | Critical |
| CT-3.2.3 | Extra Fields in Output | Medium |
| CT-3.2.4 | Type Mismatch in Output | Critical |
| CT-3.2.5 | Deterministic Output Structure | High |

#### Tool Invocation Contract (CT-3.3)

Ensures tools behave like strict RPC endpoints.

| Test ID | Name | Severity |
|:--|:--|:--:|
| CT-3.3.1 | Unknown Tool Invocation | Critical |
| CT-3.3.2 | Missing Input Object | Critical |
| CT-3.3.3 | Partial Input | High |
| CT-3.3.4 | Input/Output Mapping Integrity | High |

#### Prompt Conformance (CT-3.4)

| Test ID | Name | Severity |
|:--|:--|:--:|
| CT-3.4.1 | Prompt Input Validation | Critical |
| CT-3.4.2 | Prompt Output Shape | Critical |
| CT-3.4.3 | Deterministic Template Binding | High |

#### Resource Conformance (CT-3.5)

| Test ID | Name | Severity |
|:--|:--|:--:|
| CT-3.5.1 | Resource Fetch | Critical |
| CT-3.5.2 | No Input Rejection | Medium |
| CT-3.5.3 | Output Stability | High |

#### Security Conformance (CT-3.6)

| Test ID | Name | Severity |
|:--|:--|:--:|
| CT-3.6.1 | Missing Authentication | Critical |
| CT-3.6.2 | Invalid Credentials | Critical |
| CT-3.6.3 | Scope Enforcement | High |
| CT-3.6.4 | Security Declaration Consistency | Critical |

#### Server Contract (CT-3.7)

| Test ID | Name | Severity |
|:--|:--|:--:|
| CT-3.7.1 | Server Reachability | Critical |
| CT-3.7.2 | Protocol Compliance (JSON-RPC 2.0) | Critical |
| CT-3.7.3 | Version Matching | High |

#### Error Handling (CT-3.9)

| Test ID | Name | Severity |
|:--|:--|:--:|
| CT-3.9.1 | Invalid Input Returns Error | Critical |
| CT-3.9.2 | Error Structure | High |
| CT-3.9.3 | No Silent Failures | Critical |

#### Determinism (CT-3.10)

| Test ID | Name | Severity |
|:--|:--|:--:|
| CT-3.10.1 | Schema Determinism (Output Shape) | Critical |
| CT-3.10.2 | Tool Contract Stability | High |
| CT-3.10.3 | No Undeclared Fields | High |

---

## Scoring & Grades

Conformance score is **penalty-based**, starting at 100 and deducting per failed test:

| Severity | Penalty per failure |
|:--|:--:|
| **Critical** | −15 |
| **High** | −8 |
| **Medium** | −4 |
| **Low** | −2 |

### Letter Grades

| Grade | Score Range | Meaning |
|:---:|:---:|:---|
| **A** | 90–100 | Fully conformant — ready for production |
| **B** | 75–89 | Minor issues — safe to deploy with caveats |
| **C** | 60–74 | Significant gaps — needs attention |
| **D** | 40–59 | Major conformance failures |
| **F** | 0–39 | Non-conformant — do not deploy |

---

## Report Format

MCPcrunch outputs a rich terminal report and supports JSON export for CI/CD:

```json
{
  "summary": {
    "total_tests": 13,
    "passed": 11,
    "failed": 2,
    "skipped": 0,
    "errors": 0,
    "score": 84,
    "grade": "B"
  },
  "spec_version": "1.0.0",
  "server_url": "http://localhost:3000",
  "duration_ms": 245,
  "results": [...],
  "failures": [
    {
      "test_id": "CT-3.8.7",
      "test_name": "String Boundaries",
      "category": "spec_integrity",
      "severity": "high",
      "entity": "tool.createUser.input.name",
      "status": "FAILED",
      "expected": "maxLength defined on all string properties",
      "actual": "String property 'name' has no maxLength"
    }
  ]
}
```

---

## CI/CD Integration

### GitHub Actions

```yaml
name: MCPcrunch Conformance
on: [push, pull_request]

jobs:
  conformance:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.11"
      - run: pip install mcpcrunch
      - name: Run static conformance tests
        run: |
          mcpcrunch conformance spec.json \
            --schema schema.json \
            --static-only \
            --output conformance-report.json
      - name: Upload report
        uses: actions/upload-artifact@v4
        with:
          name: conformance-report
          path: conformance-report.json
```

### Pytest Integration

```python
import pytest
from mcpcrunch import ConformanceRunner

def test_conformance_grade_a():
    runner = ConformanceRunner(
        spec_path="spec.json",
        schema_path="schema.json"
    )
    report = runner.run_static()

    assert report.summary.grade in ("A", "B"), \
        f"Conformance grade {report.summary.grade} is below threshold"
    assert report.summary.failed == 0, \
        f"{report.summary.failed} conformance tests failed"
```

---

## Conformance vs. Security Audit

MCPcrunch provides **two complementary engines** in the same CLI and Python API:

| | Security Audit | Conformance Testing |
|---|---|---|
| **Command** | `mcpcrunch spec.json` | `mcpcrunch conformance spec.json` |
| **What it checks** | Spec quality & security posture | Spec integrity + runtime behavior |
| **Requires server** | Never | Optional (static-only mode available) |
| **Rules** | 22 rules (FMT/DAT/SEC/ADV) | 40 tests across 10 categories |
| **Scoring** | 0–100 security score | 0–100 conformance score + letter grade |
| **LLM-powered** | ✅ Semantic rules (ADV) | ❌ Fully deterministic |
| **Best for** | "Is this spec safe for agents?" | "Does this server honor its contract?" |

Run both for complete coverage:

```bash
# Security audit
mcpcrunch spec.json --schema schema.json

# Conformance testing
mcpcrunch conformance spec.json --schema schema.json --static-only
```

---

## Further Reading

- 📦 [MCPcrunch on PyPI](https://pypi.org/project/mcpcrunch/) — Install with `pip install mcpcrunch`
- 📂 [Source on GitHub](https://github.com/ProdMCP/MCPcrunch) — Full source, examples, and 236 unit tests
- 📋 [Validation Rules](../validation-rules/) — The 22 security audit rules (separate from conformance)
- 🐍 [Python API Reference](../python-api/) — Programmatic integration guide
