# Plugin Manifest Schema

**File**: `.claude-plugin/plugin.json`
**Purpose**: Define plugin identity, metadata, and configuration for Claude Code

## JSON Schema

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["name", "version", "description", "author"],
  "properties": {
    "name": {
      "type": "string",
      "pattern": "^[a-z0-9]+(-[a-z0-9]+)*$",
      "description": "Plugin identifier in kebab-case format",
      "examples": ["claude-dotnet-plugin", "my-awesome-plugin"]
    },
    "version": {
      "type": "string",
      "pattern": "^\\d+\\.\\d+\\.\\d+$",
      "description": "Semantic version (MAJOR.MINOR.PATCH)",
      "examples": ["1.0.0", "2.1.3"]
    },
    "description": {
      "type": "string",
      "minLength": 1,
      "maxLength": 200,
      "description": "Brief plugin purpose and capabilities"
    },
    "author": {
      "type": "object",
      "required": ["name", "email"],
      "properties": {
        "name": {
          "type": "string",
          "minLength": 1,
          "description": "Author full name"
        },
        "email": {
          "type": "string",
          "format": "email",
          "description": "Author contact email"
        }
      }
    },
    "homepage": {
      "type": "string",
      "format": "uri",
      "description": "Plugin documentation website URL"
    },
    "repository": {
      "type": "string",
      "format": "uri",
      "description": "Source repository URL (GitHub, GitLab, etc.)"
    },
    "license": {
      "type": "string",
      "description": "SPDX license identifier",
      "examples": ["MIT", "Apache-2.0", "GPL-3.0", "ISC"]
    },
    "keywords": {
      "type": "array",
      "items": {
        "type": "string",
        "pattern": "^[a-z0-9-]+$"
      },
      "description": "Search tags for discoverability",
      "examples": [["dotnet", "csharp"], ["python", "ml", "data"]]
    },
    "commands": {
      "type": "object",
      "patternProperties": {
        "^[a-z0-9-]+$": {
          "type": "string",
          "description": "Custom path to commands directory"
        }
      },
      "description": "Optional custom component paths (supplements defaults)"
    },
    "agents": {
      "type": "object",
      "patternProperties": {
        "^[a-z0-9-]+$": {
          "type": "string",
          "description": "Custom path to agents directory"
        }
      },
      "description": "Optional custom component paths (supplements defaults)"
    },
    "skills": {
      "type": "object",
      "patternProperties": {
        "^[a-z0-9-]+$": {
          "type": "string",
          "description": "Custom path to skills directory"
        }
      },
      "description": "Optional custom component paths (supplements defaults)"
    }
  }
}
```

## Field Descriptions

### Required Fields

#### `name` (string, required)
- **Format**: Kebab-case (lowercase with hyphens)
- **Pattern**: `^[a-z0-9]+(-[a-z0-9]+)*$`
- **Purpose**: Unique plugin identifier used for installation and referencing
- **Examples**: `"claude-dotnet-plugin"`, `"react-expert"`, `"security-tools"`
- **Constraints**:
  - Must be globally unique in marketplace
  - Cannot contain uppercase, spaces, or special characters except hyphens
  - Should be descriptive but concise

#### `version` (string, required)
- **Format**: Semantic versioning (MAJOR.MINOR.PATCH)
- **Pattern**: `^\d+\.\d+\.\d+$`
- **Purpose**: Plugin version for compatibility and update management
- **Examples**: `"1.0.0"`, `"2.1.3"`, `"0.9.15"`
- **Constraints**:
  - MAJOR: Incremented for breaking changes
  - MINOR: Incremented for new features (backward compatible)
  - PATCH: Incremented for bug fixes (backward compatible)
  - Must match marketplace.json plugin entry version

#### `description` (string, required)
- **Format**: Plain text, 1-200 characters
- **Purpose**: Brief summary of plugin capabilities shown in plugin listings
- **Examples**: `"Modern .NET development agents and Azure expertise for Claude Code"`
- **Best Practices**:
  - Start with what the plugin does (verb phrase)
  - Mention primary technologies or domains
  - Keep under 100 characters for better display

#### `author` (object, required)
- **Purpose**: Plugin creator/maintainer contact information
- **Required Fields**:
  - `name` (string): Full name or organization name
  - `email` (string): Valid email address for contact/support
- **Example**:
  ```json
  "author": {
    "name": "Bobby Johnson",
    "email": "bobby@example.com"
  }
  ```

### Recommended Fields

#### `homepage` (string, optional but recommended)
- **Format**: Valid HTTP/HTTPS URL
- **Purpose**: Link to plugin documentation, website, or landing page
- **Examples**: `"https://github.com/BobbyJohnson/claude-dotnet-plugin"`
- **Best Practices**: Should provide comprehensive documentation, usage examples, and support information

#### `repository` (string, optional but recommended)
- **Format**: Valid HTTP/HTTPS URL to Git repository
- **Purpose**: Link to source code for transparency, issues, and contributions
- **Examples**:
  - `"https://github.com/BobbyJohnson/claude-dotnet-plugin"`
  - `"https://gitlab.com/user/plugin-name"`
- **Best Practices**: Use public repository for open-source plugins

#### `license` (string, optional but recommended)
- **Format**: SPDX license identifier
- **Purpose**: Defines usage rights and restrictions
- **Common Values**: `"MIT"`, `"Apache-2.0"`, `"GPL-3.0"`, `"ISC"`, `"BSD-3-Clause"`
- **Best Practices**:
  - Use permissive licenses (MIT, Apache-2.0) for maximum adoption
  - Must match LICENSE file in repository root

### Optional Fields

#### `keywords` (array of strings, optional)
- **Purpose**: Improve searchability and categorization
- **Format**: Array of lowercase, hyphenated tags
- **Examples**: `["dotnet", "csharp", "azure", "devops", "development"]`
- **Best Practices**:
  - Include primary technologies (languages, frameworks)
  - Add domain terms (devops, security, testing)
  - Limit to 3-7 relevant keywords
  - Use consistent terminology

#### `commands`, `agents`, `skills` (objects, optional)
- **Purpose**: Override default component directory paths
- **Format**: Map of component names to custom paths
- **Default Behavior**: Claude Code looks for components at:
  - `commands/` - Command definitions
  - `agents/` - Agent definitions
  - `skills/` - Skill definitions
- **Use Cases**:
  - Organize multiple component sets
  - Maintain backward compatibility after reorganization
- **Note**: Custom paths supplement defaults, not replace them

## Validation

### Manual Validation

**JSON Syntax**:
```bash
# PowerShell
Get-Content .claude-plugin/plugin.json | ConvertFrom-Json

