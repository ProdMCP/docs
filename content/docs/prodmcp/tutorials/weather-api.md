---
title: "Building a Weather Tool"
linkTitle: "Weather Tool"
weight: 1
description: >
  Learn how to wrap an external REST API with Pydantic validation.
---

In this tutorial, we will build a tool that fetches live weather data. We'll focus on defining clear input/output schemas so the LLM knows exactly what data it can expect.

### 1. Define the Schemas

```python
from pydantic import BaseModel, Field

class WeatherInput(BaseModel):
    city: str = Field(..., description="The city name, e.g., 'London'")
    unit: str = Field(default="celsius", pattern="^(celsius|fahrenheit)$")

class WeatherOutput(BaseModel):
    temperature: float
    description: str
    wind_speed: float
```

### 2. Implement the Tool

```python
import httpx
from prodmcp import ProdMCP

app = ProdMCP("WeatherServer")

@app.tool(input_schema=WeatherInput, output_schema=WeatherOutput)
async def get_weather(city: str, unit: str):
    """Fetch live weather for a city."""
    url = f"https://api.weather.com/v1/{city}?unit={unit}"
    
    async with httpx.AsyncClient() as client:
        # In a real app, you'd handle API keys and errors here
        resp = await client.get(url)
        data = resp.json()
        
    return {
        "temperature": data["temp"],
        "description": data["weather"][0]["main"],
        "wind_speed": data["wind"]["speed"]
    }
```

### 3. Why this is "Production"
- **LLM Context**: The `Field(description=...)` tells the AI agent exactly what to provide.
- **Validation**: If the API returns a string for `temperature` instead of a float, ProdMCP's `strict_output` will catch it.
- **Pattern Matching**: The `unit` field is locked to only two valid strings via regex.
