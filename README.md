# ProdMCP Documentation Hub

The unified documentation site for the **ProdMCP** open-source ecosystem — built with [Hugo](https://gohugo.io/) and the [Google Docsy](https://www.docsy.dev/) theme.

## What's Inside

| Section | Description |
|---|---|
| [OpenMCP Specification](content/docs/openmcp-spec/) | The open standard for describing MCP servers — OpenAPI for MCP |
| [MCPcrunch](content/docs/mcpcrunch/) | Security & structural validation for OpenMCP specs |
| [ProdMCP Framework](content/docs/prodmcp/) | FastAPI-like production framework for MCP servers |
| [Master Course](content/docs/tutorials/) | 7-day curriculum from foundations to production deployment |

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

Build the production site:

```bash
make build
```

The static site is output to `./public` and can be deployed to any static hosting provider (GitHub Pages, Netlify, Vercel, Cloudflare Pages, etc.).

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b docs/my-improvement`)
3. Make your changes and preview with `make serve`
4. Commit and push
5. Open a Pull Request

## License

This project is part of the [ProdMCP](https://github.com/ProdMCP) organization and is open source.
