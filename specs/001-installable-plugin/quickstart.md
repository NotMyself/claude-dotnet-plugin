# Quick Start Guide: Claude .NET Plugin Development

**Feature**: Claude .NET Plugin
**Date**: 2025-10-22
**Audience**: Developers implementing this plugin

## Overview

This guide provides step-by-step instructions for building the Claude .NET Plugin from the migrate directory contents. Follow this workflow to create a production-ready, constitution-compliant plugin.

## Prerequisites

- **Claude Code**: Installed and functional (last 6 months version recommended)
- **Git**: For version control and distribution
- **PowerShell 7+**: For testing scripts (`pwsh --version` to verify)
- **Text Editor**: VS Code, Vim, or any markdown-capable editor
- **Python (optional)**: For JSON validation (`python -m json.tool`)

## Phase 1: Initial Setup (15 minutes)

### Step 1: Create Plugin Directory Structure

```powershell
# Create root plugin directory
cd C:\Users\BobbyJohnson\src
New-Item -ItemType Directory -Path "claude-dotnet-plugin-build" -Force
cd claude-dotnet-plugin-build

# Create component directories
New-Item -ItemType Directory -Path ".claude-plugin", "agents", "skills" -Force
```

### Step 2: Create Plugin Manifest

Create `.claude-plugin/plugin.json`:

```json
{
  "name": "claude-dotnet-plugin",
  "version": "1.0.0",
  "description": "Modern .NET development agents and Azure expertise for Claude Code",
  "author": {
    "name": "Bobby Johnson",
    "email": "bobby@example.com"
  },
  "homepage": "https://github.com/BobbyJohnson/claude-dotnet-plugin",
  "repository": "https://github.com/BobbyJohnson/claude-dotnet-plugin",
  "license": "MIT",
  "keywords": ["dotnet", "csharp", "azure", "devops", "development"]
}
```

**Validate**:
```powershell
Get-Content .claude-plugin/plugin.json | ConvertFrom-Json
```

### Step 3: Create Marketplace Catalog

Create `.claude-plugin/marketplace.json`:

```json
{
  "name": "claude-dotnet-plugin-marketplace",
  "owner": {
    "name": "Bobby Johnson",
    "email": "bobby@example.com"
  },
  "plugins": [
    {
      "name": "claude-dotnet-plugin",
      "source": ".",
      "description": "Modern .NET development agents and Azure expertise",
      "version": "1.0.0",
      "category": "Development Tools",
      "author": "Bobby Johnson",
      "homepage": "https://github.com/BobbyJohnson/claude-dotnet-plugin",
      "license": "MIT",
      "keywords": ["dotnet", "csharp", "azure", "devops", "development"]
    }
  ]
}
```

**Validate**:
```powershell
Get-Content .claude-plugin/marketplace.json | ConvertFrom-Json
```

### Step 4: Initialize Git Repository

```powershell
git init
git add .claude-plugin/
git commit -m "chore: initialize plugin structure with manifests"
```

## Phase 2: Agent Conversion (60 minutes)

### Convert JSON Agents to Markdown

**Source**: `migrate/agents/*.json`
**Destination**: `agents/dotnet-*.md`

#### Agent 1: Modern .NET Developer → dotnet-csharp-expert.md

1. Read source: `migrate/agents/modern_dotnet_agent.json`
2. Extract structure: `agent_definition` → markdown sections
3. Create frontmatter with namespace prefix
4. Add usage examples to description
5. Convert JSON sections to markdown headers

**Template**:
```markdown
---
name: dotnet-csharp-expert
description: Use this agent when working with .NET 9/C# 13 development. Specializes in modern C# features, ASP.NET Core, MSTest testing, and observability. Examples: <example>Context: User building web API user: 'Create a new .NET 9 web API project' assistant: 'I'll use the dotnet-csharp-expert agent to provide modern .NET project setup guidance' <commentary>Specialized .NET 9 expertise needed</commentary></example> <example>Context: User troubleshooting build error user: 'MSTest build failing with missing dependency' assistant: 'Let me use the dotnet-csharp-expert agent to diagnose .NET build issues' <commentary>.NET specific troubleshooting required</commentary></example>
color: green
---

You are a Modern .NET Development specialist focusing on C# 13 language features, ASP.NET Core web applications, MSTest testing, and contemporary observability practices on Windows.

Your core expertise areas:
- **C# 13 Features**: Primary constructors, collection expressions, using declarations for type aliases
- **ASP.NET Core**: Web APIs, MVC applications, minimal APIs, middleware configuration
- **Testing**: MSTest framework with modern Assert.That syntax, integration testing with WebApplicationFactory
- **Observability**: Application Insights, OpenTelemetry instrumentation, structured logging
- **Entity Framework Core 9**: Migrations, query optimization, connection pooling

## When to Use This Agent

Use this agent for:
- .NET 9/C# 13 project creation and configuration
- Modern C# pattern guidance and best practices
- ASP.NET Core web application development
- MSTest unit and integration testing strategies
- Application observability setup and troubleshooting
- Entity Framework Core data access patterns

[Continue with sections from JSON: commands, patterns, workflows, best practices, troubleshooting]
```

