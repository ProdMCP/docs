# ProdMCP Documentation Hub

The unified documentation site for the **ProdMCP** open-source ecosystem — built with [Hugo](https://gohugo.io/) and the [Google Docsy](https://www.docsy.dev/) theme.

## What's Inside

| Section | Description |
|---|---|
| [OpenMCP Specification](content/docs/openmcp-spec/) | The open standard for describing MCP servers — OpenAPI for MCP |
| [MCPcrunch](content/docs/mcpcrunch/) | Security & structural validation for OpenMCP specs |
| [ProdMCP Framework](content/docs/prodmcp/) | FastAPI-like production framework for MCP servers |
| [7 Day Tutorial](content/docs/tutorials/) | 7-day curriculum from foundations to production deployment |

## Prerequisites

| Tool | Version | Install |
|---|---|---|
| [Hugo (extended)](https://gohugo.io/installation/) | ≥ 0.147.0 | `brew install hugo` |
| [Go](https://go.dev/dl/) | ≥ 1.23 | `brew install go` |
| [Node.js](https://nodejs.org/) | ≥ 18 | `brew install node` |

## Quick Start

```bash
# Clone the repository
git clone https://github.com/ProdMCP/docs.git
cd docs

# Install Node dependencies (PostCSS, Autoprefixer)
npm install

# Fetch Hugo modules (Docsy theme)
hugo mod get

# Start the development server
hugo server
```

The site will be available at **http://localhost:1313**.

## Using the Makefile

A `Makefile` is provided for common tasks:

```bash
make install    # Install all dependencies (npm + Hugo modules)
make serve      # Start dev server with live reload + drafts
make build      # Build production site to ./public
make clean      # Remove generated files (public/, resources/, hugo_stats.json)
make lint       # Check for broken internal links
make update     # Update Hugo modules to latest versions
make help       # Show all available targets
```

## Project Structure

```
docs/
├── archetypes/          # Hugo content templates
├── assets/
│   └── scss/            # Custom SCSS overrides
├── content/
│   ├── _index.md        # Landing page
│   └── docs/
│       ├── mcpcrunch/   # MCPcrunch documentation
│       ├── openmcp-spec/# OpenMCP Specification docs
│       ├── prodmcp/     # ProdMCP framework docs
│       └── tutorials/   # 7-day master course
├── layouts/             # Custom Hugo layout overrides
├── static/
│   └── images/          # Project logos and assets
├── go.mod               # Hugo module dependencies
├── hugo.toml            # Hugo site configuration
├── package.json         # Node dependencies (PostCSS)
└── Makefile             # Build automation
```

## Adding Content

Create a new documentation page:

```bash
hugo new docs/section-name/page-title.md
```

Pages use standard Hugo front matter:

```yaml
---
title: "Page Title"
linkTitle: "Short Title"
weight: 10
description: "Brief description for SEO and navigation."
---

Your markdown content here.
```

## Deployment

The site is deployed automatically to [Azure Static Web Apps](https://azure.microsoft.com/en-us/products/app-service/static) via GitHub Actions on every push to `main`. The production site is available at **https://prodmcp.org**.

### CI/CD Pipeline

The workflow (`.github/workflows/deploy.yml`) runs on every push to `main` and on pull requests:

- **Push to `main`** → builds Hugo and deploys to production
- **Pull requests** → creates a staging preview environment
- **PR closed** → automatically cleans up the staging environment

### Initial Azure Setup

1. **Create an Azure Static Web App** in the [Azure Portal](https://portal.azure.com):
   - Click **Create a resource** → search **Static Web App** → **Create**
   - Select your subscription and resource group
   - Name: `prodmcp-docs`
   - Plan: **Free**
   - Deployment source: **GitHub** → authorize and select `ProdMCP/docs` repo
   - Branch: `main`
   - Build preset: **Custom**
   - App location: `public`
   - Skip the auto-generated workflow (we have our own)

2. **Get the deployment token** from Azure Portal:
   - Go to your Static Web App → **Manage deployment token**
   - Copy the token

3. **Add the token as a GitHub secret**:
   - Go to `github.com/ProdMCP/docs` → **Settings** → **Secrets and variables** → **Actions**
   - Create secret: `AZURE_STATIC_WEB_APPS_API_TOKEN` with the token value

### Custom Domain (prodmcp.org via GoDaddy)

1. **In Azure Portal** → your Static Web App → **Custom domains** → **Add**:
   - Add `prodmcp.org` (root domain)
   - Add `www.prodmcp.org` (subdomain)

2. **In GoDaddy DNS settings** for `prodmcp.org`, add these records:

   | Type | Name | Value | TTL |
   |------|------|-------|-----|
   | `CNAME` | `www` | `<your-app>.azurestaticapps.net` | 1 Hour |
   | `A` | `@` | *(IP from Azure validation)* | 1 Hour |
   | `TXT` | `@` | *(validation token from Azure)* | 1 Hour |

   > **Note:** The exact CNAME value and TXT validation token are provided by Azure when you add the custom domain. Azure will auto-provision a free SSL certificate once DNS propagates.

3. **Verify** in Azure Portal — once DNS propagates (usually < 30 min), the domain status will show ✅ and SSL will be provisioned automatically.

### Manual Build

To build the production site locally:

```bash
make build
```

The static output in `./public` can also be deployed manually to any hosting provider.

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b docs/my-improvement`)
3. Make your changes and preview with `make serve`
4. Commit and push
5. Open a Pull Request

## License

This project is part of the [ProdMCP](https://github.com/ProdMCP) organization and is open source.
