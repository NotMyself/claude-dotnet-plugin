# Research Findings: Claude .NET Plugin

**Feature**: Claude .NET Plugin
**Date**: 2025-10-22
**Phase**: Phase 0 - Technical Research

## Overview

This document consolidates technical research findings for implementing a Claude Code plugin that packages .NET development agents and documentation templates. Research covers plugin architecture patterns, content conversion strategies, security considerations, and distribution mechanisms.

## Decision 1: Plugin Manifest Format

### Decision
Use Claude Code standard `plugin.json` format with required and recommended fields, following the Single Plugin distribution pattern with marketplace.json co-located in the same repository.

### Rationale
- **Standard Compliance**: Aligns with Claude Code plugin specification documented in research guide
- **Minimal Configuration**: Single plugin pattern requires minimal configuration overhead
- **Self-Contained Distribution**: Both manifests in same repo simplifies distribution
- **Version Synchronization**: Easier to keep plugin.json and marketplace.json versions aligned

### Implementation Details

```json
// .claude-plugin/plugin.json
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

```json
// .claude-plugin/marketplace.json
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
      "category": "Development Tools"
    }
  ]
}
```

### Alternatives Considered
- **Monorepo Marketplace**: Multiple plugins in plugins/ subdirectory - Rejected because single plugin doesn't justify monorepo complexity
- **Catalog Marketplace**: External references to GitHub repos - Rejected because adds distribution complexity for single plugin
- **Separate Repositories**: plugin.json in one repo, marketplace.json in another - Rejected due to version sync challenges

## Decision 2: JSON to Markdown Agent Conversion

### Decision
Convert JSON agent definitions to markdown files with YAML frontmatter, preserving all domain knowledge while restructuring for Claude Code agent format. Use structured markdown sections for organization and code fencing for examples.

### Rationale
- **Claude Code Standard**: Agents must be markdown with YAML frontmatter per constitution
- **Readability**: Markdown format is human-readable and maintainable
- **Structure Preservation**: JSON structure maps naturally to markdown headers and sections
- **Code Examples**: Fenced code blocks preserve syntax highlighting for embedded examples
- **Metadata Extraction**: YAML frontmatter cleanly separates metadata from content

### Implementation Pattern

**Source JSON Structure** (modern_dotnet_agent.json):
```json
{
  "agent_definition": {
    "name": "Local C# Web Developer",
    "description": "Expert for C# 13 web development...",
    "scope": { "technologies": [...] },
    "commands": { "development": {...} }
  }
}
```

**Target Markdown Structure** (dotnet-csharp-expert.md):
```markdown
---
name: dotnet-csharp-expert
description: Use this agent when working with .NET 9/C# 13 development...
color: green
---

You are a Modern .NET Development specialist focusing on C# 13...

Your core expertise areas:
- **C# 13 Features**: Primary constructors, collection expressions...
- **ASP.NET Core**: Web APIs, MVC applications, minimal APIs...

## Development Commands

### Project Setup
\`\`\`bash
dotnet new sln -n MySolution
dotnet new webapi -n MyApi --framework net9.0
\`\`\`
```

### Conversion Steps
1. Extract `name` → create `dotnet-{name}` with namespace prefix
2. Extract `description` → expand with usage examples following constitution format
3. Assign `color` based on domain (green=backend, blue=frontend, red=security, etc.)
4. Convert `scope.technologies` → "Your core expertise areas" section
5. Convert `commands` → "## Commands" section with fenced code blocks
6. Convert `patterns` → "## Best Practices" or "## Patterns" sections
7. Add "When to Use This Agent" section with clear triggers

### Alternatives Considered
- **Keep JSON Format**: Rejected - not compatible with Claude Code agent system
- **YAML-Only Format**: Rejected - less readable, harder to maintain large content blocks
- **Plain Markdown**: Rejected - loses structured metadata needed for agent selection

## Decision 3: Agent Naming and Namespace Strategy

### Decision
Prepend "dotnet-" prefix to all agent names to create unique namespace and prevent conflicts with existing Claude Code agents or other plugins.

### Rationale
- **Conflict Prevention**: Prevents name collisions with built-in agents or other plugins
- **Clear Association**: "dotnet-" prefix immediately identifies plugin source
- **Searchability**: Enables users to filter agents by namespace
- **Constitution Compliance**: Aligns with constitution's conflict resolution requirement (FR-005)

