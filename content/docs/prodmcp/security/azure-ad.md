---
title: "Azure AD / Entra ID Auth"
description: "Plug-and-play Azure Active Directory authentication for ProdMCP — JWKS JWT validation, role enforcement, and On-Behalf-Of token exchange in minutes."
weight: 20
---

# Azure AD / Entra ID Authentication

ProdMCP v0.3.11+ ships a first-class Azure Active Directory (Entra ID) integration that handles:

- **RS256 JWT validation** via live JWKS (1-hour cached per tenant)
- **Multi-format issuer/audience** acceptance (v1 + v2 endpoints)
- **Role-based access control** — `ctx.require_role("admin")`
- **On-Behalf-Of (OBO) token exchange** — call downstream Azure APIs as the user
- **Full MCP tool security** — tokens validated for both REST routes and MCP protocol calls (Bug 10 fix)

## Installation

```bash
pip install prodmcp python-jose[cryptography]
```

`python-jose[cryptography]` is required for RS256 JWT verification.

## Quick start

```python
from prodmcp import ProdMCP, Depends
from prodmcp.integrations.azure import AzureADAuth, AzureADTokenContext

auth = AzureADAuth.from_env()          # reads from environment variables
app  = ProdMCP("MyServer")
app.add_security_scheme("bearer", auth.bearer_scheme)

@app.tool()
@app.get("/data")
@app.common(security=[{"bearer": []}])
def get_data(ctx: AzureADTokenContext = Depends(auth.require_context)) -> dict:
    ctx.require_role("admin")           # → HTTP 403 if role absent
    obo = ctx.get_obo_token()           # On-Behalf-Of exchange
    return {"user": ctx.user_info, "obo_scope": obo.get("scope")}

app.run()
```

## Environment variables

`AzureADAuth.from_env()` reads these variables automatically:

| Variable | Required | Description |
|---|---|---|
| `TENANT_ID` | ✅ | Azure AD tenant GUID or domain (e.g. `contoso.onmicrosoft.com`) |
| `BACKEND_CLIENT_ID` | ✅ | App registration client ID |
| `BACKEND_CLIENT_SECRET` | ✅ | App registration client secret (used for OBO) |
| `API_AUDIENCE` | optional | Expected `aud` claim. Defaults to `api://{client_id}` |
| `OBO_SCOPE` | optional | Default downstream OBO scope. Defaults to `https://graph.microsoft.com/.default` |

```bash
export TENANT_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
export BACKEND_CLIENT_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
export BACKEND_CLIENT_SECRET="your-secret"
```

## Explicit constructor

If you prefer not to use environment variables:

```python
auth = AzureADAuth(
    tenant_id="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    client_id="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    client_secret="your-secret",
    api_audience="api://your-client-id",          # optional
    obo_scope="https://graph.microsoft.com/.default",  # optional
    extra_audiences=["api://other-id"],           # optional
    extra_issuers=["https://custom-sts.example.com/"],  # optional
)
```

## AzureADTokenContext reference

Every authenticated handler receives an `AzureADTokenContext` via `Depends(auth.require_context)`:

```python
def my_tool(ctx: AzureADTokenContext = Depends(auth.require_context)) -> dict:
    # Raw JWT string
    token: str = ctx.token

    # Full decoded claims dict
    claims: dict = ctx.claims

    # Convenience user info
    info = ctx.user_info
    # → {"oid": ..., "tid": ..., "name": ..., "preferred_username": ...,
    #    "aud": ..., "scp": ..., "roles": [...]}

    # Role helpers
    roles: list[str] = ctx.roles
    ctx.has_role("reader")       # → bool
    ctx.require_role("admin")    # → raises HTTP 403 if absent

    # On-Behalf-Of token exchange
    obo = ctx.get_obo_token()
    # → {"access_token": "...", "token_type": "Bearer", "expires_in": 3600, ...}

    obo_graph = ctx.get_obo_token("https://graph.microsoft.com/.default")
```

## Role enforcement

```python
@app.tool()
@app.common(security=[{"bearer": []}])
def admin_only(ctx: AzureADTokenContext = Depends(auth.require_context)) -> dict:
    ctx.require_role("admin")    # HTTP 403 with descriptive message if role missing
    return {"status": "ok"}

@app.tool()
@app.common(security=[{"bearer": []}])
def flexible(ctx: AzureADTokenContext = Depends(auth.require_context)) -> dict:
    if ctx.has_role("premium"):
        return {"quota": 1000}
    return {"quota": 100}
```

## On-Behalf-Of (OBO) flow

OBO lets your MCP server call downstream Azure APIs (Microsoft Graph, custom APIs) **as the calling user** rather than as a service principal:

```python
@app.tool()
@app.common(security=[{"bearer": []}])
def call_graph(ctx: AzureADTokenContext = Depends(auth.require_context)) -> dict:
    # Exchange caller's token for a Graph API token
    graph_token = ctx.get_obo_token("https://graph.microsoft.com/.default")

    import requests
    me = requests.get(
        "https://graph.microsoft.com/v1.0/me",
        headers={"Authorization": f"Bearer {graph_token['access_token']}"},
    ).json()
    return {"display_name": me.get("displayName")}
```

OBO errors produce descriptive 400/502 responses with actionable hints for common failure codes (`invalid_grant`, `invalid_scope`, `unauthorized_client`, `interaction_required`).

## How it works

```
Request (Authorization: Bearer <JWT>)
        │
        ▼
AzureADBearerScheme.extract()
        │  fetch JWKS from login.microsoftonline.com (cached 1h)
        │  validate RS256 signature, audience, issuer, expiry
        ▼
AzureADTokenContext injected via Depends(auth.require_context)
        │
        ▼
Handler — ctx.require_role() / ctx.get_obo_token()
```

JWKS and OpenID configuration are cached **per tenant** for one hour, shared across all `AzureADAuth` instances, so startup is fast and hot-path latency is minimal.

## Azure app registration checklist

1. **Register a backend API app** in Azure AD → note the **Application (client) ID** and **Directory (tenant) ID**
2. **Add a client secret** → copy the secret value into `BACKEND_CLIENT_SECRET`
3. **Expose an API** → add a scope (e.g. `access_as_user`) → set `Application ID URI` (becomes your `api://client-id` audience)
4. **Add app roles** (optional) → e.g. `admin`, `reader` — these appear in the `roles` claim
5. **API permissions** for OBO → add delegated permissions for downstream APIs (e.g. `User.Read` for Graph) and **grant admin consent**

## MCP tools + Azure auth (v0.3.10+)

ProdMCP v0.3.10 fixed a critical bug where MCP tool calls (via the MCP protocol) were **always failing** security checks even with valid tokens. The fix injects HTTP request headers from the FastMCP context into the security layer, so `Depends(auth.require_context)` works identically for both REST routes and MCP tool calls.

```python
# This now works correctly over BOTH REST and MCP protocol:
@app.tool()
@app.get("/secure")
@app.common(security=[{"bearer": []}])
def secure_tool(ctx: AzureADTokenContext = Depends(auth.require_context)) -> dict:
    return ctx.user_info
```
{{< callout type="info" >}}
No code changes needed — both transports are automatically secured as of v0.3.10.
{{< /callout >}}
