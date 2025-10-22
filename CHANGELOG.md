# Changelog

All notable changes to the Claude .NET Plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-10-22

### Added

- Initial release of claude-dotnet-plugin
- **Primary Agents** (4):
  - dotnet-csharp-expert: Modern .NET 9/C# 13 development guidance with ASP.NET Core, MSTest, and observability
  - dotnet-git-manager: Git workflow management with conventional commits and safe repository operations
  - dotnet-azure-architect: Azure cloud architecture with cost-conscious infrastructure as code and Terraform
  - dotnet-azure-devops: Azure DevOps CI/CD pipeline guidance with work item tracking and PR management
- **Meta Agents** (3):
  - dotnet-agent-expert: Agent creation specialist for designing new specialized agents
  - dotnet-readme-maintainer: README documentation maintenance with hierarchical summarization
  - dotnet-mcp-expert: MCP (Model Context Protocol) integration specialist
- **Skills** (2):
  - README Library Template: Generates README.md for library projects with installation, API docs, and usage
  - README Script Template: Generates README.md for script projects with parameters, configuration, and examples
- Comprehensive agent documentation with usage examples in YAML frontmatter
- Combined trigger strategy for skills (explicit requests + context detection + project initialization)
- "dotnet-" namespace prefix for all agents to prevent naming conflicts
- Pre-configured `.claude/settings.json` with comprehensive permissions (pwsh, git, dotnet, az, docker)

### Security

- All agent content reviewed and sanitized for public distribution
- No credentials, API keys, or sensitive configuration patterns in examples
- Placeholder values used for connection strings and authentication examples
- Safe example data throughout (example.com, generic organization names)

[1.0.0]: https://github.com/NotMyself/claude-dotnet-plugin/releases/tag/v1.0.0
