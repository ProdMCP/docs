# ──────────────────────────────────────────────────────────────
# ProdMCP Documentation — Build Automation
# ──────────────────────────────────────────────────────────────

.PHONY: help install serve build clean lint update mod-tidy new

# Default target
.DEFAULT_GOAL := help

# ──────────────────────────────────────────────────────────────
# Configuration
# ──────────────────────────────────────────────────────────────

HUGO        := hugo
NPM         := npm
PORT        := 1313
BUILD_DIR   := public
BIND        := 0.0.0.0

# ──────────────────────────────────────────────────────────────
# Targets
# ──────────────────────────────────────────────────────────────

## install: Install all dependencies (npm packages + Hugo modules)
install:
	@echo "📦 Installing Node dependencies..."
	$(NPM) install
	@echo "📦 Fetching Hugo modules..."
	$(HUGO) mod get
	@echo "✅ All dependencies installed."

## serve: Start the Hugo dev server with live reload and drafts
serve:
	@echo "🚀 Starting dev server at http://localhost:$(PORT) ..."
	$(HUGO) server \
		--buildDrafts \
		--port $(PORT) \
		--bind $(BIND) \
		--disableFastRender

## build: Build the production site to ./public
build: clean
	@echo "🔨 Building production site..."
	$(HUGO) --minify
	@echo "✅ Site built to ./$(BUILD_DIR)"

## clean: Remove generated files
clean:
	@echo "🧹 Cleaning generated files..."
	rm -rf $(BUILD_DIR) resources/_gen hugo_stats.json .hugo_build.lock
	@echo "✅ Clean complete."

## lint: Check for broken internal links (requires htmltest — brew install htmltest)
lint: build
	@echo "🔍 Checking for broken links..."
	@command -v htmltest >/dev/null 2>&1 && htmltest $(BUILD_DIR) || \
		(echo "⚠️  htmltest not found. Install with: brew install htmltest" && \
		 echo "   Falling back to grep-based check..." && \
		 grep -rn 'href="[^"]*"' $(BUILD_DIR) | grep -i '404' || echo "No obvious 404 references found.")

## update: Update Hugo modules to latest versions
update:
	@echo "⬆️  Updating Hugo modules..."
	$(HUGO) mod get -u
	$(HUGO) mod tidy
	@echo "✅ Modules updated."

## mod-tidy: Tidy Hugo module dependencies
mod-tidy:
	@echo "🧹 Tidying Hugo modules..."
	$(HUGO) mod tidy
	@echo "✅ Modules tidied."

## new: Create a new content page (usage: make new PAGE=docs/section/page.md)
new:
ifndef PAGE
	@echo "❌ Usage: make new PAGE=docs/section/page-name.md"
	@exit 1
endif
	$(HUGO) new $(PAGE)
	@echo "✅ Created content/$(PAGE)"

## help: Show this help message
help:
	@echo ""
	@echo "  ProdMCP Documentation — Available Targets"
	@echo "  ──────────────────────────────────────────"
	@grep -E '^## ' Makefile | \
		sed 's/^## //' | \
		awk -F: '{printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2}'
	@echo ""
