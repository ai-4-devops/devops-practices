#!/usr/bin/env python3
"""
DevOps Practices MCP Server (using official MCP SDK)

Provides shared DevOps practices and templates for all example-project infrastructure projects.
"""

import asyncio
import logging
import os
import re
from datetime import datetime
from pathlib import Path

from mcp.server import Server
from mcp.server.stdio import stdio_server
from mcp.types import Tool, TextContent

# Configure logging to file (to avoid interfering with stdio protocol)
log_dir = os.path.expanduser('~/.cache/claude')
os.makedirs(log_dir, exist_ok=True)
log_file = os.path.join(log_dir, 'mcp-devops-practices.log')

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[logging.FileHandler(log_file)]
)
logger = logging.getLogger('devops-practices')

# Base directory (where this script is located)
BASE_DIR = Path(__file__).parent.absolute()
PRACTICES_DIR = BASE_DIR / 'practices'
TEMPLATES_DIR = BASE_DIR / 'templates'

# Create the MCP server
app = Server("devops-practices")


def load_practices() -> dict[str, str]:
    """Load all practice files from practices directory."""
    practices = {}
    if not PRACTICES_DIR.exists():
        logger.warning(f"Practices directory not found: {PRACTICES_DIR}")
        return practices

    for file_path in PRACTICES_DIR.glob('*.md'):
        practice_name = file_path.stem
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
                practices[practice_name] = content
            logger.info(f"Loaded practice: {practice_name} ({len(content)} chars)")
        except Exception as e:
            logger.error(f"Error loading practice {practice_name}: {e}")

    return practices


def load_templates() -> dict[str, str]:
    """Load all template files from templates directory."""
    templates = {}
    if not TEMPLATES_DIR.exists():
        logger.warning(f"Templates directory not found: {TEMPLATES_DIR}")
        return templates

    for file_path in TEMPLATES_DIR.glob('*.md'):
        template_name = file_path.stem
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                templates[template_name] = f.read()
            logger.info(f"Loaded template: {template_name}")
        except Exception as e:
            logger.error(f"Error loading template {template_name}: {e}")

    return templates


# Load all practices and templates at startup
PRACTICES = load_practices()
TEMPLATES = load_templates()

logger.info(f"Loaded {len(PRACTICES)} practices and {len(TEMPLATES)} templates")


@app.list_tools()
async def list_tools() -> list[Tool]:
    """List all available tools."""
    return [
        Tool(
            name="get_practice",
            description="Get a DevOps practice document by name",
            inputSchema={
                "type": "object",
                "properties": {
                    "name": {
                        "type": "string",
                        "description": 'Name of the practice (e.g., "air-gapped-workflow", "documentation-standards")'
                    }
                },
                "required": ["name"]
            }
        ),
        Tool(
            name="get_practice_summary",
            description="Get a brief summary of a practice (first ~500 chars). Lighter than get_practice, good for quick reference.",
            inputSchema={
                "type": "object",
                "properties": {
                    "name": {
                        "type": "string",
                        "description": "Name of the practice"
                    },
                    "max_chars": {
                        "type": "integer",
                        "description": "Maximum characters to return (default: 500)",
                        "default": 500
                    }
                },
                "required": ["name"]
            }
        ),
        Tool(
            name="list_practices",
            description="List all available DevOps practices with metadata",
            inputSchema={
                "type": "object",
                "properties": {}
            }
        ),
        Tool(
            name="search_practices",
            description="Search practices by keyword in name or content",
            inputSchema={
                "type": "object",
                "properties": {
                    "keyword": {
                        "type": "string",
                        "description": "Keyword to search for"
                    }
                },
                "required": ["keyword"]
            }
        ),
        Tool(
            name="get_template",
            description="Get a file template by name",
            inputSchema={
                "type": "object",
                "properties": {
                    "name": {
                        "type": "string",
                        "description": 'Name of the template (e.g., "TRACKER-template", "CURRENT-STATE-template")'
                    }
                },
                "required": ["name"]
            }
        ),
        Tool(
            name="list_templates",
            description="List all available file templates",
            inputSchema={
                "type": "object",
                "properties": {}
            }
        ),
        Tool(
            name="render_template",
            description="Render a template with variable substitution. Supports ${VAR} format. Auto-provides DATE, TIMESTAMP, USER, YEAR.",
            inputSchema={
                "type": "object",
                "properties": {
                    "name": {
                        "type": "string",
                        "description": 'Name of the template (e.g., "TRACKER-template", "RUNBOOK-template")'
                    },
                    "variables": {
                        "type": "object",
                        "description": 'Dictionary of variables to substitute (e.g., {"PROJECT_NAME": "my-project", "SESSION_NUMBER": "1"})',
                        "additionalProperties": {
                            "type": "string"
                        }
                    }
                },
                "required": ["name"]
            }
        )
    ]


