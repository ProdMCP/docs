---
title: "What is MCPcrunch?"
linkTitle: "Overview"
weight: 1
description: >
  MCPcrunch brings 42Crunch-style security auditing to the MCP ecosystem.
---

## The Problem

MCP servers are increasingly used in autonomous agentic environments where AI agents call tools, read resources, and invoke prompts without human oversight. A malformed or insecure OpenMCP specification can lead to:

- **Prompt injection** via unsanitized description fields
- **Data leakage** through unbounded output schemas
- **SSRF attacks** via localhost server bindings
- **Missing authentication** on sensitive tools
- **Schema ambiguity** that confuses AI agents

## The Solution: MCPcrunch

**MCPcrunch** applies both **deterministic** (static analysis) and **semantic** (LLM-powered) validation to OpenMCP specifications, producing a security score and actionable issue reports.

> MCPcrunch is to OpenMCP what 42Crunch is to OpenAPI.

📦 **Install:** `pip install mcpcrunch` · [PyPI →](https://pypi.org/project/mcpcrunch/) · [GitHub →](https://github.com/ProdMCP/MCPcrunch)

### Two-Layer Validation

| Layer | Type | What It Catches |
|-------|------|----------------|
| **Deterministic** | Static rules | Format errors, missing auth, unbounded schemas, unsafe transports |
| **Semantic** | LLM-powered | Prompt injection, secret leakage, tool shadowing, rug-pull detection |

### Scoring

MCPcrunch produces a **security score from 0 to 100**, weighted by issue severity:

- **Critical** — 15 points deducted per issue
- **High** — 10 points deducted per issue
- **Medium** — 5 points deducted per issue

A score of **70+** is considered production-ready.

## How It Works

```text
┌──────────────────┐        ┌──────────────────┐
│  OpenMCP Spec    │───────▶│  MCPcrunch Engine │
│  (JSON/YAML)     │        │                  │
└──────────────────┘        │  ┌────────────┐  │
                            │  │ Static     │  │
                            │  │ Rules (20+)│  │
                            │  └────────────┘  │
                            │  ┌────────────┐  │
                            │  │ LLM-Based  │  │
                            │  │ Scanning   │  │
                            │  └────────────┘  │
                            └────────┬─────────┘
                                     │
                                     ▼
                            ┌──────────────────┐
                            │  Audit Report    │
                            │  Score: 85/100   │
                            │  Issues: [...]   │
                            └──────────────────┘
```

## Integration with ProdMCP

ProdMCP can automatically export OpenMCP specs and pipe them through MCPcrunch for validation:

```python
from prodmcp import ProdMCP
from mcpcrunch import MCPcrunch

app = ProdMCP("MyServer", version="1.0.0")
# ... define tools, prompts, resources ...

spec = app.export_openmcp()
crunch = MCPcrunch(schema_path="schema.json")
report = crunch.audit(spec)

print(f"Security Score: {report.overall_score}/100")
```

## Beyond Auditing: Conformance Testing

MCPcrunch also includes a complete **Conformance Testing Engine** — 40 tests across 10 categories that validate whether a running MCP server actually implements the contract defined in its spec.

```bash
# Static conformance (no server needed)
mcpcrunch conformance spec.json --schema schema.json --static-only

# Full suite against a live server
mcpcrunch conformance spec.json --server-url http://localhost:3000 --bearer-token $TOKEN
```

→ See [Conformance Testing](../conformance-testing/) for the full test catalog, scoring, and CI/CD integration.
