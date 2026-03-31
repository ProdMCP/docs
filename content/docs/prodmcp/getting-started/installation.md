---
title: "Installation"
linkTitle: "Installation"
weight: 1
description: >
  How to install ProdMCP for local and production usage.
---

ProdMCP requires Python 3.10 or newer.

You can install it seamlessly using `pip` directly from the PyPI index:

### Core Installation

While you can install the base package, we **strongly recommend** installing with `[rest]` extras to enable the **Unified Framework** (REST + MCP) capabilities.

```bash
pip install "prodmcp[rest]"
```

This installs the core library along with `fastapi` and `uvicorn`, allowing you to serve both protocols from a single command.

### Static / Stdio Only
If you *only* plan to run ProdMCP over standard input/output (the traditional MCP-only behavior) and do not need any REST API features:
```bash
pip install prodmcp
```

### Next Steps
Now that ProdMCP is installed, check out the [Quickstart Guide](../quickstart) to write your first **Unified Handler**!