**Security Review Checklist**:
- [ ] No real connection strings (use placeholders)
- [ ] No API keys or tokens (use `{API_KEY}` format)
- [ ] No internal URLs or IPs (use `example.com`, `192.0.2.1`)
- [ ] No real email addresses (use `user@example.com`)
- [ ] Examples use generic organization names (`Contoso`, `YourCompany`)

**Repeat for**:
- `git_manager_agent.json` → `agents/dotnet-git-manager.md`
- `azure_architect_agent.json` → `agents/dotnet-azure-architect.md`
- `azure_devops_manager_agent.json` → `agents/dotnet-azure-devops.md`

### Add Namespace Prefix to Meta Agents

**Source**: `migrate/agents/meta/*.md`
**Destination**: `agents/dotnet-*.md`

These are already markdown format - just add "dotnet-" prefix to name field:

```powershell
# Copy and rename
Copy-Item "migrate/agents/meta/agent-expert.md" "agents/dotnet-agent-expert.md"
Copy-Item "migrate/agents/meta/feature-prompt.md" "agents/dotnet-feature-prompt.md"
Copy-Item "migrate/agents/meta/readme-maintainer.md" "agents/dotnet-readme-maintainer.md"
Copy-Item "migrate/agents/meta/mcp-expert.md" "agents/dotnet-mcp-expert.md"

# Edit each file to update name in frontmatter:
# name: agent-expert → name: dotnet-agent-expert
```

**Commit**:
```powershell
git add agents/
git commit -m "feat: add 7 agents with dotnet- namespace prefix"
```

## Phase 3: Skill Creation (30 minutes)

### Convert Templates to Skills

**Source**: `migrate/templates/*.md`
**Destination**: `skills/{skill-name}/SKILL.md`

#### Skill 1: Library README Template

1. Create directory: `skills/readme-library-template/`
2. Create `skills/readme-library-template/SKILL.md`
3. Extract template content from `migrate/templates/lib-project-readme-template.md`
4. Add frontmatter with trigger specifications

**skills/readme-library-template/SKILL.md**:
```markdown
---
name: README Library Template
description: Generate README.md for library projects. Use when user requests "create README", "generate documentation", or "add README" for libraries. Also triggers when missing README.md detected in library project root, or during library project initialization (dotnet new classlib, npm init for libraries).
allowed-tools:
  - Write
  - Read
  - Glob
---

# Library Project README Template Skill

Generates comprehensive README.md files for library projects with standard sections and best practices formatting.

## Trigger Scenarios

**Explicit Requests**:
- "create README for library"
- "generate documentation"
- "add README to this library project"

**Missing README Detection**:
- User in project root directory
- No README.md file present
- Project structure indicates library (*.csproj with `<OutputType>Library</OutputType>`, or package.json without "bin" entry)

**Project Initialization**:
- User creates new library project: `dotnet new classlib`
- User initializes git repository in library project
- User discusses project documentation needs

## Implementation

When triggered, generate README.md with these sections:

1. **Title**: Project name with appropriate badges (build status, version, license)
2. **Description**: One-paragraph project summary
3. **Installation**: Package manager instructions (NuGet, npm, pip)
4. **Usage**: Basic usage examples with code blocks
5. **API Documentation**: Key classes/functions with parameters and return types
6. **Building**: Build and test instructions
7. **Contributing**: Contribution guidelines
8. **License**: License type

### Template Content

[Embed the content from lib-project-readme-template.md with placeholder markers like {PROJECT_NAME}, {DESCRIPTION}, etc.]
```

#### Skill 2: Script README Template

Similar process for `migrate/templates/script-project-readme-template.md` → `skills/readme-script-template/SKILL.md`

**Key Differences**:
- Triggers on script projects (`.ps1`, `.sh`, `*.py` scripts)
- Sections: Usage, Arguments, Examples, Requirements, Installation
- Simpler structure than library template

**Commit**:
```powershell
git add skills/
git commit -m "feat: add README template skills with combined triggers"
```

## Phase 4: Documentation (20 minutes)

### Create README.md