@app.call_tool()
async def call_tool(name: str, arguments: dict) -> list[TextContent]:
    """Handle tool calls."""
    logger.info(f"Tool called: {name} with args: {arguments}")

    if name == "list_practices":
        practices_list = []
        for practice_name, content in PRACTICES.items():
            # Extract title from first heading
            title_match = re.search(r'^#\s+(.+)$', content, re.MULTILINE)
            title = title_match.group(1) if title_match else practice_name

            practices_list.append({
                'name': practice_name,
                'title': title,
                'size': f'{len(content)} chars'
            })

        # Sort by name
        practices_list.sort(key=lambda x: x['name'])

        text = "Available DevOps Practices:\n\n"
        for practice in practices_list:
            text += f"• **{practice['name']}**\n"
            text += f"  Title: {practice['title']}\n"
            text += f"  Size: {practice['size']}\n\n"

        return [TextContent(type="text", text=text)]

    elif name == "get_practice":
        practice_name = arguments.get("name", "")
        content = PRACTICES.get(practice_name)
        if content:
            return [TextContent(type="text", text=content)]
        else:
            available = ', '.join(PRACTICES.keys())
            raise ValueError(f'Practice not found: {practice_name}. Available: {available}')

    elif name == "get_practice_summary":
        practice_name = arguments.get("name", "")
        max_chars = arguments.get("max_chars", 500)
        content = PRACTICES.get(practice_name)
        if content:
            summary = content[:max_chars]
            if len(content) > max_chars:
                summary += "..."
            return [TextContent(type="text", text=summary)]
        else:
            available = ', '.join(PRACTICES.keys())
            raise ValueError(f'Practice not found: {practice_name}. Available: {available}')

    elif name == "search_practices":
        keyword = arguments.get("keyword", "").lower()
        if not keyword:
            raise ValueError("keyword parameter is required")

        results = []
        for practice_name, content in PRACTICES.items():
            # Search in name
            if keyword in practice_name.lower():
                results.append(practice_name)
                continue
            # Search in content
            if keyword in content.lower():
                results.append(practice_name)

        if results:
            text = f"Found {len(results)} practice(s) matching '{keyword}':\n\n"
            for practice_name in results:
                # Extract title
                content = PRACTICES[practice_name]
                title_match = re.search(r'^#\s+(.+)$', content, re.MULTILINE)
                title = title_match.group(1) if title_match else practice_name
                text += f"• {practice_name}: {title}\n"
            return [TextContent(type="text", text=text)]
        else:
            return [TextContent(type="text", text=f"No practices found matching '{keyword}'")]

    elif name == "list_templates":
        templates_list = list(TEMPLATES.keys())
        text = "Available templates:\n" + '\n'.join(f'- {t}' for t in templates_list)
        return [TextContent(type="text", text=text)]

    elif name == "get_template":
        template_name = arguments.get("name", "")
        content = TEMPLATES.get(template_name)
        if content:
            return [TextContent(type="text", text=content)]
        else:
            available = ', '.join(TEMPLATES.keys())
            raise ValueError(f'Template not found: {template_name}. Available: {available}')

    elif name == "render_template":
        template_name = arguments.get("name", "")
        variables = arguments.get("variables", {})

        template = TEMPLATES.get(template_name)
        if not template:
            available = ', '.join(TEMPLATES.keys())
            raise ValueError(f'Template not found: {template_name}. Available: {available}')

        # Default variables
        try:
            now_utc = datetime.now(datetime.UTC)
        except AttributeError:
            now_utc = datetime.utcnow()

        defaults = {
            'DATE': now_utc.strftime('%Y-%m-%d'),
            'TIMESTAMP': now_utc.strftime('%Y%m%dT%H%MZ'),
            'USER': os.getenv('USER', 'user'),
            'YEAR': str(now_utc.year),
        }

        # Merge user variables with defaults
        all_variables = {**defaults, **variables}

        # Perform substitution
        rendered = template
        for key, value in all_variables.items():
            rendered = rendered.replace(f'${{{key}}}', value)
            rendered = rendered.replace(f'${key}', value)

        return [TextContent(type="text", text=rendered)]

    else:
        raise ValueError(f'Unknown tool: {name}')


async def main():
    """Run the MCP server."""
    async with stdio_server() as (read_stream, write_stream):
        logger.info("Starting DevOps Practices MCP Server")
        logger.info(f"Base directory: {BASE_DIR}")
        logger.info(f"Practices loaded: {', '.join(sorted(PRACTICES.keys()))}")
        logger.info(f"Templates loaded: {', '.join(sorted(TEMPLATES.keys()))}")
        logger.info(f"Log file: {log_file}")

        await app.run(
            read_stream,
            write_stream,
            app.create_initialization_options()
        )


if __name__ == '__main__':
    asyncio.run(main())
