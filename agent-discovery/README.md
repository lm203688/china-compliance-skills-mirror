# Agent Discovery Protocol Files

This directory contains all agent discovery protocol files for China Compliance Tools. These files enable AI agents to automatically discover and interact with our services.

## Files Overview

| File | Protocol | Purpose | Who Uses It |
|------|----------|---------|-------------|
| `agent.json` | Agent Discovery | W3C-style agent metadata | AI agents, agent directories |
| `.well-known/ai-plugin.json` | OpenAI Plugin | ChatGPT plugin manifest | ChatGPT, GPTs |
| `.well-known/openapi.json` | OpenAPI 3.1 | API specification | All API consumers, code generators |
| `.well-known/schema-org.jsonld` | JSON-LD / Schema.org | Structured data for search engines | Google, Bing, AI crawlers |
| `mcp-config.json` | MCP (Model Context Protocol) | Tool definitions for MCP clients | Claude, Cursor, Windsurf |
| `llms.txt` | llms.txt | Human-readable service description | LLMs crawling the website |

## Deployment

These files need to be served from the web app's SCF handler. Add the following routes:

### Static file routes in SCF handler

```python
# In scf_handler.py, add these routes:

AGENT_DISCOVERY_DIR = "/path/to/agent-discovery"

ROUTES = {
    "/agent.json": ("application/json", "agent.json"),
    "/.well-known/ai-plugin.json": ("application/json", ".well-known/ai-plugin.json"),
    "/.well-known/openapi.json": ("application/json", ".well-known/openapi.json"),
    "/.well-known/schema-org.jsonld": ("application/ld+json", ".well-known/schema-org.jsonld"),
    "/mcp-config.json": ("application/json", "mcp-config.json"),
    "/llms.txt": ("text/plain", "llms.txt"),
}
```

### HTML head additions

Add to every HTML page's `<head>`:

```html
<!-- Agent Discovery -->
<link rel="agent" type="application/json" href="/agent.json">
<link rel="ai-plugin" type="application/json" href="/.well-known/ai-plugin.json">
<link rel="service-desc" type="application/json" href="/.well-known/openapi.json">
<script type="application/ld+json">
  <!-- Contents of .well-known/schema-org.jsonld -->
</script>
```

## Verification

After deployment, verify each protocol:

```bash
# Agent discovery
curl https://YOUR_DOMAIN/agent.json

# OpenAI plugin
curl https://YOUR_DOMAIN/.well-known/ai-plugin.json

# OpenAPI spec
curl https://YOUR_DOMAIN/.well-known/openapi.json

# Schema.org structured data
curl https://YOUR_DOMAIN/.well-known/schema-org.jsonld

# MCP config
curl https://YOUR_DOMAIN/mcp-config.json

# llms.txt
curl https://YOUR_DOMAIN/llms.txt
```

## Protocol Details

### agent.json
W3C-style agent metadata format. Describes the agent's capabilities, authentication, and API endpoints. Used by agent directories and AI agent platforms.

### ai-plugin.json
OpenAI's plugin manifest format. Enables ChatGPT to discover and use our API. Requires OpenAPI spec URL.

### OpenAPI 3.1
Full API specification. Used by code generators, API testing tools, and AI agents that understand OpenAPI.

### JSON-LD / Schema.org
Structured data for search engines. Helps Google and Bing understand our service. Includes pricing, features, and action definitions.

### MCP Config
Model Context Protocol configuration. Enables Claude, Cursor, and other MCP clients to connect to our tools.

### llms.txt
Human-readable service description following the llms.txt convention. Helps LLMs understand our service when crawling our website.