```markdown
# Claude .NET Plugin

Modern .NET development agents and Azure expertise for Claude Code.

## Features

- **dotnet-csharp-expert**: .NET 9/C# 13 development guidance with modern patterns
- **dotnet-azure-architect**: Azure cloud architecture and service selection
- **dotnet-azure-devops**: Azure DevOps pipelines and CI/CD workflows
- **dotnet-git-manager**: Git workflow management and best practices
- **4 Meta Agents**: Agent creation, feature prompts, README maintenance, MCP integration
- **README Templates**: Library and script project documentation generation

## Installation

### From GitHub

\`\`\`
/plugin marketplace add BobbyJohnson/claude-dotnet-plugin
/plugin install claude-dotnet-plugin
\`\`\`

### Local Development

\`\`\`powershell
# Clone repository
git clone https://github.com/BobbyJohnson/claude-dotnet-plugin.git
cd claude-dotnet-plugin

# Add to Claude Code
/plugin marketplace add C:\Users\BobbyJohnson\src\claude-dotnet-plugin
/plugin install claude-dotnet-plugin@claude-dotnet-plugin-marketplace
\`\`\`

## Usage

### Agent Activation

Agents activate automatically based on context:

**Example**: .NET development
\`\`\`
User: "How do I create a new .NET 9 web API with MSTest?"
Claude: [Uses dotnet-csharp-expert agent for specialized guidance]
\`\`\`

**Example**: Azure architecture
\`\`\`
User: "What Azure services should I use for a scalable web app?"
Claude: [Uses dotnet-azure-architect agent for service recommendations]
\`\`\`

### Skill Activation

Skills trigger on specific contexts:

**README Generation**:
\`\`\`
User: "create README for this library"
Claude: [Uses README Library Template skill to generate comprehensive README.md]
\`\`\`

## Agents

### Primary Agents

- **dotnet-csharp-expert**: Modern .NET/C# 13 development, ASP.NET Core, MSTest, observability
- **dotnet-git-manager**: Git workflows, branching strategies, conventional commits
- **dotnet-azure-architect**: Azure service selection, cloud architecture patterns, cost optimization
- **dotnet-azure-devops**: CI/CD pipelines, YAML configuration, release management

### Meta Agents

- **dotnet-agent-expert**: Create new specialized agents for Claude Code
- **dotnet-feature-prompt**: Generate comprehensive feature specifications
- **dotnet-readme-maintainer**: Maintain and update README documentation
- **dotnet-mcp-expert**: Design MCP (Model Context Protocol) integrations

## Requirements

- Claude Code (versions from last 6 months recommended for full feature support)
- Git for installation
- Windows 11 recommended (primary development platform)

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
```

### Create CHANGELOG.md

```markdown
# Changelog

All notable changes to the Claude .NET Plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-10-22

### Added

- Initial release of claude-dotnet-plugin
- **Primary Agents** (4):
  - dotnet-csharp-expert: Modern .NET 9/C# 13 development guidance
  - dotnet-git-manager: Git workflow management and best practices
  - dotnet-azure-architect: Azure cloud architecture expertise
  - dotnet-azure-devops: Azure DevOps CI/CD pipeline guidance
- **Meta Agents** (4):
  - dotnet-agent-expert: Agent creation specialist
  - dotnet-feature-prompt: Feature specification expert
  - dotnet-readme-maintainer: README documentation maintenance
  - dotnet-mcp-expert: MCP integration specialist
- **Skills** (2):
  - README Library Template: Generates README.md for library projects
  - README Script Template: Generates README.md for script projects
- Comprehensive agent documentation with usage examples in YAML frontmatter
- Combined trigger strategy for skills (explicit requests + context detection + project initialization)
- "dotnet-" namespace prefix for all agents to prevent naming conflicts

### Security

- All agent content reviewed and sanitized for public distribution
- No credentials, API keys, or sensitive configuration patterns in examples
- Placeholder values used for connection strings and authentication examples
- Safe example data throughout (example.com, generic organization names)

[1.0.0]: https://github.com/BobbyJohnson/claude-dotnet-plugin/releases/tag/v1.0.0
```

### Create LICENSE

```
MIT License

Copyright (c) 2025 Bobby Johnson

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

**Commit**:
```powershell
git add README.md CHANGELOG.md LICENSE
git commit -m "docs: add comprehensive README, CHANGELOG, and MIT license"
```

## Phase 5: Local Testing (30 minutes)

### Setup Development Marketplace

```powershell
# Create dev marketplace directory
New-Item -ItemType Directory -Path "C:\dev\claude-marketplaces\dev-marketplace\.claude-plugin" -Force

# Create marketplace manifest
$marketplaceJson = @'
{
  "name": "dev-marketplace",
  "owner": {"name": "Developer"},
  "plugins": [
    {
      "name": "claude-dotnet-plugin",
      "source": "C:/Users/BobbyJohnson/src/claude-dotnet-plugin-build",
      "description": "Plugin under development"
    }
  ]
}
'@

