---
title: "JSON Schemas"
linkTitle: "Schemas"
weight: 3
description: >
  JSON Schema files for validating OpenMCP documents.
---

## Validation Schema

The OpenMCP project provides a JSON Schema that can be used to validate any OpenMCP document against the specification. This ensures your MCP server descriptions are well-formed before deployment.

### Using the Schema

You can validate an OpenMCP document using any JSON Schema Draft 7 compatible validator:

**Python (jsonschema)**:
```python
import json
import jsonschema

# Load the schema
with open("schema.json") as f:
    schema = json.load(f)

# Load your OpenMCP document
with open("my-server.json") as f:
    document = json.load(f)

# Validate
jsonschema.validate(document, schema)
print("✅ Document is valid!")
```

**Node.js (ajv)**:
```javascript
const Ajv = require("ajv");
const ajv = new Ajv();
const schema = require("./schema.json");
const document = require("./my-server.json");

const validate = ajv.compile(schema);
const valid = validate(document);

if (valid) {
  console.log("✅ Document is valid!");
} else {
  console.log("❌ Validation errors:", validate.errors);
}
```

**CLI (MCPcrunch)**:
```bash
mcpcrunch my-server.json --schema schema.json
```

> For comprehensive security-focused validation, see the [MCPcrunch documentation](../../mcpcrunch/).

### Schema Structure

The validation schema enforces:

| Area | What's Validated |
|------|-----------------|
| **Root** | `openmcp` version string, `info` presence |
| **Info** | Required `title` and `version` fields |
| **Tools** | `input` and `output` schema presence |
| **Prompts** | `input` and `output` schema presence |
| **Resources** | `output` schema presence |
| **Security** | Valid `securitySchemes` structure |
| **$ref** | Proper JSON Reference formatting |

### Download

The schema is available in the [OpenMCP-spec repository](https://github.com/prodmcp/openmcp-spec) under `schemas/v1.0.0/schema.json`.
