<!--
Sync Impact Report - Constitution v1.0.0
========================================
Version Change: TEMPLATE → 1.0.0 (Initial Constitution)
Ratification Date: 2025-10-22

Modified Principles:
- All placeholder principles replaced with concrete Claude Code plugin development principles

Added Sections:
- Plugin-First Architecture principle
- Component Independence & Testing principle
- Marketplace-Ready Distribution principle
- Documentation & Discoverability Standards principle
- Semantic Versioning principle
- Quality Standards section
- Development Workflow section
- Governance rules with amendment procedures

Templates Status:
✅ plan-template.md - Constitution Check section verified, no updates needed (generic gates work)
✅ spec-template.md - Requirements structure aligns with plugin functionality needs
✅ tasks-template.md - Task categorization supports plugin component types
⚠️ commands/*.md - No command files present yet; when added, ensure generic guidance (no agent-specific names)

Follow-up TODOs:
- None. All placeholders resolved.
-->

# Claude Code Plugin Development Constitution

## Core Principles

### I. Plugin-First Architecture

**Every feature MUST be packaged as a distributable plugin with proper manifest.**

- All plugins MUST contain `.claude-plugin/plugin.json` manifest with required fields (name, version, description, author)
- Component directories (commands, agents, skills, hooks) MUST reside at plugin root, NOT inside `.claude-plugin/`
- Plugin manifest MUST use kebab-case naming and follow semantic versioning (MAJOR.MINOR.PATCH)
- Custom component paths in manifest supplement defaults—they don't replace them
- MCP servers MUST use `${CLAUDE_PLUGIN_ROOT}` for plugin-relative paths and support variable expansion

**Rationale**: Plugin-first ensures reusability across projects, enables team distribution, and maintains modularity. Proper structure prevents common loading failures and ensures Claude Code can discover all components.

### II. Component Independence & Testing

**Each component type (commands, skills, agents, hooks, MCP) MUST be independently testable and documented.**

- **Commands**: Markdown files with frontmatter description; MUST support argument placeholders `{arg}` and file references `@file`
- **Skills**: MUST include `name`, `description` with specific trigger terms, and `allowed-tools` restrictions in YAML frontmatter
- **Agents**: MUST provide specialized domain expertise with clear use-case descriptions
- **Hooks**: MUST have executable permissions (`chmod +x`) and use `${CLAUDE_PLUGIN_ROOT}` for paths
- **MCP Servers**: MUST declare transport type (stdio/http), support environment variables with defaults `${VAR:-default}`

**Testing Requirements**:

- All components MUST be tested using local development marketplace before publication
- Local testing workflow: create dev marketplace → install plugin → test each component → iterate
- Commands tested via invocation: `/command` or `/plugin-name:command`
- Skills tested by triggering scenarios matching description terms
- Hooks tested by performing trigger events
- MCP tested by verifying tools appear in Claude's available tools list

**Rationale**: Independence ensures components can be developed, tested, and deployed in isolation, reducing coupling and enabling parallel development.

### III. Marketplace-Ready Distribution

**All plugins MUST be distributable through marketplace catalogs with proper metadata.**

- Every plugin repository MUST include `.claude-plugin/marketplace.json` catalog
- Marketplace manifest MUST declare `name` (kebab-case), `owner` (name + email), and `plugins` array
- Plugin entries MUST specify `source` (relative path, GitHub repo, or git URL)
- Source specifications support: relative paths `./plugins/name`, GitHub `{"source":"github","repo":"user/repo"}`, git URLs
- Marketplace metadata MAY include `pluginRoot` for base path resolution
- Plugin entries MUST include descriptive metadata: description, version, author, homepage, license, keywords, category

**Distribution Patterns**:

- **Monorepo Marketplace**: Multiple plugins in `plugins/` directory with relative sources
- **Catalog Marketplace**: External plugin references using GitHub/git sources
- **Single Plugin**: Repository with both `plugin.json` and `marketplace.json` (source: `.`)

**Rationale**: Marketplace-ready design enables discoverability, team deployment via `.claude/settings.json`, and automatic updates.

### IV. Documentation & Discoverability Standards

**All plugins MUST include comprehensive documentation with clear usage examples.**

- Root `README.md` MUST document: purpose, features, installation, usage examples, requirements, license
- Command descriptions MUST be concise (shown in `/help`) with detailed instructions in body
- Skill descriptions MUST include specific trigger terms for Claude's autonomous discovery (e.g., "Use when working with PDF files")
- Skills MUST maintain singular focus per capability domain—no multi-purpose skills
- All components MUST document version history and breaking changes in CHANGELOG.md
- Marketplace-published plugins MUST include GitHub topics/tags for discoverability

**Markdown Standards**:

- Follow CommonMark specification
- Use GitHub-flavored markdown for code blocks and tables
- Frontmatter MUST use YAML format with `---` delimiters
- Command frontmatter: `description: Brief description shown in /help`
- Skill frontmatter: `name:`, `description:`, `allowed-tools:` (array)

**Rationale**: Clear documentation reduces onboarding time, enables self-service adoption, and improves Claude's ability to autonomously discover and invoke appropriate skills.

### V. Semantic Versioning & Release Management

**All version changes MUST follow semantic versioning (SemVer) with strict interpretation.**

**Version Format**: MAJOR.MINOR.PATCH (e.g., 2.1.0)

- **MAJOR** (1.0.0 → 2.0.0): Breaking changes—incompatible API changes, removed features, structural reorganization
- **MINOR** (1.0.0 → 1.1.0): New features, backward compatible—new commands/skills/hooks, enhanced functionality
- **PATCH** (1.0.0 → 1.0.1): Bug fixes, backward compatible—error corrections, documentation updates, typo fixes

**Version Synchronization**:

- `plugin.json` version MUST match marketplace.json plugin entry version
- Git tags MUST be created for all releases: `git tag -a v2.1.0 -m "Release version 2.1.0"`
- CHANGELOG.md MUST document all changes categorized by version
- GitHub Releases MUST be created for all tagged versions

**Pre-Release Testing**:

- All version increments MUST pass local testing workflow before publication
- Breaking changes (MAJOR) MUST include migration guide in CHANGELOG.md
- New features (MINOR) MUST include usage examples in README.md

**Rationale**: Strict versioning enables users to manage updates safely, understand breaking changes, and rely on backward compatibility within major versions.

## Quality Standards

**All plugin components MUST adhere to quality gates before publication.**

### JSON Validation

- All JSON files (`plugin.json`, `marketplace.json`, `hooks.json`, `.mcp.json`) MUST be valid
- Validation command: `cat file.json | python -m json.tool` or JSON linter
- Required fields MUST NOT be omitted (see schema references in research doc)

### File Structure Validation

- Verify structure: `tree -a -I '.git'` (Unix) or `Get-ChildItem -Recurse` (PowerShell)
- Commands MUST be in `commands/` directory (or custom path in manifest)
- Skills MUST be in `skills/skill-name/SKILL.md` structure
- Agents MUST be in `agents/` directory
- Hooks MUST be in `hooks/` with `hooks.json` and executable scripts

### Permission Verification

- All hook scripts MUST have executable permissions: `chmod +x scripts/hook.sh`
- Verify permissions: `ls -la hooks/scripts/` (Unix) or `Get-Acl` (PowerShell)
- Windows: Ensure scripts have appropriate execution policy settings

### Component Validation

- Commands MUST have valid frontmatter and trigger correctly: `/command-name`
- Skills MUST trigger on described scenarios—test with realistic use cases
- MCP servers MUST initialize without errors—check with `/mcp` command
- Hooks MUST execute on trigger events without failure

### Security Review

- Minimize tool permissions in skills via `allowed-tools` frontmatter
- Audit hook scripts for security risks before distribution
- Use environment variables for secrets—NEVER hardcode credentials
- Document external dependencies and security considerations in README.md
- Review code for common vulnerabilities before marketplace publication

## Development Workflow

**All plugin development MUST follow this workflow to ensure quality and consistency.**

### 1. Initial Setup

```bash
mkdir plugin-name
cd plugin-name
mkdir .claude-plugin commands skills agents hooks
```

Create `.claude-plugin/plugin.json`:

```json
{
  "name": "plugin-name",
  "version": "1.0.0",
  "description": "Plugin purpose",
  "author": {
    "name": "Your Name",
    "email": "you@example.com"
  },
  "homepage": "https://github.com/username/plugin-name",
  "license": "MIT",
  "keywords": ["tag1", "tag2"]
}
```

Initialize git:

```bash
git init
git add .
git commit -m "Initial plugin structure"
```

### 2. Component Development

- Create components in appropriate directories (commands, skills, etc.)
- Follow component-specific standards (see Principle II)
- Document each component with clear descriptions and examples
- Commit after each logical component addition

### 3. Local Testing

Create development marketplace:
```bash
mkdir ../dev-marketplace
cd ../dev-marketplace
mkdir .claude-plugin
```

Create `.claude-plugin/marketplace.json`:

```json
{
  "name": "dev-marketplace",
  "owner": {"name": "Developer"},
  "plugins": [
    {
      "name": "plugin-name",
      "source": "/absolute/path/to/plugin-name",
      "description": "Plugin under development"
    }
  ]
}
```

Test workflow:

```text
/plugin marketplace add /path/to/dev-marketplace
/plugin install plugin-name@dev-marketplace
[Test all components]
/plugin uninstall plugin-name@dev-marketplace
[Make changes]
/plugin install plugin-name@dev-marketplace
```

### 4. Pre-Publication Checklist

- ✅ All JSON files validated
- ✅ File structure verified
- ✅ Hook scripts have executable permissions
- ✅ All components tested locally
- ✅ README.md complete with examples
- ✅ CHANGELOG.md documents version
- ✅ LICENSE file present
- ✅ Version numbers synchronized (plugin.json ↔ marketplace.json)
- ✅ Security review completed
- ✅ Git tag created for version

### 5. Publication

```bash
# Commit final changes
git add .
git commit -m "Release version X.Y.Z"

# Create version tag
git tag -a vX.Y.Z -m "Release version X.Y.Z"
git push origin main
git push origin vX.Y.Z

# Create GitHub Release
# Use GitHub UI or gh CLI to create release from tag
```

### 6. Team Deployment (Optional)

Add to repository `.claude/settings.json`:

```json
{
  "plugin": {
    "marketplaces": [
      {
        "name": "team-plugins",
        "source": {
          "source": "github",
          "repo": "org/claude-plugins"
        }
      }
    ],
    "enabledPlugins": [
      "plugin-name@team-plugins"
    ]
  }
}
```

Commit settings:

```bash
git add .claude/settings.json
git commit -m "Add team plugins configuration"
git push
```

Team members automatically receive plugins when they clone/trust the folder.

## Governance

**This constitution supersedes all other development practices for Claude Code plugins.**

### Amendment Process

1. **Proposal**: Document proposed amendment with rationale in GitHub issue or RFC
2. **Review**: Team/maintainer review for consistency with plugin architecture principles
3. **Approval**: Consensus or maintainer approval required
4. **Migration Plan**: For breaking governance changes, document migration path
5. **Update**: Increment constitution version (MAJOR/MINOR/PATCH based on impact)
6. **Propagation**: Update dependent templates (plan, spec, tasks) to align
7. **Announcement**: Document in CHANGELOG.md and notify stakeholders

### Versioning

- **MAJOR** (1.0.0 → 2.0.0): Backward-incompatible governance changes, principle removals/redefinitions
- **MINOR** (1.0.0 → 1.1.0): New principle added, materially expanded guidance, new mandatory sections
- **PATCH** (1.0.0 → 1.0.1): Clarifications, wording improvements, typo fixes, non-semantic refinements

### Compliance

- All plugin development MUST verify compliance with constitution principles
- Pre-publication checklist serves as compliance gate
- Violations MUST be justified in plan.md Complexity Tracking section if unavoidable
- Unjustified violations block publication

### Review Cycle

- Constitution SHOULD be reviewed after every 5 plugin releases or quarterly
- Review checks: principle relevance, clarity, completeness, alignment with Claude Code platform updates
- Template synchronization verified during review

### Guidance References

- Primary development guidance: This constitution file
- Implementation planning: `.specify/templates/plan-template.md`
- Feature specification: `.specify/templates/spec-template.md`
- Task organization: `.specify/templates/tasks-template.md`
- Official platform docs: <https://docs.claude.com/en/docs/claude-code/plugins.md>

---

**Version**: 1.0.0 | **Ratified**: 2025-10-22 | **Last Amended**: 2025-10-22
