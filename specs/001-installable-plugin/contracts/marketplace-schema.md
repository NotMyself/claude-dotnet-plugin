# Marketplace Catalog Schema

**File**: `.claude-plugin/marketplace.json`
**Purpose**: Define plugin distribution configuration for marketplace installation

## JSON Schema

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["name", "owner", "plugins"],
  "properties": {
    "name": {
      "type": "string",
      "description": "Marketplace identifier (unique name for this catalog)"
    },
    "owner": {
      "type": "object",
      "required": ["name"],
      "properties": {
        "name": {
          "type": "string",
          "minLength": 1,
          "description": "Marketplace owner/maintainer name"
        },
        "email": {
          "type": "string",
          "format": "email",
          "description": "Owner contact email (optional but recommended)"
        }
      }
    },
    "pluginRoot": {
      "type": "string",
      "description": "Base path for resolving relative plugin sources (optional)"
    },
    "plugins": {
      "type": "array",
      "minItems": 1,
      "items": {
        "$ref": "#/definitions/PluginEntry"
      },
      "description": "Array of plugin entries available in this marketplace"
    }
  },
  "definitions": {
    "PluginEntry": {
      "type": "object",
      "required": ["name", "source", "description"],
      "properties": {
        "name": {
          "type": "string",
          "pattern": "^[a-z0-9]+(-[a-z0-9]+)*$",
          "description": "Plugin identifier (must match plugin.json name)"
        },
        "source": {
          "oneOf": [
            {"type": "string", "description": "Relative path, absolute path, or git URL"},
            {"$ref": "#/definitions/GitHubSource"}
          ],
          "description": "Plugin location (path or repository reference)"
        },
        "description": {
          "type": "string",
          "minLength": 1,
          "maxLength": 200,
          "description": "Plugin description (shown in marketplace listings)"
        },
        "version": {
          "type": "string",
          "pattern": "^\\d+\\.\\d+\\.\\d+$",
          "description": "Plugin version (recommended, should match plugin.json)"
        },
        "category": {
          "type": "string",
          "description": "Category for organization (e.g., 'Development Tools', 'Security')"
        },
        "author": {
          "type": "string",
          "description": "Plugin author name (optional, shown in listings)"
        },
        "homepage": {
          "type": "string",
          "format": "uri",
          "description": "Plugin documentation URL"
        },
        "license": {
          "type": "string",
          "description": "License type (e.g., 'MIT', 'Apache-2.0')"
        },
        "keywords": {
          "type": "array",
          "items": {"type": "string"},
          "description": "Search tags for filtering"
        }
      }
    },
    "GitHubSource": {
      "type": "object",
      "required": ["source", "repo"],
      "properties": {
        "source": {
          "type": "string",
          "enum": ["github"],
          "description": "Source type identifier"
        },
        "repo": {
          "type": "string",
          "pattern": "^[a-zA-Z0-9_-]+/[a-zA-Z0-9_-]+$",
          "description": "GitHub repository in 'owner/repo' format"
        },
        "ref": {
          "type": "string",
          "description": "Branch, tag, or commit SHA (optional, defaults to main/master)"
        }
      }
    }
  }
}
```

## Field Descriptions

### Marketplace-Level Fields

#### `name` (string, required)
- **Purpose**: Unique identifier for this marketplace catalog
- **Examples**: `"claude-dotnet-plugin-marketplace"`, `"team-plugins"`, `"dev-marketplace"`
- **Best Practices**:
  - Use descriptive names for team or organization marketplaces
  - For single-plugin marketplaces, consider including plugin name

#### `owner` (object, required)
- **Purpose**: Marketplace maintainer information
- **Required**: `name` (string)
- **Optional**: `email` (string, email format)
- **Example**:
  ```json
  "owner": {
    "name": "Bobby Johnson",
    "email": "bobby@example.com"
  }
  ```

#### `pluginRoot` (string, optional)
- **Purpose**: Base directory for resolving relative plugin source paths
- **Use Case**: Monorepo with plugins in subdirectories
- **Example**: `"./plugins"` makes source `"my-plugin"` resolve to `"./plugins/my-plugin"`
- **Default**: Current directory if not specified

#### `plugins` (array, required)
- **Purpose**: List of available plugins in this marketplace
- **Min Items**: 1
- **Contains**: PluginEntry objects (see below)

### Plugin Entry Fields

#### `name` (string, required)
- **Format**: Kebab-case, must match plugin.json name field
- **Purpose**: Plugin identifier for installation commands
- **Example**: `"claude-dotnet-plugin"`
- **Constraints**: Must be unique within marketplace

#### `source` (string or object, required)
- **Purpose**: Specifies plugin location
- **Formats**:

  **Relative Path** (for monorepo/local):
  ```json
  "source": "."                    // Current directory (single plugin)
  "source": "./plugins/my-plugin"  // Subdirectory
  "source": "../other-plugin"      // Parent directory
  ```

  **Absolute Path** (for local development):
  ```json
  "source": "C:/Users/User/src/plugin"  // Windows
  "source": "/home/user/src/plugin"     // Unix
  ```

  **Git URL**:
  ```json
  "source": "https://github.com/owner/plugin.git"
  "source": "git://github.com/owner/plugin.git"
  ```

  **GitHub Object** (recommended for GitHub repositories):
  ```json
  "source": {
    "source": "github",
    "repo": "BobbyJohnson/claude-dotnet-plugin",
    "ref": "v1.0.0"  // Optional: branch, tag, or commit
  }
  ```

#### `description` (string, required)
- **Format**: 1-200 characters
- **Purpose**: Brief plugin summary for marketplace listings
- **Example**: `"Modern .NET development agents and Azure expertise"`
- **Best Practices**: Should match or closely align with plugin.json description

#### `version` (string, optional but recommended)
- **Format**: Semantic versioning (MAJOR.MINOR.PATCH)
- **Purpose**: Plugin version display in marketplace
- **Example**: `"1.0.0"`
- **Important**: Should match plugin.json version field for consistency

#### `category` (string, optional)
- **Purpose**: Organize plugins by type/domain
- **Examples**:
  - `"Development Tools"`
  - `"Security"`
  - `"Testing"`
  - `"Documentation"`
  - `"DevOps"`
- **Best Practices**: Use consistent category names across marketplace

#### `author` (string, optional)
- **Purpose**: Display plugin author in marketplace listings
- **Example**: `"Bobby Johnson"`
- **Note**: Can differ from marketplace owner (e.g., curated third-party plugins)

#### `homepage` (string, optional)
- **Format**: Valid URL
- **Purpose**: Link to plugin documentation
- **Example**: `"https://github.com/BobbyJohnson/claude-dotnet-plugin"`

#### `license` (string, optional)
- **Format**: SPDX license identifier
- **Purpose**: Display license in marketplace
- **Examples**: `"MIT"`, `"Apache-2.0"`, `"GPL-3.0"`

#### `keywords` (array of strings, optional)
- **Purpose**: Enable plugin search and filtering
- **Example**: `["dotnet", "csharp", "azure", "devops"]`

## Distribution Patterns

### Pattern 1: Single Plugin (Recommended for this project)

**Use Case**: One plugin per repository

**Structure**:
```
claude-dotnet-plugin/
├── .claude-plugin/
│   ├── plugin.json         # Plugin metadata
│   └── marketplace.json    # Distribution config
├── agents/
├── skills/
└── README.md
```

**marketplace.json**:
```json
{
  "name": "claude-dotnet-plugin-marketplace",
  "owner": {"name": "Bobby Johnson", "email": "bobby@example.com"},
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

**Installation**:
```
/plugin marketplace add BobbyJohnson/claude-dotnet-plugin
/plugin install claude-dotnet-plugin
```

### Pattern 2: Monorepo Marketplace

**Use Case**: Multiple related plugins in one repository

**Structure**:
```
my-plugins/
├── .claude-plugin/
│   └── marketplace.json
├── plugins/
│   ├── plugin-a/
│   │   ├── .claude-plugin/plugin.json
│   │   └── agents/
│   └── plugin-b/
│       ├── .claude-plugin/plugin.json
│       └── skills/
```

**marketplace.json**:
```json
{
  "name": "my-plugins-marketplace",
  "owner": {"name": "Developer"},
  "pluginRoot": "./plugins",
  "plugins": [
    {
      "name": "plugin-a",
      "source": "plugin-a",
      "description": "First plugin",
      "version": "1.0.0"
    },
    {
      "name": "plugin-b",
      "source": "plugin-b",
      "description": "Second plugin",
      "version": "1.2.0"
    }
  ]
}
```

### Pattern 3: Catalog Marketplace

**Use Case**: Curated list of external plugins

**marketplace.json**:
```json
{
  "name": "curated-plugins",
  "owner": {"name": "Team Lead"},
  "plugins": [
    {
      "name": "plugin-1",
      "source": {
        "source": "github",
        "repo": "user1/plugin-1",
        "ref": "v1.0.0"
      },
      "description": "External plugin 1",
      "version": "1.0.0"
    },
    {
      "name": "plugin-2",
      "source": "https://github.com/user2/plugin-2.git",
      "description": "External plugin 2",
      "version": "2.1.0"
    }
  ]
}
```

## Validation

### Manual Validation

**JSON Syntax**:
```bash
# PowerShell
Get-Content .claude-plugin/marketplace.json | ConvertFrom-Json

# Unix
cat .claude-plugin/marketplace.json | python -m json.tool
```

**Schema Validation**:
```bash
ajv validate -s marketplace-schema.json -d .claude-plugin/marketplace.json
```

### Common Validation Errors

| Error | Cause | Fix |
|-------|-------|-----|
| "plugins required" | Missing plugins array | Add at least one plugin entry |
| "minItems not met" | Empty plugins array | Add at least one plugin entry |
| "name must match plugin.json" | Name mismatch between files | Synchronize name fields |
| "version mismatch" | Different versions in plugin.json vs marketplace.json | Update to match |
| "invalid GitHub repo format" | Missing slash in owner/repo | Use correct "owner/repo" format |

## Example: Development Marketplace

**For local testing** (absolute path):

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

**Installation**:
```
/plugin marketplace add C:\dev\claude-marketplaces\dev-marketplace
/plugin install claude-dotnet-plugin@dev-marketplace
```

## Example: Production Marketplace

**For GitHub distribution**:

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

## Best Practices

1. **Version Synchronization**: Always keep marketplace plugin version matching plugin.json
2. **Source Format**: Use GitHub object format for production, absolute paths for development
3. **Metadata Completeness**: Include version, category, homepage, license for better UX
4. **Description Consistency**: Marketplace description should match plugin.json
5. **Single Plugin**: Use `"source": "."` for single-plugin repositories
6. **Validation**: Validate JSON before every commit and release
7. **Testing**: Test with local marketplace before GitHub publication
8. **Documentation**: Ensure homepage URL provides installation and usage instructions

## Related Schemas

- [Plugin Manifest Schema](./plugin-manifest-schema.md)
