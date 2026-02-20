"""DevOps Practices MCP Server.

Provides shared DevOps practices and templates for infrastructure projects.
"""

__version__ = "1.4.0"

def main():
    """Entry point for the MCP server."""
    from . import __main__
    __main__.main()

__all__ = ["main", "__version__"]
