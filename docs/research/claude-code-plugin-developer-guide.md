# Claude Code Plugin Developer Guide

## Table of Contents

- [Overview](#overview)
- [Plugin Architecture](#plugin-architecture)
  - [Directory Structure](#directory-structure)
  - [Plugin Manifest](#plugin-manifest)
  - [Component Types](#component-types)
- [Creating Your First Plugin](#creating-your-first-plugin)
  - [Project Setup](#project-setup)
  - [Creating Commands](#creating-commands)
  - [Adding Skills](#adding-skills)
  - [Integrating MCP Servers](#integrating-mcp-servers)
  - [Implementing Hooks](#implementing-hooks)
- [Plugin Marketplaces](#plugin-marketplaces)
  - [Marketplace Structure](#marketplace-structure)
  - [Marketplace Schema](#marketplace-schema)
  - [Plugin Entry Configuration](#plugin-entry-configuration)
- [Publishing on GitHub](#publishing-on-github)
  - [Repository Setup](#repository-setup)
  - [Versioning Strategy](#versioning-strategy)
  - [Distribution Methods](#distribution-methods)
- [Testing and Debugging](#testing-and-debugging)
  - [Local Testing Workflow](#local-testing-workflow)
  - [Debugging Tools](#debugging-tools)
  - [Common Issues](#common-issues)
- [Team Deployment](#team-deployment)
- [Best Practices](#best-practices)
- [Reference](#reference)

---

## Overview

Claude Code's plugin system enables developers to extend Claude Code with custom functionality that can be shared across projects and teams. Plugins package commands, agents, skills, hooks, and MCP servers into distributable units that integrate seamlessly with Claude Code's architecture.

**Key Benefits:**

- **Reusability**: Share functionality across multiple projects
- **Team Collaboration**: Distribute standardized workflows to teams
- **Modularity**: Package related features together
- **Discoverability**: Distribute through plugin marketplaces
- **Automatic Updates**: Users can update plugins from marketplaces

---

## Plugin Architecture

### Directory Structure

A complete plugin follows this organizational pattern:

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json          # Required: Plugin manifest
├── commands/                 # Optional: Slash commands
│   ├── command-name.md
│   └── subdirectory/        # Optional: Organize commands
│       └── nested-cmd.md
├── agents/                   # Optional: Custom agents
│   └── agent-name.md
├── skills/                   # Optional: Agent capabilities
│   └── skill-name/
│       └── SKILL.md
├── hooks/                    # Optional: Event handlers
│   ├── hooks.json
│   └── scripts/
│       └── hook-script.sh
├── .mcp.json                # Optional: MCP server configuration
├── scripts/                  # Optional: Utility scripts
└── README.md                # Recommended: Documentation
```

**Critical Note:** The `.claude-plugin/` directory contains only the `plugin.json` manifest. All other directories (commands, agents, skills, hooks) must be placed at the plugin root, not inside `.claude-plugin/`.

### Plugin Manifest

The `plugin.json` file defines your plugin's metadata and configuration.

**Minimal Example:**

```json
{
  "name": "my-plugin",
  "description": "A useful plugin for developers",
  "version": "1.0.0",
  "author": {
    "name": "Your Name"
  }
}
```

**Complete Schema:**

```json
{
  "name": "my-plugin",
  "version": "2.1.0",
  "description": "Complete description of plugin functionality",
  "author": {
    "name": "Your Name",
    "email": "you@example.com",
    "url": "https://yourwebsite.com"
  },
  "homepage": "https://github.com/yourusername/my-plugin",
  "repository": "https://github.com/yourusername/my-plugin",
  "license": "MIT",
  "keywords": ["productivity", "automation", "development"],
  "commands": "./commands",
  "agents": "./agents",
  "hooks": "./hooks/hooks.json",
  "mcpServers": "./.mcp.json"
}
```

**Schema Reference:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | Yes | Unique identifier in kebab-case |
| `version` | string | Recommended | Semantic version (e.g., "2.1.0") |
| `description` | string | Recommended | Plugin purpose and functionality |
| `author` | object | Recommended | Name, email, and URL |
| `homepage` | string | Optional | Documentation link |
| `repository` | string | Optional | Source code location |
| `license` | string | Optional | License identifier (MIT, Apache-2.0, etc.) |
| `keywords` | array | Optional | Tags for discoverability |
| `commands` | string/array | Optional | Custom command paths (supplements defaults) |
| `agents` | string/array | Optional | Custom agent paths (supplements defaults) |
| `hooks` | string/object | Optional | Hook configuration path or inline JSON |
| `mcpServers` | string/object | Optional | MCP configuration path or inline settings |

**Important:** Custom paths in the manifest supplement the default directories—they don't replace them. Claude Code will check both default locations and custom paths.

### Component Types

#### 1. Slash Commands

Slash commands are markdown files that provide instructions to Claude for specific tasks.

**Location:** `commands/` directory

**Format:**

```markdown
---
description: Brief description shown in /help
---

# Command Title

Detailed instructions for Claude on how to execute this command.

Use placeholders like {arg1} and {arg2} for arguments.
```

**Features:**

- Arguments via placeholders: `/command-name {filename} {options}`
- File references: `@filename.txt`
- Subdirectories for organization
- Automatic namespace prefix: `/plugin-name:command-name`
- Bash integration for shell execution

**Invocation:**

- Direct: `/command-name` (when no conflicts exist)
- Prefixed: `/plugin-name:command-name` (for disambiguation)
- With arguments: `/command-name arg1 arg2`

#### 2. Skills

Skills extend Claude's autonomous capabilities with specialized workflows. Claude invokes skills automatically based on task context.

**Location:** `skills/skill-name/SKILL.md`

**Format:**

```markdown
---
name: Skill Name
description: What this skill does and when to use it. Use when working with specific scenarios.
allowed-tools:
  - Read
  - Grep
  - Bash
---

# Skill Instructions

Detailed instructions for Claude on how to use this skill.
Include examples and best practices.
```

**Best Practices:**

- Write specific, discoverable descriptions with trigger terms
- Maintain singular focus per skill
- Use `allowed-tools` to restrict capabilities for security
- Document version history in the skill content
- Test with realistic scenarios

#### 3. Agents

Custom agents provide specialized domain expertise and workflows.

**Location:** `agents/` directory

**Format:** Similar to skills but focused on broader domain expertise.

#### 4. Hooks

Hooks enable event-driven automation by executing scripts in response to Claude Code events.

**Location:** `hooks/hooks.json` and associated scripts

**Configuration:**

```json
{
  "user-prompt-submit-hook": {
    "command": "${CLAUDE_PLUGIN_ROOT}/scripts/validate.sh"
  }
}
```

**Script Permissions:** Ensure hook scripts have execute permissions:

```bash
chmod +x scripts/validate.sh
```

#### 5. MCP Servers

MCP (Model Context Protocol) servers provide external tools and capabilities.

**Location:** `.mcp.json` at plugin root

**Configuration:**

```json
{
  "mcpServers": {
    "server-name": {
      "transport": "stdio",
      "command": "node",
      "args": ["${CLAUDE_PLUGIN_ROOT}/mcp-server/index.js"],
      "env": {
        "API_KEY": "${API_KEY:-default_key}"
      }
    }
  }
}
```

**Transport Types:**

- `stdio`: Local process execution
- `http`: Remote cloud-based services (recommended)
- `sse`: Server-Sent Events (deprecated)

**Environment Variables:**

- Use `${CLAUDE_PLUGIN_ROOT}` for plugin-relative paths
- Support variable expansion: `${VARIABLE}` and `${VARIABLE:-default}`
- MCP servers start automatically when plugin is enabled

---

## Creating Your First Plugin

### Project Setup

**1. Create plugin directory structure:**

```bash
mkdir my-awesome-plugin
cd my-awesome-plugin
mkdir .claude-plugin commands skills
```

**2. Create plugin manifest:**

Create `.claude-plugin/plugin.json`:

```json
{
  "name": "my-awesome-plugin",
  "description": "An awesome plugin for Claude Code",
  "version": "1.0.0",
  "author": {
    "name": "Your Name",
    "email": "you@example.com"
  },
  "homepage": "https://github.com/yourusername/my-awesome-plugin",
  "license": "MIT",
  "keywords": ["productivity", "automation"]
}
```

**3. Initialize git repository:**

```bash
git init
```

**4. Create README:**

Create `README.md` documenting your plugin's purpose, installation, and usage.

### Creating Commands

**Example: Hello Command**

Create `commands/hello.md`:

```markdown
---
description: Greet the user with a personalized message
---

# Hello Command

Greet the user warmly and ask how you can help them today.
Include a brief introduction of the plugin's capabilities.
```

**Example: Command with Arguments**

Create `commands/create-file.md`:

```markdown
---
description: Create a new file with boilerplate content
---

# Create File Command

Create a new file at {filepath} with the following boilerplate:

\`\`\`
// File: {filepath}
// Created: [current date]
// Description: {description}

// Your code here
\`\`\`

Ask the user for confirmation before creating the file.
```

**Subdirectory Organization:**

```
commands/
├── hello.md
├── git/
│   ├── commit.md
│   └── pr.md
└── utils/
    └── format.md
```

### Adding Skills

**Example: PDF Processing Skill**

Create `skills/pdf-processor/SKILL.md`:

```markdown
---
name: PDF Processor
description: Extract text and tables from PDF files. Use when working with PDF files or when user mentions PDFs.
allowed-tools:
  - Read
  - Bash
  - Write
---

# PDF Processing Skill

When the user needs to work with PDF files:

1. Check if pdf processing tools are installed (pdftotext, etc.)
2. Extract text content using appropriate tools
3. Parse and structure the extracted content
4. Present results in a readable format

Use this skill automatically when:
- User mentions PDF files
- User asks to extract information from PDFs
- User provides a PDF file path
```

**Skill Best Practices:**

- **Specific descriptions**: Include concrete trigger terms (e.g., "Use when working with PDF files")
- **Focused scope**: One skill per capability domain
- **Tool restrictions**: Use `allowed-tools` for read-only or limited operations
- **Clear instructions**: Provide step-by-step workflows

### Integrating MCP Servers

**Example: Custom API MCP Server**

Create `.mcp.json`:

```json
{
  "mcpServers": {
    "my-api-server": {
      "transport": "stdio",
      "command": "node",
      "args": ["${CLAUDE_PLUGIN_ROOT}/mcp-server/server.js"],
      "env": {
        "API_KEY": "${MY_API_KEY}",
        "API_URL": "${API_URL:-https://api.example.com}"
      }
    }
  }
}
```

Create the MCP server at `mcp-server/server.js`:

```javascript
#!/usr/bin/env node

// MCP server implementation
// Follow MCP protocol specification
```

**Configuration Notes:**

- Use `${CLAUDE_PLUGIN_ROOT}` for plugin-relative paths
- Support environment variable defaults: `${VAR:-default}`
- MCP servers auto-start when plugin is enabled
- Users must restart Claude Code to apply MCP changes

### Implementing Hooks

**Example: Pre-Commit Validation Hook**

Create `hooks/hooks.json`:

```json
{
  "user-prompt-submit-hook": {
    "command": "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/validate.sh"
  }
}
```

Create `hooks/scripts/validate.sh`:

```bash
#!/bin/bash
# Pre-commit validation hook

# Validation logic here
exit 0
```

**Make script executable:**

```bash
chmod +x hooks/scripts/validate.sh
```

---

## Plugin Marketplaces

### Marketplace Structure

A marketplace is a catalog of plugins distributed through a git repository. The marketplace lists available plugins and their source locations.

**Repository Structure:**

```
claude-plugins/                    # Marketplace repository
├── .claude-plugin/
│   └── marketplace.json           # Required: Marketplace catalog
├── plugins/                       # Optional: Host plugins in same repo
│   ├── plugin-one/
│   └── plugin-two/
└── README.md                      # Recommended: Documentation
```

### Marketplace Schema

Create `.claude-plugin/marketplace.json`:

**Minimal Example:**

```json
{
  "name": "my-marketplace",
  "owner": {
    "name": "Your Name",
    "email": "you@example.com"
  },
  "plugins": []
}
```

**Complete Example:**

```json
{
  "name": "awesome-claude-plugins",
  "metadata": {
    "description": "Curated collection of Claude Code plugins",
    "version": "1.0.0",
    "pluginRoot": "./plugins"
  },
  "owner": {
    "name": "Your Name",
    "email": "you@example.com"
  },
  "plugins": [
    {
      "name": "productivity-tools",
      "description": "Boost your productivity with automation",
      "version": "2.1.0",
      "author": {
        "name": "Author Name",
        "email": "author@example.com"
      },
      "source": "./plugins/productivity-tools",
      "homepage": "https://github.com/yourusername/claude-plugins/tree/main/plugins/productivity-tools",
      "license": "MIT",
      "keywords": ["productivity", "automation"],
      "category": "Development Tools"
    }
  ]
}
```

**Schema Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | Yes | Marketplace identifier (kebab-case) |
| `owner` | object | Yes | Maintainer name and email |
| `plugins` | array | Yes | Array of plugin entries |
| `metadata.description` | string | Optional | Marketplace description |
| `metadata.version` | string | Optional | Marketplace version |
| `metadata.pluginRoot` | string | Optional | Base path for relative plugin sources |

### Plugin Entry Configuration

Each plugin entry in the marketplace can specify its source location and metadata.

**Entry Schema:**

```json
{
  "name": "plugin-name",
  "source": "source-specification",
  "description": "Plugin description",
  "version": "1.0.0",
  "author": {
    "name": "Author Name",
    "email": "author@example.com"
  },
  "homepage": "https://plugin-homepage.com",
  "repository": "https://github.com/username/plugin-repo",
  "license": "MIT",
  "keywords": ["tag1", "tag2"],
  "category": "Category Name"
}
```

**Source Specifications:**

**1. Relative Path (same repository):**

```json
{
  "name": "my-plugin",
  "source": "./plugins/my-plugin"
}
```

**2. GitHub Repository:**

```json
{
  "name": "external-plugin",
  "source": {
    "source": "github",
    "repo": "username/plugin-repo"
  }
}
```

**3. Git URL:**

```json
{
  "name": "gitlab-plugin",
  "source": {
    "source": "url",
    "url": "https://gitlab.com/team/plugin.git"
  }
}
```

**4. Custom Component Paths:**

```json
{
  "name": "custom-structure",
  "source": "./plugins/custom-plugin",
  "commands": "./custom-commands",
  "agents": "./custom-agents",
  "hooks": "./custom-hooks/hooks.json",
  "mcpServers": "./custom-mcp.json"
}
```

---

## Publishing on GitHub

### Repository Setup

**Option 1: Monorepo Marketplace (Multiple Plugins)**

```
claude-plugins/
├── .claude-plugin/
│   └── marketplace.json
├── plugins/
│   ├── plugin-one/
│   ├── plugin-two/
│   └── plugin-three/
├── README.md
└── LICENSE
```

Update `marketplace.json`:

```json
{
  "name": "my-claude-plugins",
  "owner": {
    "name": "Your Name",
    "email": "you@example.com"
  },
  "metadata": {
    "pluginRoot": "./plugins"
  },
  "plugins": [
    {
      "name": "plugin-one",
      "source": "./plugins/plugin-one",
      "description": "First plugin"
    },
    {
      "name": "plugin-two",
      "source": "./plugins/plugin-two",
      "description": "Second plugin"
    }
  ]
}
```

**Option 2: Catalog Marketplace (External Plugins)**

```
awesome-claude-plugins/
├── .claude-plugin/
│   └── marketplace.json
└── README.md
```

Update `marketplace.json`:

```json
{
  "name": "awesome-claude-plugins",
  "owner": {
    "name": "Curator Name",
    "email": "curator@example.com"
  },
  "plugins": [
    {
      "name": "awesome-plugin",
      "source": {
        "source": "github",
        "repo": "author/awesome-plugin"
      },
      "description": "An awesome plugin from the community"
    },
    {
      "name": "another-plugin",
      "source": {
        "source": "url",
        "url": "https://gitlab.com/team/another-plugin.git"
      },
      "description": "Plugin hosted on GitLab"
    }
  ]
}
```

**Option 3: Single Plugin Repository**

For distributing a single plugin, create a marketplace that references it:

```
my-plugin/
├── .claude-plugin/
│   ├── plugin.json
│   └── marketplace.json
├── commands/
├── skills/
└── README.md
```

`marketplace.json`:

```json
{
  "name": "my-plugin-marketplace",
  "owner": {
    "name": "Your Name",
    "email": "you@example.com"
  },
  "plugins": [
    {
      "name": "my-plugin",
      "source": ".",
      "description": "My awesome plugin"
    }
  ]
}
```

### Versioning Strategy

Follow semantic versioning (SemVer) for both plugins and marketplaces:

- **MAJOR** (1.0.0 → 2.0.0): Breaking changes
- **MINOR** (1.0.0 → 1.1.0): New features, backward compatible
- **PATCH** (1.0.0 → 1.0.1): Bug fixes, backward compatible

**Update plugin.json:**

```json
{
  "name": "my-plugin",
  "version": "2.1.0"
}
```

**Update marketplace.json:**

```json
{
  "plugins": [
    {
      "name": "my-plugin",
      "version": "2.1.0",
      "source": "./plugins/my-plugin"
    }
  ]
}
```

**Git Tags:**

```bash
git tag -a v2.1.0 -m "Release version 2.1.0"
git push origin v2.1.0
```

### Distribution Methods

**Method 1: Direct GitHub Installation**

Users add your marketplace using the repository name:

```
/plugin marketplace add yourusername/claude-plugins
```

Claude Code automatically:
- Clones the repository
- Reads `.claude-plugin/marketplace.json`
- Lists available plugins

**Method 2: Local Development Installation**

For testing or private use:

```
/plugin marketplace add /path/to/local/marketplace
```

**Method 3: Alternative Git Hosting**

Users can add marketplaces from any git service:

```
/plugin marketplace add https://gitlab.com/team/claude-plugins.git
```

**Publishing Checklist:**

1. ✅ Create comprehensive README with usage examples
2. ✅ Add LICENSE file (MIT, Apache-2.0, etc.)
3. ✅ Version all plugins semantically
4. ✅ Test marketplace.json syntax
5. ✅ Verify plugin installations locally
6. ✅ Create GitHub releases for versions
7. ✅ Add topics/tags to GitHub repo for discoverability
8. ✅ Document prerequisites and dependencies
9. ✅ Include CHANGELOG.md for version history
10. ✅ Add examples and screenshots

---

## Testing and Debugging

### Local Testing Workflow

**1. Create Development Marketplace:**

```bash
mkdir dev-marketplace
cd dev-marketplace
mkdir .claude-plugin
```

Create `.claude-plugin/marketplace.json`:

```json
{
  "name": "dev-marketplace",
  "owner": {
    "name": "Developer"
  },
  "plugins": [
    {
      "name": "my-plugin",
      "source": "/absolute/path/to/my-plugin",
      "description": "Plugin under development"
    }
  ]
}
```

**2. Add Marketplace to Claude Code:**

```
/plugin marketplace add /path/to/dev-marketplace
```

**3. Install Plugin:**

```
/plugin install my-plugin@dev-marketplace
```

**4. Test Components:**

- Commands: `/my-command` or `/my-plugin:my-command`
- Skills: Trigger scenarios that match skill descriptions
- Hooks: Perform actions that trigger hook events
- MCP: Verify tools appear in Claude's available tools

**5. Iterate:**

```
/plugin uninstall my-plugin@dev-marketplace
# Make changes to plugin
/plugin install my-plugin@dev-marketplace
```

**6. Verify:**

- `/help` - Check commands appear
- `/plugin` → "Manage Plugins" - Verify plugin details
- Test all functionality end-to-end

### Debugging Tools

**Enable Debug Mode:**

```bash
claude --debug
```

Debug output reveals:
- Plugin loading status
- Manifest parsing errors
- Component registration
- MCP server initialization
- Hook execution

**Manual Validation:**

```bash
# Validate JSON syntax
cat .claude-plugin/plugin.json | python -m json.tool

# Check file structure
tree -a -I '.git'

# Verify permissions
ls -la hooks/scripts/
```

**Test Commands:**

```
/plugin marketplace list
/plugin marketplace update marketplace-name
/plugin
/help
/mcp
```

### Common Issues

| Problem | Cause | Solution |
|---------|-------|----------|
| Plugin fails to load | Invalid JSON syntax | Validate `plugin.json` with JSON linter |
| Commands not appearing | Wrong directory location | Move `commands/` to plugin root |
| Hooks not executing | Missing execute permission | Run `chmod +x script.sh` |
| MCP server fails | Path resolution error | Use `${CLAUDE_PLUGIN_ROOT}` for paths |
| Version conflicts | Cached metadata | Run `/plugin marketplace update` |
| Relative paths fail | Absolute paths used | Use `./` prefix for relative paths |
| Skills not triggering | Vague description | Add specific trigger terms |
| Components invisible | Inside `.claude-plugin/` | Move to plugin root |

**Troubleshooting Steps:**

1. **Verify Structure:** Ensure components are at plugin root
2. **Check Syntax:** Validate all JSON files
3. **Test Paths:** Verify all file paths are accessible
4. **Review Permissions:** Check execute permissions on scripts
5. **Enable Debug:** Use `claude --debug` for detailed logs
6. **Isolate Components:** Test each component individually
7. **Check Documentation:** Verify against schema specifications

---

## Team Deployment

Distribute plugins to teams through repository-level configuration.

**1. Add marketplace to `.claude/settings.json`:**

```json
{
  "plugin": {
    "marketplaces": [
      {
        "name": "team-plugins",
        "source": {
          "source": "github",
          "repo": "yourorg/claude-plugins"
        }
      }
    ],
    "enabledPlugins": [
      "team-plugin@team-plugins"
    ]
  }
}
```

**2. Commit to repository:**

```bash
git add .claude/settings.json
git commit -m "Add team plugins configuration"
git push
```

**3. Team members setup:**

When team members clone the repository and trust the folder, Claude Code automatically:
- Installs configured marketplaces
- Enables specified plugins
- Makes commands and features available

**Benefits:**

- Standardized workflows across team
- Version-controlled plugin configuration
- Automatic setup for new team members
- Consistent tooling and commands

---

## Best Practices

### Plugin Design

1. **Single Responsibility:** Focus each plugin on a specific domain or workflow
2. **Clear Naming:** Use descriptive, kebab-case names
3. **Comprehensive Documentation:** Include README with examples
4. **Semantic Versioning:** Follow SemVer for all releases
5. **Minimal Dependencies:** Reduce external dependencies where possible

### Command Design

1. **Descriptive Names:** Use clear, action-oriented command names
2. **Useful Descriptions:** Write helpful frontmatter descriptions
3. **Argument Support:** Use placeholders for flexible commands
4. **Error Handling:** Instruct Claude to handle edge cases
5. **User Feedback:** Include confirmation and status messages

### Skill Design

1. **Specific Triggers:** Include concrete terms in descriptions (e.g., "Use when working with PDF files")
2. **Focused Scope:** One capability per skill
3. **Tool Restrictions:** Use `allowed-tools` for security and scope
4. **Clear Instructions:** Provide step-by-step workflows
5. **Test Coverage:** Verify skills trigger in expected scenarios

### Marketplace Management

1. **Curated Content:** Ensure quality of included plugins
2. **Clear Categories:** Organize plugins logically
3. **Version Tracking:** Keep plugin versions up-to-date
4. **Documentation:** Maintain comprehensive README
5. **Regular Updates:** Review and update plugin listings

### Security Considerations

1. **Review Code:** Audit plugin code before distribution
2. **Minimize Permissions:** Use `allowed-tools` to restrict access
3. **Environment Variables:** Use variable expansion for secrets
4. **Hook Safety:** Validate hook scripts for security
5. **Dependencies:** Document and minimize external dependencies

### Distribution

1. **GitHub Topics:** Add relevant topics for discoverability
2. **Releases:** Use GitHub Releases for versions
3. **Changelog:** Maintain detailed version history
4. **Examples:** Provide usage examples and screenshots
5. **Support:** Document how to report issues and get help

---

## Reference

### Plugin Management Commands

```bash
# Marketplace Management
/plugin marketplace add <github-repo>
/plugin marketplace add <git-url>
/plugin marketplace add <local-path>
/plugin marketplace list
/plugin marketplace update <marketplace-name>
/plugin marketplace remove <marketplace-name>

# Plugin Installation
/plugin                                    # Interactive browser
/plugin install <plugin-name>@<marketplace>
/plugin enable <plugin-name>@<marketplace>
/plugin disable <plugin-name>@<marketplace>
/plugin uninstall <plugin-name>@<marketplace>

# Discovery
/help                                      # List all commands
/mcp                                       # List MCP servers
```

### Environment Variables

- `${CLAUDE_PLUGIN_ROOT}` - Absolute path to plugin directory
- `${VARIABLE}` - Environment variable expansion
- `${VARIABLE:-default}` - Variable with default value

### File Paths

- Always use relative paths with `./` prefix
- Use `${CLAUDE_PLUGIN_ROOT}` for absolute plugin paths
- Forward slashes `/` for cross-platform compatibility

### Validation Tools

```bash
# JSON validation
cat plugin.json | python -m json.tool

# Structure verification
tree -a -I '.git'

# Permission check
ls -la scripts/
```

### Official Resources

- [Claude Code Plugins Documentation](https://docs.claude.com/en/docs/claude-code/plugins.md)
- [Plugin Marketplaces Guide](https://docs.claude.com/en/docs/claude-code/plugin-marketplaces.md)
- [Plugin Reference](https://docs.claude.com/en/docs/claude-code/plugins-reference.md)
- [Skills Documentation](https://docs.claude.com/en/docs/claude-code/skills.md)
- [MCP Integration](https://docs.claude.com/en/docs/claude-code/mcp.md)

---

## Appendix: Complete Example

### Example: Git Workflow Plugin

**Directory Structure:**

```
git-workflow-plugin/
├── .claude-plugin/
│   └── plugin.json
├── commands/
│   ├── smart-commit.md
│   └── create-pr.md
├── skills/
│   └── git-analyzer/
│       └── SKILL.md
└── README.md
```

**plugin.json:**

```json
{
  "name": "git-workflow",
  "version": "1.0.0",
  "description": "Streamlined git workflow automation for teams",
  "author": {
    "name": "Your Name",
    "email": "you@example.com"
  },
  "homepage": "https://github.com/yourusername/git-workflow-plugin",
  "repository": "https://github.com/yourusername/git-workflow-plugin",
  "license": "MIT",
  "keywords": ["git", "workflow", "automation", "vcs"]
}
```

**commands/smart-commit.md:**

```markdown
---
description: Create intelligent git commits with conventional commit messages
---

# Smart Commit

Analyze the current git diff and staged changes, then:

1. Identify the type of change (feat, fix, docs, refactor, test, chore)
2. Generate a conventional commit message following the format:
   `<type>(<scope>): <description>`
3. Include a body explaining the "why" if changes are significant
4. Ask user for confirmation before committing

Example:
- `feat(auth): add OAuth2 authentication support`
- `fix(api): resolve null pointer in user service`
```

**commands/create-pr.md:**

```markdown
---
description: Create a pull request with generated description
---

# Create Pull Request

Create a pull request for the current branch:

1. Compare current branch with main/master
2. Analyze all commits in the branch
3. Generate a comprehensive PR description including:
   - Summary of changes
   - Testing checklist
   - Breaking changes (if any)
4. Push branch if not already pushed
5. Create PR using gh CLI

Ask for user confirmation before creating the PR.
```

**skills/git-analyzer/SKILL.md:**

```markdown
---
name: Git Analyzer
description: Analyze git repository history, branches, and changes. Use when working with git repositories or when user mentions git analysis.
allowed-tools:
  - Bash
  - Read
  - Grep
---

# Git Analysis Skill

Automatically analyze git repositories when the user:
- Asks about repository history
- Wants to understand branch differences
- Needs to review commit patterns
- Requests code change analysis

Provide insights on:
- Commit frequency and patterns
- Active branches and their status
- Code churn and hot spots
- Contributor activity
```

**README.md:**

```markdown
# Git Workflow Plugin

Streamlined git workflow automation for Claude Code.

## Features

- **Smart Commits**: Generate conventional commit messages automatically
- **PR Creation**: Create comprehensive pull requests with one command
- **Git Analysis**: Automatic repository insights and analysis

## Installation

\`\`\`
/plugin marketplace add yourusername/git-workflow-plugin
/plugin install git-workflow@yourusername
\`\`\`

## Usage

### Smart Commit
\`\`\`
/smart-commit
\`\`\`

### Create PR
\`\`\`
/create-pr
\`\`\`

## Requirements

- Git installed and configured
- GitHub CLI (gh) for PR creation

## License

MIT
```

**Marketplace Publication:**

Create `.claude-plugin/marketplace.json`:

```json
{
  "name": "git-workflow-marketplace",
  "owner": {
    "name": "Your Name",
    "email": "you@example.com"
  },
  "plugins": [
    {
      "name": "git-workflow",
      "source": ".",
      "description": "Streamlined git workflow automation",
      "version": "1.0.0",
      "category": "Version Control"
    }
  ]
}
```

---

## Conclusion

Claude Code's plugin system provides a powerful way to extend functionality and share workflows. By following this guide, you can create professional plugins, publish them on GitHub, and distribute them through marketplaces to teams and the community.

**Next Steps:**

1. Create your first plugin following the examples
2. Test thoroughly using the local development workflow
3. Publish to GitHub with comprehensive documentation
4. Share with your team or the community
5. Iterate based on feedback and usage

Happy plugin development!