### Naming Convention
| Original Name | New Agent Name | Filename |
|---------------|----------------|----------|
| Modern .NET Developer | dotnet-csharp-expert | dotnet-csharp-expert.md |
| Git Manager | dotnet-git-manager | dotnet-git-manager.md |
| Azure Architect | dotnet-azure-architect | dotnet-azure-architect.md |
| Azure DevOps Manager | dotnet-azure-devops | dotnet-azure-devops.md |
| agent-expert | dotnet-agent-expert | dotnet-agent-expert.md |
| feature-prompt | dotnet-feature-prompt | dotnet-feature-prompt.md |
| readme-maintainer | dotnet-readme-maintainer | dotnet-readme-maintainer.md |
| mcp-expert | dotnet-mcp-expert | dotnet-mcp-expert.md |

### Alternatives Considered
- **No Prefix**: Rejected - high risk of name conflicts
- **Suffix Pattern**: "csharp-expert-dotnet" - Rejected - less intuitive, harder to scan
- **Version in Name**: "dotnet9-csharp-expert" - Rejected - creates migration burden on version updates

## Decision 4: README Template to Skill Conversion

### Decision
Convert README templates to Claude Code skills with combined trigger strategy: explicit requests ("create README"), missing README detection, and project initialization contexts.

### Rationale
- **Multi-Trigger Support**: Maximizes opportunities for skill activation
- **User Intent Alignment**: Covers explicit commands and implicit needs
- **Context Awareness**: Detects project state (missing README) and responds proactively
- **Constitution Compliance**: Implements FR-009 trigger requirements from clarification session

### Skill Structure

```markdown
---
name: README Library Template
description: Generate README.md for library projects. Use when user requests "create README" or "generate documentation" for libraries, when missing README.md detected in library project root, or during library project initialization.
allowed-tools:
  - Write
  - Read
---

# Library Project README Template Skill

When the user needs README generation for a library project:

1. Detect project type (check for library-specific files: .csproj with <OutputType>Library</OutputType>, package.json with "type": "module")
2. Generate README with sections: Title, Description, Installation, Usage, API Documentation, Contributing, License
3. Populate with placeholder content where project-specific data unavailable
4. Offer customization options

## Trigger Scenarios

**Explicit Requests**:
- "create README for library"
- "generate documentation"
- "add README to this library"

**Missing README Detection**:
- User in project root directory
- No README.md file present
- Project structure indicates library (*.csproj with Library output, or package.json)

**Project Initialization**:
- User creates new library project (`dotnet new classlib`)
- User initializes git repository in library project
- User discusses project documentation needs
```

### Alternatives Considered
- **Explicit Keywords Only**: Rejected - misses opportunities for proactive assistance
- **Always Suggest**: Rejected - too intrusive, creates noise in non-documentation contexts
- **File Detection Only**: Rejected - doesn't respond to explicit user requests

## Decision 5: Security Content Sanitization

### Decision
Implement manual security audit of all agent content with pattern-based detection for credentials, API keys, and sensitive configuration, replacing with placeholder values or safe examples.

### Rationale
- **Public Distribution**: Plugin will be publicly distributed via GitHub
- **Credential Prevention**: Prevents accidental exposure of secrets
- **Example Quality**: Ensures examples use safe, demonstrative values
- **Constitution Compliance**: Implements FR-023 security review requirement

### Sanitization Patterns

**Detect and Replace**:
```
Pattern                              →  Replacement
ConnectionStrings with passwords     →  "Server=example.com;Database=demo;User=user;Password=placeholder"
API Keys (long alphanumeric)         →  "YOUR_API_KEY_HERE" or "{API_KEY}"
Azure Connection Strings             →  "DefaultEndpointsProtocol=https;AccountName=example;AccountKey={key}"
Email addresses (non-generic)        →  "user@example.com"
Specific IP addresses                →  "192.0.2.1" (TEST-NET-1 range)
Real organization names              →  "YourCompany" or "Contoso"
```

**Review Checklist**:
- [ ] No hardcoded connection strings with real credentials
- [ ] No API keys or tokens (Azure, AWS, GitHub, etc.)
- [ ] No real email addresses or names
- [ ] No internal URLs or IP addresses
- [ ] No proprietary code or trade secrets
- [ ] Examples use placeholder or demo values
- [ ] Configuration uses environment variable references: `${VARIABLE:-default}`

### Alternatives Considered
- **Automated Scanning Only**: Rejected - high false positive/negative rate, requires human review
- **Strip All Examples**: Rejected - reduces educational value of agents
- **Encrypt Sensitive Data**: Rejected - unnecessary complexity for examples that should be generic

## Decision 6: Local Testing Workflow

### Decision
Use development marketplace with absolute path reference for iterative local testing before GitHub publication.

### Rationale
- **Fast Iteration**: Instant feedback without git commit/push cycle
- **Component Isolation**: Test individual agents/skills without full deployment
- **Constitution Compliance**: Implements constitution's local testing workflow requirement
- **Error Detection**: Catches manifest errors, markdown formatting issues, frontmatter problems early

