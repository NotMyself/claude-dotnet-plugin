# Claude .NET Plugin

Modern .NET development agents and Azure expertise for Claude Code.

## Features

- **dotnet-csharp-expert**: .NET 9/C# 13 development guidance with modern patterns, ASP.NET Core, MSTest testing, and observability
- **dotnet-azure-architect**: Azure cloud architecture and service selection expertise
- **dotnet-azure-devops**: Azure DevOps pipelines and CI/CD workflows
- **dotnet-git-manager**: Git workflow management and best practices
- **3 Meta Agents**: Agent creation, README maintenance, MCP integration
- **README Templates**: Library and script project documentation generation skills

## Installation

### From GitHub

```
/plugin marketplace add BobbyJohnson/claude-dotnet-plugin
/plugin install claude-dotnet-plugin
```

### Local Development

```powershell
# Clone repository
git clone https://github.com/BobbyJohnson/claude-dotnet-plugin.git
cd claude-dotnet-plugin

# Add to Claude Code (replace with your actual plugin directory path)
/plugin marketplace add C:\path\to\claude-dotnet-plugin
/plugin install claude-dotnet-plugin@claude-dotnet-plugin-marketplace
```

## Requirements

- **Claude Code**: Versions from last 6 months recommended for full feature support
- **Git**: Required for installation
- **Windows 11**: Recommended primary development platform
- **PowerShell 7+**: For development and testing scripts

## Settings

This plugin includes a pre-configured `.claude/settings.json` file that automatically grants permissions for:

- **PowerShell** (`pwsh`): Script execution, Pester testing
- **Git** (`git`): All git operations (commit, push, pull, branch, status)
- **GitHub CLI** (`gh`): Issues, PRs, releases
- **.NET CLI** (`dotnet`): Project creation, builds, testing
- **Azure CLI** (`az`): Azure and Azure DevOps operations
- **Docker** (`docker`): Containerized testing environments

Destructive operations (force push, hard reset, resource deletion) require confirmation.

## Usage

### Agent Activation

Agents activate automatically based on your question context:

**Example: .NET Development**
```
User: "How do I create a new .NET 9 web API with MSTest?"
Claude: [Uses dotnet-csharp-expert agent for specialized guidance]
```

**Example: Azure Architecture**
```
User: "What Azure services should I use for a scalable web app?"
Claude: [Uses dotnet-azure-architect agent for service recommendations]
```

**Example: DevOps Pipelines**
```
User: "Create an Azure DevOps YAML pipeline for .NET deployment"
Claude: [Uses dotnet-azure-devops agent for pipeline guidance]
```

### Skill Activation

Skills trigger automatically on specific contexts:

**README Generation**
```
User: "create README for this library"
Claude: [Uses README Library Template skill to generate comprehensive README.md]
```

## Agents

### Primary Agents

- **dotnet-csharp-expert**: Modern .NET 9/C# 13 development, ASP.NET Core, MSTest, Entity Framework Core, observability with Application Insights
- **dotnet-git-manager**: Git workflows, branching strategies, conventional commits, merge conflict resolution
- **dotnet-azure-architect**: Azure service selection, cloud architecture patterns, cost optimization, security best practices
- **dotnet-azure-devops**: CI/CD pipelines, YAML configuration, release management, artifact publishing

### Meta Agents

- **dotnet-agent-expert**: Create new specialized agents for Claude Code
- **dotnet-readme-maintainer**: Maintain and update README documentation
- **dotnet-mcp-expert**: Design MCP (Model Context Protocol) integrations

## Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'feat: add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## License

MIT License - see [LICENSE](LICENSE) file for details

## Author

Bobby Johnson - [bobby@example.com](mailto:bobby@example.com)

## Acknowledgments

Built with [Claude Code](https://claude.com/claude-code) plugin framework.
