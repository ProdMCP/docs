---
title: "Day 7: Production Deployment"
linkTitle: "Day 7: Production Deployment"
weight: 70
description: >
  Containerizing with Docker, setting up CI/CD verification, and the "Agentic Agreement."
---

Congratulations! You've reached **Day 7**. Today, we're taking our Python code and turning it into a production-ready container that can run anywhere.

## 1. Containerization with Docker

Create a `Dockerfile` for your `ProdMCP` application:

```dockerfile
# 1. Base image
FROM python:3.11-slim

# 2. Working directory
WORKDIR /app

# 3. Dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 4. Copy app code
COPY . .

# 5. Expose ports (8000 for unified)
EXPOSE 8000

# 6. Command
CMD ["python", "server.py"]
```

## 2. CI/CD Verification

In production, you should never deploy a server without an automated security audit. Add a `check_security.py` script to your build pipeline:

```python
import sys
from mcpcrunch import MCPcrunch
import json

def run_pipeline_check():
    # 1. Read your auto-generated spec
    with open("openmcp.json") as f:
        spec_data = json.load(f)
    
    # 2. Run the auditor
    crunch = MCPcrunch(schema_path="schema.json")
    report = crunch.audit(spec_data)
    
    # 3. Gate the deployment
    if report.overall_score < 90:
        print(f"❌ Security check failed! Score: {report.overall_score}")
        sys.exit(1)
    
    print(f"✅ Security check passed with score: {report.overall_score}")

if __name__ == "__main__":
    run_pipeline_check()
```

## 3. The "Agentic Agreement"

The most important concept in production MCP is the **Agentic Agreement**:
- **Reliable Schemas**: Agents depend on your tools acting predictably.
- **Accurate Metadata**: Descriptions are the "API interface" for the AI.
- **Strict Validation**: Never let malformed data through.

## 4. Final Graduation

You've built a **Unified Server** that:
- [x] Speaks both HTTP and MCP.
- [x] Uses Pydantic for bulletproof validation.
- [x] Exposes dynamic Prompts and Resources.
- [x] Is secured with API Key authentication.
- [x] Is audited for security by `MCPcrunch`.
- [x] Is ready for deployment as a Docker container.

---

## 🎓 Final Checklist
- [ ] Build your Docker image and run it locally.
- [ ] Connect a production-grade AI client to your container.
- [ ] Celebrate your 7-day milestone!

You are now a master of the **ProdMCP-org** ecosystem. Ready to build the next generation of AI tools? Go forth and simplify!
