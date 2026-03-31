---
title: "Prompt Templates"
linkTitle: "Prompts"
weight: 4
description: >
  Guiding the LLM with structured conversational templates.
---

Prompts in ProdMCP are used to provide the LLM with specific instructions or templates for a conversation. Unlike tools, prompts typically return a string that is injected into the conversation.

### Defining a Prompt

Use the `@app.prompt` decorator to register a template.

```python
from pydantic import BaseModel

class ExplainInput(BaseModel):
    topic: str

@app.prompt(
    name="explain_briefly",
    input_schema=ExplainInput
)
def explain_topic(topic: str) -> str:
    """Generate an explanation prompt."""
    return f"Please explain the following topic in 3 sentences: {topic}"
```

### How Prompts Work
When a client requests a prompt, ProdMCP:
1. Validates the input against the `input_schema`.
2. Calls your function with the destructured arguments.
3. Returns the resulting string to the client.

### Best Practices for Prompts
- **Be Explicit**: Use prompts to set strict constraints on the LLM's response style.
- **Use Metadata**: Descriptions for prompts are crucial for the LLM to understand when it should request a specific template.
- **Contextualize**: Pass relative information or "personality" through prompts to maintain consistency in AI behavior.
