---
title: "Formal Specification"
linkTitle: "Specification"
weight: 2
description: >
  The complete OpenMCP v1.0.0 specification — all objects, fields, and data types.
---

## Version 1.0.0

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in [BCP 14](https://tools.ietf.org/html/bcp14) [RFC2119](https://tools.ietf.org/html/rfc2119) [RFC8174](https://tools.ietf.org/html/rfc8174) when, and only when, they appear in all capitals.

## Format

An OpenMCP document is a JSON object, which may be represented in either JSON or YAML format. All field names are **case-sensitive** unless explicitly noted otherwise.

### Rich Text Formatting

`description` fields support markdown formatting. Tooling MUST support, at a minimum, [CommonMark 0.27](https://spec.commonmark.org/0.27/).

---

## Root Object

The root object of the OpenMCP Description.

| Field Name | Type | Description |
| :--- | :---: | :--- |
| `openmcp` | `string` | **REQUIRED.** Specification version (e.g., `"1.0.0"`). |
| `info` | [Info Object](#info-object) | **REQUIRED.** Server metadata. |
| `servers` | [[Server Object](#server-object)] | Connectivity information. |
| `tools` | Map[`string`, [Tool Object](#tool-object)] | Available tools. |
| `prompts` | Map[`string`, [Prompt Object](#prompt-object)] | Available prompts. |
| `resources` | Map[`string`, [Resource Object](#resource-object)] | Available resources. |
| `components` | [Components Object](#components-object) | Reusable definitions. |

---

## Info Object

Provides metadata about the MCP server.

| Field Name | Type | Description |
| :--- | :---: | :--- |
| `title` | `string` | **REQUIRED.** Server title. |
| `version` | `string` | **REQUIRED.** Implementation version. |
| `description` | `string` | Server description (CommonMark). |
| `termsOfService` | `string` | URL to Terms of Service. |
| `contact` | [Contact Object](#contact-object) | Contact information. |
| `license` | [License Object](#license-object) | License information. |
| `externalDocs` | [External Documentation Object](#external-documentation-object) | Additional docs. |

### Contact Object

| Field Name | Type | Description |
| ---- | :----: | ---- |
| `name` | `string` | Contact person/organization name. |
| `url` | `string` | Contact URL. |
| `email` | `string` | Contact email. |

### License Object

| Field Name | Type | Description |
| ---- | :----: | ---- |
| `name` | `string` | **REQUIRED.** License name. |
| `url` | `string` | License URL. |

### External Documentation Object

| Field Name | Type | Description |
| ---- | :----: | ---- |
| `description` | `string` | Target documentation description. |
| `url` | `string` | **REQUIRED.** Documentation URL. |

### Info Object Example

```yaml
title: Sample MCP Server
version: 1.0.0
description: A server providing user management tools.
contact:
  name: Support
  url: https://example.com/support
license:
  name: MIT
  url: https://opensource.org/licenses/MIT
```

---

## Server Object

| Field Name | Type | Description |
| :--- | :---: | :--- |
| `url` | `string` | **REQUIRED.** Target host URL. |
| `description` | `string` | Host description. |

---

## Tool Object

Describes an executable tool available via JSON-RPC.

| Field Name | Type | Description |
| :--- | :---: | :--- |
| `description` | `string` | Tool description (CommonMark). |
| `input` | Schema \| Reference | **REQUIRED.** Input parameter schema. |
| `output` | Schema \| Reference | **REQUIRED.** Result schema. |
| `security` | [[Security Requirement](#components-object)] | Required security mechanisms. |

### Tool Example

```yaml
description: Get details for a specific user.
input:
  $ref: '#/components/schemas/UserInput'
output:
  $ref: '#/components/schemas/UserOutput'
security:
  - bearerAuth: ["admin"]
```

---

## Prompt Object

| Field Name | Type | Description |
| :--- | :---: | :--- |
| `description` | `string` | Prompt description (CommonMark). |
| `input` | Schema \| Reference | **REQUIRED.** Arguments schema. |
| `output` | Schema \| Reference | **REQUIRED.** Result schema. |

### Prompt Example

```yaml
description: Summarize the provided document.
input:
  type: object
  properties:
    document:
      type: string
output:
  type: object
  properties:
    summary:
      type: string
```

---

## Resource Object

| Field Name | Type | Description |
| :--- | :---: | :--- |
| `description` | `string` | Resource description (CommonMark). |
| `output` | Schema \| Reference | **REQUIRED.** Resource data schema. |

### Resource Example

```yaml
description: Current system health metrics.
output:
  type: object
  properties:
    cpu_usage:
      type: number
    memory_available:
      type: integer
```

---

## Components Object

| Field Name | Type | Description |
| :--- | :---: | :--- |
| `schemas` | Map[`string`, Schema] | Reusable JSON Schema definitions. |
| `securitySchemes` | Map[`string`, [Security Scheme](#security-scheme-object)] | Reusable security schemes. |

---

## Security Scheme Object

| Field Name | Type | Description |
| :--- | :---: | :--- |
| `type` | `string` | **REQUIRED.** `apiKey` or `http`. |
| `name` | `string` | **REQUIRED** for `apiKey`. Header/query param name. |
| `in` | `string` | **REQUIRED** for `apiKey`. Location: `header`, `query`, `cookie`. |
| `scheme` | `string` | **REQUIRED** for `http`. Auth scheme (e.g., `bearer`). |
| `bearerFormat` | `string` | Format hint (e.g., `JWT`). |

---

## Reference Object

Uses [JSON Reference](https://tools.ietf.org/html/draft-pbryan-zyp-json-ref-03) with [JSON Pointer](https://tools.ietf.org/html/rfc6901).

| Field Name | Type | Description |
| :--- | :---: | :--- |
| `$ref` | `string` | **REQUIRED.** URI reference to target. |
| `summary` | `string` | Short summary. |
| `description` | `string` | Description (CommonMark). |

### Reference Example

```yaml
$ref: '#/components/schemas/Pet'
description: A reference to the Pet schema.
```

---

## Schema Object

OpenMCP uses **JSON Schema Draft 7** for data modeling. Supported fields include:

`title`, `type`, `description`, `format`, `default`, `enum`, `required`, `properties`, `additionalProperties`, `items`, `allOf`, `oneOf`, `anyOf`, `not`, `minimum`, `maximum`, `exclusiveMinimum`, `exclusiveMaximum`, `minLength`, `maxLength`, `pattern`, `minItems`, `maxItems`, `uniqueItems`, `minProperties`, `maxProperties`, `multipleOf`.

### Schema Example

```yaml
type: object
properties:
  id:
    type: string
    format: uuid
  username:
    type: string
    minLength: 3
required:
  - id
  - username
```

---

## Specification Extensions

The OpenMCP Specification is versioned using `major.minor.patch`. Custom fields MUST begin with `x-` to avoid conflicts:

```json
"x-internal-id": "123456"
```
