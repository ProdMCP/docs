---
title: "Day 4: Prompts & Resources"
linkTitle: "Day 4: Prompts & Resources"
weight: 40
description: >
  Dynamic LLM prompt templates and exposing structured data sources as MCP Resources.
---

Today, we're giving the AI model more than just tools. We'll learn how to provide **Prompts** (templates for better behavior) and **Resources** (data the AI can browse).

## 1. What are MCP Prompts?

MCP **Prompts** are pre-configured instructions and templates that the AI can use to perform its tasks more effectively. ProdMCP allows you to define these with variables.

```python
from prodmcp import ProdMCP

app = ProdMCP("AssistantServer")

@app.prompt()
def analyze_code(file_content: str, language: str = "python"):
    """
    Generate an analysis of the provided code snippet.
    """
    return [
        {"role": "system", "content": f"You are a Senior Software Engineer specializing in {language}."},
        {"role": "user", "content": f"Please review this code for bugs and security issues:\n\n{file_content}"}
    ]
```

## 2. What are MCP Resources?

**Resources** are read-only data sources that the AI can access. This can be anything: text files, database records, or even real-time log data.

```python
@app.resource()
def config_file(path: str = "config.yaml"):
    """
    Access the application configuration files.
    """
    # In a real app, read the actual file
    return {
        "content": "api_key: 'REDACTED'\nendpoint: 'https://api.example.com'",
        "mime_type": "text/yaml"
    }
```

## 3. Serving Dynamic Content

Resources can be dynamic! You can use them to expose database rows by ID:

```python
@app.resource()
def user_logs(user_id: int):
    """
    Get the last 5 security logs for a specific user.
    """
    # Simulated database fetch
    return {
        "logs": [f"Login at 2024-03-31 from 192.168.1.{user_id}", "Password change"],
        "user_id": user_id
    }
```

## 4. Why Use Resources Instead of Tools?

Use **Resources** when:
- The data is large and the AI only needs parts of it.
- You want the AI to *browse* or *read* rather than *act*.
- You want to provide context that the AI can reference multiple times.

Use **Tools** when:
- You want the AI to *perform an action* (e.g., send an email, update a DB).
- You want the AI to *calculate* something based on inputs.

---

## Today's Checklist
- [ ] Create a `@app.prompt()` for generating a security report.
- [ ] Implement a `@app.resource()` that exposes a simulated system log.
- [ ] Connect your server to a client and see your prompts and resources appear.

**Next:** We'll master **Day 5: Security Guardrails** by using `MCPcrunch` to audit our server.

[**Next: Day 5 — Security Guardrails →**](/docs/tutorials/day-5-security-guardrails/)