### Testing Procedure

**1. Create Dev Marketplace** (one-time setup):
```bash
mkdir C:\dev\claude-marketplaces\dev-marketplace
cd C:\dev\claude-marketplaces\dev-marketplace
mkdir .claude-plugin
```

Create `.claude-plugin/marketplace.json`:
```json
{
  "name": "dev-marketplace",
  "owner": {"name": "Developer"},
  "plugins": [
    {
      "name": "claude-dotnet-plugin",
      "source": "C:/Users/BobbyJohnson/src/claude-dotnet-plugin",
      "description": "Plugin under development"
    }
  ]
}
```

**2. Install and Test**:
```
/plugin marketplace add C:\dev\claude-marketplaces\dev-marketplace
/plugin install claude-dotnet-plugin@dev-marketplace
```

**3. Validate Components**:
- Run `/help` - verify commands appear
- Ask .NET questions - verify dotnet-csharp-expert agent activates
- Request README generation - verify skills trigger
- Check `/mcp` if MCP servers configured

**4. Iterate**:
```
/plugin uninstall claude-dotnet-plugin@dev-marketplace
[Make changes to agents, skills, or manifests]
/plugin install claude-dotnet-plugin@dev-marketplace
[Re-test]
```

**5. Validation Checklist**:
- [ ] All agents load without errors (check logs)
- [ ] Agent names use "dotnet-" prefix
- [ ] Agent descriptions include usage examples
- [ ] Skills trigger on expected phrases
- [ ] Manifest fields populated correctly
- [ ] Markdown formatting valid (no broken code fences)
- [ ] No credentials or sensitive data in content

### Alternatives Considered
- **Direct GitHub Testing**: Rejected - slow iteration, pollutes commit history
- **Docker Container Testing**: Rejected - unnecessary complexity for static content
- **Mock Claude Code**: Rejected - doesn't test actual integration behavior

## Decision 7: Documentation Strategy

### Decision
Create comprehensive README.md with installation instructions, usage examples, and agent descriptions; CHANGELOG.md following Keep a Changelog format; and MIT license for maximum permissiveness.

### Rationale
- **User Onboarding**: Clear documentation reduces support burden
- **Constitution Compliance**: Implements FR-010 (README), FR-011 (CHANGELOG), FR-018 (LICENSE)
- **Open Source Best Practice**: Standard documentation artifacts expected in public repos
- **Discoverability**: Good documentation improves GitHub search rankings

### Documentation Structure

**README.md**:
```markdown
# Claude .NET Plugin

Modern .NET development agents and Azure expertise for Claude Code.

## Features
- .NET 9/C# 13 development guidance
- Azure architecture and DevOps expertise
- Git workflow management
- README template generation

## Installation
\`\`\`
/plugin marketplace add BobbyJohnson/claude-dotnet-plugin
/plugin install claude-dotnet-plugin
\`\`\`

## Agents
- **dotnet-csharp-expert**: Modern .NET/C# development...
- **dotnet-azure-architect**: Azure cloud architecture...

## Usage Examples
[Specific scenarios with commands and expected outcomes]

## Requirements
- Claude Code (versions from last 6 months recommended)
- Git for installation
- Windows 11 recommended

## License
MIT
```

**CHANGELOG.md**:
```markdown
# Changelog

## [1.0.0] - 2025-10-22

### Added
- Initial release of claude-dotnet-plugin
- 4 primary agents: csharp-expert, git-manager, azure-architect, azure-devops
- 4 meta agents: agent-expert, feature-prompt, readme-maintainer, mcp-expert
- 2 README template skills: library and script projects
- Comprehensive agent documentation with usage examples
- Security-sanitized content (no credentials or sensitive data)

### Security
- All agent content reviewed and sanitized for public distribution
```

### Alternatives Considered
- **Minimal Documentation**: Rejected - poor user experience, higher support burden
- **Wiki Instead of README**: Rejected - README is standard first point of contact
- **No CHANGELOG**: Rejected - version history documentation required by constitution

## Research References

- **Primary Source**: [Claude Code Plugin Developer Guide](../../../docs/research/claude-code-plugin-developer-guide.md)
- **Constitution**: [Project Constitution v1.0.0](../../../.specify/memory/constitution.md)
- **Official Docs**: https://docs.claude.com/en/docs/claude-code/plugins.md

## Unresolved Questions

None - all technical decisions finalized during research phase.

## Next Steps

Proceed to Phase 1: Design artifacts generation
- Generate data-model.md defining plugin entity relationships
- Create contracts/ directory with manifest schema documentation
- Generate quickstart.md for plugin development workflow
