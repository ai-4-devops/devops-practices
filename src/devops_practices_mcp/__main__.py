#!/usr/bin/env python3
"""
DevOps Practices MCP Server

Provides shared DevOps practices and templates for all example-project infrastructure projects.
"""

import json
import logging
import os
import re
import sys
from datetime import datetime
from pathlib import Path
from typing import Any

# Configure logging to file instead of stderr (to avoid interfering with stdio protocol)
import os
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


class MCPServer:
    """Simple MCP server for serving DevOps practices and templates."""

    def __init__(self):
        self.practices = self._load_practices()
        self.templates = self._load_templates()
        logger.info(f"Loaded {len(self.practices)} practices and {len(self.templates)} templates")

    def _load_practices(self) -> dict[str, str]:
        """Load all practice files from practices directory."""
        practices = {}
        if not PRACTICES_DIR.exists():
            logger.warning(f"Practices directory not found: {PRACTICES_DIR}")
            return practices

        for file_path in PRACTICES_DIR.glob('*.md'):
            practice_name = file_path.stem
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    practices[practice_name] = f.read()
                logger.info(f"Loaded practice: {practice_name}")
            except Exception as e:
                logger.error(f"Error loading practice {practice_name}: {e}")

        return practices

    def _load_templates(self) -> dict[str, str]:
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

    def get_practice(self, name: str) -> str | None:
        """Get a practice by name."""
        practice = self.practices.get(name)
        if practice:
            logger.info(f"Serving practice: {name}")
        else:
            logger.warning(f"Practice not found: {name}")
        return practice

    def list_practices(self) -> list[str]:
        """List all available practices."""
        return list(self.practices.keys())

    def get_template(self, name: str) -> str | None:
        """Get a template by name."""
        template = self.templates.get(name)
        if template:
            logger.info(f"Serving template: {name}")
        else:
            logger.warning(f"Template not found: {name}")
        return template

    def list_templates(self) -> list[str]:
        """List all available templates."""
        return list(self.templates.keys())

    def render_template(self, name: str, variables: dict[str, str] | None = None) -> str | None:
        """
        Render a template with variable substitution.

        Args:
            name: Template name
            variables: Dictionary of variable values to substitute

        Returns:
            Rendered template content or None if template not found
        """
        template = self.templates.get(name)
        if not template:
            logger.warning(f"Template not found: {name}")
            return None

        # Default variables
        # Use timezone-aware datetime (Python 3.11+) or fallback to utcnow()
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

        # Merge user variables with defaults (user variables take precedence)
        all_variables = {**defaults, **(variables or {})}

        # Perform substitution
        rendered = template
        for key, value in all_variables.items():
            # Support both ${VAR} and $VAR formats
            rendered = rendered.replace(f'${{{key}}}', value)
            rendered = rendered.replace(f'${key}', value)

        logger.info(f"Rendered template: {name} with {len(all_variables)} variables")
        return rendered

    def handle_request(self, request: dict[str, Any]) -> dict[str, Any]:
        """Handle an MCP request."""
        method = request.get('method', '')
        params = request.get('params', {})

        logger.info(f"Handling request: {method}")

        try:
            if method == 'initialize':
                return self._initialize(params)
            elif method == 'tools/list':
                return self._list_tools()
            elif method == 'tools/call':
                return self._call_tool(params)
            else:
                return {
                    'error': {
                        'code': -32601,
                        'message': f'Method not found: {method}'
                    }
                }
        except Exception as e:
            logger.error(f"Error handling request: {e}", exc_info=True)
            return {
                'error': {
                    'code': -32603,
                    'message': f'Internal error: {str(e)}'
                }
            }

    def _initialize(self, params: dict[str, Any]) -> dict[str, Any]:
        """Handle MCP initialize request."""
        return {
            'result': {
                'protocolVersion': '2024-11-05',
                'capabilities': {
                    'tools': {}
                },
                'serverInfo': {
                    'name': 'devops-practices',
                    'version': '1.4.0'
                }
            }
        }

    def _list_tools(self) -> dict[str, Any]:
        """Return list of available tools."""
        return {
            'result': {
                'tools': [
                    {
                        'name': 'get_practice',
                        'description': 'Get a DevOps practice document by name',
                        'inputSchema': {
                            'type': 'object',
                            'properties': {
                                'name': {
                                    'type': 'string',
                                    'description': 'Name of the practice (e.g., "air-gapped-workflow", "documentation-standards")'
                                }
                            },
                            'required': ['name']
                        }
                    },
                    {
                        'name': 'list_practices',
                        'description': 'List all available DevOps practices',
                        'inputSchema': {
                            'type': 'object',
                            'properties': {}
                        }
                    },
                    {
                        'name': 'get_template',
                        'description': 'Get a file template by name',
                        'inputSchema': {
                            'type': 'object',
                            'properties': {
                                'name': {
                                    'type': 'string',
                                    'description': 'Name of the template (e.g., "TRACKER-template", "CURRENT-STATE-template")'
                                }
                            },
                            'required': ['name']
                        }
                    },
                    {
                        'name': 'list_templates',
                        'description': 'List all available file templates',
                        'inputSchema': {
                            'type': 'object',
                            'properties': {}
                        }
                    },
                    {
                        'name': 'render_template',
                        'description': 'Render a template with variable substitution. Supports ${VAR} format. Auto-provides DATE, TIMESTAMP, USER, YEAR.',
                        'inputSchema': {
                            'type': 'object',
                            'properties': {
                                'name': {
                                    'type': 'string',
                                    'description': 'Name of the template (e.g., "TRACKER-template", "RUNBOOK-template")'
                                },
                                'variables': {
                                    'type': 'object',
                                    'description': 'Dictionary of variables to substitute (e.g., {"PROJECT_NAME": "my-project", "SESSION_NUMBER": "1"})',
                                    'additionalProperties': {
                                        'type': 'string'
                                    }
                                }
                            },
                            'required': ['name']
                        }
                    }
                ]
            }
        }

    def _call_tool(self, params: dict[str, Any]) -> dict[str, Any]:
        """Call a tool with given parameters."""
        tool_name = params.get('name', '')
        tool_args = params.get('arguments', {})

        logger.info(f"Calling tool: {tool_name} with args: {tool_args}")

        if tool_name == 'get_practice':
            practice_name = tool_args.get('name', '')
            content = self.get_practice(practice_name)
            if content:
                return {
                    'result': {
                        'content': [
                            {
                                'type': 'text',
                                'text': content
                            }
                        ]
                    }
                }
            else:
                available = ', '.join(self.list_practices())
                return {
                    'error': {
                        'code': -32602,
                        'message': f'Practice not found: {practice_name}. Available: {available}'
                    }
                }

        elif tool_name == 'list_practices':
            practices_list = self.list_practices()
            return {
                'result': {
                    'content': [
                        {
                            'type': 'text',
                            'text': f"Available practices:\n" + '\n'.join(f'- {p}' for p in practices_list)
                        }
                    ]
                }
            }

        elif tool_name == 'get_template':
            template_name = tool_args.get('name', '')
            content = self.get_template(template_name)
            if content:
                return {
                    'result': {
                        'content': [
                            {
                                'type': 'text',
                                'text': content
                            }
                        ]
                    }
                }
            else:
                available = ', '.join(self.list_templates())
                return {
                    'error': {
                        'code': -32602,
                        'message': f'Template not found: {template_name}. Available: {available}'
                    }
                }

        elif tool_name == 'list_templates':
            templates_list = self.list_templates()
            return {
                'result': {
                    'content': [
                        {
                            'type': 'text',
                            'text': f"Available templates:\n" + '\n'.join(f'- {t}' for t in templates_list)
                        }
                    ]
                }
            }

        elif tool_name == 'render_template':
            template_name = tool_args.get('name', '')
            variables = tool_args.get('variables', {})
            content = self.render_template(template_name, variables)
            if content:
                return {
                    'result': {
                        'content': [
                            {
                                'type': 'text',
                                'text': content
                            }
                        ]
                    }
                }
            else:
                available = ', '.join(self.list_templates())
                return {
                    'error': {
                        'code': -32602,
                        'message': f'Template not found: {template_name}. Available: {available}'
                    }
                }

        else:
            return {
                'error': {
                    'code': -32601,
                    'message': f'Tool not found: {tool_name}'
                }
            }

    def run(self):
        """Run the MCP server (stdio mode)."""
        logger.info("Starting DevOps Practices MCP Server")
        logger.info(f"Base directory: {BASE_DIR}")
        logger.info(f"Practices loaded: {', '.join(self.list_practices())}")
        logger.info(f"Templates loaded: {', '.join(self.list_templates())}")

        try:
            for line in sys.stdin:
                if not line.strip():
                    continue

                try:
                    request = json.loads(line)

                    # Check if this is a notification (no id field)
                    is_notification = 'id' not in request

                    # Handle notifications separately (they don't get responses)
                    if is_notification:
                        method = request.get('method', '')
                        logger.info(f"Received notification: {method}")
                        # Notifications like "notifications/initialized" don't need responses
                        continue

                    response = self.handle_request(request)

                    # Add request ID if present
                    if 'id' in request:
                        response['id'] = request['id']

                    print(json.dumps(response), flush=True)

                except json.JSONDecodeError as e:
                    logger.error(f"Invalid JSON: {e}")
                    error_response = {
                        'error': {
                            'code': -32700,
                            'message': 'Parse error'
                        }
                    }
                    print(json.dumps(error_response), flush=True)

        except KeyboardInterrupt:
            logger.info("Server stopped by user")
        except Exception as e:
            logger.error(f"Unexpected error: {e}", exc_info=True)


def main():
    """Main entry point."""
    server = MCPServer()
    server.run()


if __name__ == '__main__':
    main()