# Unix
cat .claude-plugin/plugin.json | python -m json.tool
```

**Schema Validation**:
```bash
# Using ajv-cli (install: npm install -g ajv-cli)
ajv validate -s plugin-manifest-schema.json -d .claude-plugin/plugin.json
```

### Common Validation Errors

| Error | Cause | Fix |
|-------|-------|-----|
| "name must match pattern" | Uppercase or invalid characters | Convert to lowercase kebab-case |
| "version must match pattern" | Missing patch version or invalid format | Use MAJOR.MINOR.PATCH format |
| "description required" | Missing or empty | Add concise plugin description |
| "author.email invalid format" | Not valid email | Use valid email address |
| "Unexpected token" | JSON syntax error | Check for missing commas, brackets, quotes |

## Example: Claude .NET Plugin

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

## Best Practices

1. **Naming**: Use descriptive, technology-specific names (e.g., "python-ml-toolkit", "react-expert")
2. **Versioning**: Start at 1.0.0 for stable releases, 0.x.x for pre-release
3. **Description**: Focus on value proposition and primary use cases
4. **Metadata**: Always include homepage, repository, and license for transparency
5. **Keywords**: Balance specificity and discoverability (avoid too generic or too niche)
6. **Validation**: Run JSON validation before every commit
7. **Synchronization**: Keep plugin.json version synchronized with marketplace.json
8. **Documentation**: Ensure homepage URL provides comprehensive plugin documentation

## Related Schemas

- [Marketplace Catalog Schema](./marketplace-schema.md)
- [Agent Frontmatter Schema](./agent-frontmatter-schema.md) (if created)
- [Skill Frontmatter Schema](./skill-frontmatter-schema.md) (if created)