Set-Content -Path "C:\dev\claude-marketplaces\dev-marketplace\.claude-plugin\marketplace.json" -Value $marketplaceJson
```

### Install and Test

In Claude Code:

```
/plugin marketplace add C:\dev\claude-marketplaces\dev-marketplace
/plugin install claude-dotnet-plugin@dev-marketplace
```

**Test Checklist**:
1. [ ] Run `/help` - verify no errors in output
2. [ ] Ask ".NET 9 project setup question" - verify dotnet-csharp-expert activates
3. [ ] Ask "Azure architecture question" - verify dotnet-azure-architect activates
4. [ ] Request "create README for library" - verify skill triggers
5. [ ] Check Claude Code logs for any loading errors

**If issues found**:
```
/plugin uninstall claude-dotnet-plugin@dev-marketplace
[Fix issues in plugin files]
/plugin install claude-dotnet-plugin@dev-marketplace
[Retest]
```

## Phase 6: Pre-Publication Validation (15 minutes)

### Validation Checklist

```powershell
# JSON validation
Get-Content .claude-plugin/plugin.json | ConvertFrom-Json
Get-Content .claude-plugin/marketplace.json | ConvertFrom-Json

# Version synchronization check
$pluginVersion = (Get-Content .claude-plugin/plugin.json | ConvertFrom-Json).version
$marketplaceVersion = (Get-Content .claude-plugin/marketplace.json | ConvertFrom-Json).plugins[0].version
if ($pluginVersion -ne $marketplaceVersion) { Write-Error "Version mismatch!" }

# File structure verification
Get-ChildItem -Recurse -File | Where-Object { $_.Extension -in '.md', '.json' }
```

**Manual Checks**:
- [ ] All 7 agents have "dotnet-" prefix in name field
- [ ] All agent descriptions include 2-3 usage examples
- [ ] All skills have proper YAML frontmatter with allowed-tools
- [ ] README.md complete with installation and usage sections
- [ ] CHANGELOG.md documents version 1.0.0
- [ ] LICENSE file present (MIT)
- [ ] No credentials or sensitive data in any files
- [ ] All markdown files use proper CommonMark formatting
- [ ] Git repository initialized with proper commits

## Phase 7: GitHub Publication (20 minutes)

### Create GitHub Repository

```powershell
# Create .gitignore
@"
# OS files
.DS_Store
Thumbs.db

# IDE files
.vscode/
.idea/
*.swp

# Temporary files
*.tmp
*.log
"@ | Set-Content .gitignore

git add .gitignore
git commit -m "chore: add gitignore for OS and IDE files"
```

### Publish to GitHub

```powershell
# Create repository on GitHub (use GitHub CLI or web interface)
gh repo create claude-dotnet-plugin --public --source=. --remote=origin

# Push code
git branch -M main
git push -u origin main

# Create version tag
git tag -a v1.0.0 -m "Release version 1.0.0 - Initial plugin release"
git push origin v1.0.0

# Create GitHub Release (use GitHub UI or CLI)
gh release create v1.0.0 --title "v1.0.0 - Initial Release" --notes-file CHANGELOG.md
```

### Install from GitHub

Test installation from public repository:
```
/plugin marketplace add BobbyJohnson/claude-dotnet-plugin
/plugin install claude-dotnet-plugin
```

## Troubleshooting

### "Plugin not found"
- Verify marketplace.json syntax with `ConvertFrom-Json`
- Check source path is correct (absolute for local, "." for published)
- Ensure plugin name matches between plugin.json and marketplace.json

### "Agent not loading"
- Check YAML frontmatter syntax (use `---` delimiters)
- Verify all required fields present (name, description, color)
- Ensure agent filename matches name in frontmatter

### "Skill not triggering"
- Verify description includes clear trigger terms
- Check allowed-tools list includes all tools skill uses
- Ensure SKILL.md file in skills/{skill-name}/ directory structure

## Next Steps

After successful publication:
1. Monitor GitHub issues for user feedback
2. Update agents based on .NET 9 platform updates
3. Add new agents for additional Azure services
4. Expand skill library with more templates
5. Consider version 1.1.0 with new features (minor version bump)

## Resources

- [Claude Code Plugin Documentation](https://docs.claude.com/en/docs/claude-code/plugins.md)
- [Project Constitution](../../.specify/memory/constitution.md)
- [Plugin Developer Guide](../../docs/research/claude-code-plugin-developer-guide.md)
- [Feature Specification](./spec.md)
- [Implementation Plan](./plan.md)
