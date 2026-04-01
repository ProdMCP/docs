---
title: "Installation & CLI"
linkTitle: "Installation"
weight: 2
description: >
  Install MCPcrunch and use the command-line interface to audit OpenMCP specifications.
---

## Installation

### From PyPI (Recommended)

```bash
pip install mcpcrunch
```

📦 [View `mcpcrunch` on PyPI →](https://pypi.org/project/mcpcrunch/)

### From Source

```bash
git clone https://github.com/prodmcp/mcpcrunch.git
cd mcpcrunch
pip install .
```

## CLI Usage

### Basic Audit (Deterministic Only)

Run a static analysis audit against an OpenMCP specification:

```bash
mcpcrunch spec.json --schema schema.json
```

This performs all 15+ deterministic rules covering Format, Data Quality, and Security categories.

### Full Audit (Deterministic + Semantic)

Add LLM-powered semantic analysis for adversarial threat detection:

```bash
# Using Gemini
mcpcrunch spec.json --llm gemini --api-key YOUR_GEMINI_API_KEY

# Using OpenAI
mcpcrunch spec.json --llm openai --api-key YOUR_OPENAI_API_KEY
```

{{% alert title="Note" color="info" %}}
By omitting the `--llm` flag, the auditor will only perform deterministic (static) checks. No API key is needed for static-only mode.
{{% /alert %}}

### Output

MCPcrunch produces a rich terminal report:

```text
╔══════════════════════════════════════════════╗
║        MCPcrunch Audit Report               ║
╠══════════════════════════════════════════════╣
║  Overall Score: 85/100                      ║
║  Deterministic Issues: 3                    ║
║  Semantic Issues: 1                         ║
╚══════════════════════════════════════════════╝

┌─────────────┬──────────┬────────────────────────────────────┐
│ Rule ID     │ Severity │ Message                            │
├─────────────┼──────────┼────────────────────────────────────┤
│ OMCP-DAT-003│ High     │ String 'name' missing maxLength    │
│ OMCP-SEC-003│ High     │ Tool 'get_user' has no security    │
│ OMCP-DAT-006│ Medium   │ Number 'uptime' missing bounds     │
│ OMCP-ADV-001│ Critical │ Possible prompt injection detected │
└─────────────┴──────────┴────────────────────────────────────┘
```

### Conformance Testing (CLI)

Run conformance tests to validate spec integrity and runtime behavior:

```bash
# Static conformance tests (no server needed)
mcpcrunch conformance spec.json --schema schema.json --static-only

# Full suite against a live server
mcpcrunch conformance spec.json \
  --server-url https://api.example.com/mcp \
  --bearer-token $MCP_TOKEN

# Export JSON report
mcpcrunch conformance spec.json --schema schema.json --static-only --output report.json
```

## Next Steps

- See all [Validation Rules](../validation-rules/) for the complete security audit rule catalog
- See [Conformance Testing](../conformance-testing/) for the full 40-test conformance suite
- Use the [Python API](../python-api/) for programmatic integration
