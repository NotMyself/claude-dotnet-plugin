# Implementation Plan: Claude .NET Plugin

**Branch**: `001-installable-plugin` | **Date**: 2025-10-22 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-installable-plugin/spec.md`

## Summary

Transform the existing migrate directory contents (agents and templates) into a production-ready, installable Claude Code plugin following constitutional best practices. The plugin will provide .NET 9/C# 13 development expertise, Azure/DevOps guidance, Git workflow management, and project documentation templates through Claude Code's agent and skill system. Primary technical approach involves converting JSON agent specifications to markdown with YAML frontmatter, creating proper plugin manifests, implementing security sanitization, and establishing marketplace distribution infrastructure.

## Technical Context

**Language/Version**: Markdown (agents/skills), JSON (manifests), PowerShell 7+ (testing scripts)
**Primary Dependencies**: Claude Code plugin system, Git (for distribution), CommonMark/GFM markdown
**Storage**: File-based (markdown files in agents/ and skills/, JSON manifests in .claude-plugin/)
**Testing**: Local development marketplace with install/uninstall cycle validation
**Target Platform**: Windows 11 (primary), cross-platform Claude Code support (secondary)
**Project Type**: Plugin (static content distribution - no runtime code execution)
**Performance Goals**: <2 minute installation, <5 second agent response time, zero plugin load errors
**Constraints**: Must comply with all 5 constitution principles, 6-month Claude Code version compatibility, markdown-only format for content
**Scale/Scope**: 7 agents (4 primary + 3 meta), 2 skills (README templates), 1 marketplace catalog, comprehensive documentation

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Principle I: Plugin-First Architecture

- ✅ **PASS**: Plugin manifest (`.claude-plugin/plugin.json`) with all required fields (FR-001)
- ✅ **PASS**: Marketplace catalog (`.claude-plugin/marketplace.json`) for distribution (FR-002)
- ✅ **PASS**: Component directories at plugin root: `agents/`, `skills/` (FR-004, FR-008)
- ✅ **PASS**: Kebab-case naming convention: `claude-dotnet-plugin` (FR-013)
- ✅ **PASS**: Semantic versioning 1.0.0 for initial release (FR-012)

### Principle II: Component Independence & Testing

- ✅ **PASS**: All agents converted to markdown with YAML frontmatter (FR-003, FR-005)
- ✅ **PASS**: Agent descriptions include 2-3 usage examples (FR-015)
- ✅ **PASS**: Skills use proper YAML frontmatter with trigger specifications (FR-008, FR-009)
- ✅ **PASS**: Local testing marketplace workflow for validation (FR-016)
- ✅ **PASS**: "dotnet-" namespace prefix for conflict prevention (FR-005)

### Principle III: Marketplace-Ready Distribution

- ✅ **PASS**: GitHub repository distribution configured (FR-019)
- ✅ **PASS**: Marketplace.json with proper owner and plugin metadata (FR-002)
- ✅ **PASS**: Single plugin distribution pattern (source: ".") (FR-002)
- ✅ **PASS**: Installation via `/plugin marketplace add` command (FR-016)

### Principle IV: Documentation & Discoverability Standards

- ✅ **PASS**: Root README.md with purpose, features, installation, usage (FR-010)
- ✅ **PASS**: CHANGELOG.md documenting version 1.0.0 release (FR-011)
- ✅ **PASS**: CommonMark specification compliance for all markdown (FR-014)
- ✅ **PASS**: MIT license file included (FR-018)
- ✅ **PASS**: Agent descriptions with specific trigger terms for discoverability (FR-015)

### Principle V: Semantic Versioning & Release Management

- ✅ **PASS**: Version 1.0.0 synchronized across plugin.json and marketplace.json (FR-012)
- ✅ **PASS**: CHANGELOG.md documents initial release features (FR-011)
- ✅ **PASS**: Version format follows MAJOR.MINOR.PATCH pattern (FR-012)

### Quality Standards Gates

- ✅ **PASS**: JSON validation for all manifest files (FR-001, FR-002)
- ✅ **PASS**: File structure validation with proper directory organization (FR-004, FR-008)
- ✅ **PASS**: Component validation for agent/skill frontmatter (FR-005, FR-009)
- ✅ **PASS**: Security review for credential sanitization (FR-006, FR-023)

### Development Workflow Gates

- ✅ **PASS**: Initial setup creates proper directory structure
- ✅ **PASS**: Component development follows constitution standards
- ✅ **PASS**: Local testing workflow validates all components
- ✅ **PASS**: Pre-publication checklist ensures quality gates

**Constitution Compliance: 100% PASS - No violations requiring justification**

## Project Structure

### Documentation (this feature)

```text
specs/001-installable-plugin/
├── plan.md              # This file
├── spec.md              # Feature specification
├── research.md          # Phase 0: Technical research findings
├── data-model.md        # Phase 1: Plugin structure and entity model
├── quickstart.md        # Phase 1: Quick start guide for plugin development
├── contracts/           # Phase 1: JSON manifest schemas and examples
│   ├── plugin-manifest-schema.md
│   └── marketplace-schema.md
└── checklists/          # Validation checklists
    └── requirements.md
```

### Plugin Structure (repository root)

```text
claude-dotnet-plugin/                      # Plugin repository root
├── .claude-plugin/                        # Plugin metadata
│   ├── plugin.json                       # Plugin manifest
│   └── marketplace.json                   # Marketplace catalog
│
├── agents/                                # Agent definitions (7 total)
│   ├── dotnet-csharp-expert.md           # Modern .NET/C# development agent
│   ├── dotnet-git-manager.md             # Git workflow management agent
│   ├── dotnet-azure-architect.md         # Azure architecture agent
│   ├── dotnet-azure-devops.md            # Azure DevOps pipeline agent
│   ├── dotnet-agent-expert.md            # Meta: Agent creation specialist
│   ├── dotnet-feature-prompt.md          # Meta: Feature specification expert
│   ├── dotnet-readme-maintainer.md       # Meta: README maintenance agent
│   └── dotnet-mcp-expert.md              # Meta: MCP integration specialist
│
├── skills/                                # Skill definitions (2 total)
│   ├── readme-library-template/          # Library README skill
│   │   └── SKILL.md
│   └── readme-script-template/           # Script project README skill
│       └── SKILL.md
│
├── migrate/                               # Source content (to be converted)
│   ├── agents/                           # Original JSON agent definitions
│   └── templates/                        # Original template files
│
├── docs/                                  # Documentation
│   └── research/                         # Research artifacts
│       └── claude-code-plugin-developer-guide.md
│
├── .specify/                              # Specification framework
│   ├── memory/                           # Project governance
│   │   └── constitution.md
│   ├── templates/                        # Templates
│   └── scripts/                          # Automation scripts
│
├── README.md                              # Main documentation
├── CHANGELOG.md                           # Version history
├── LICENSE                                # MIT license
└── .gitignore                            # Git ignore rules
```

**Structure Decision**: Plugin structure follows constitution's "Single Plugin" distribution pattern with components at root. The migrate directory preserves original content for reference and conversion tracking. All agent files use "dotnet-" namespace prefix per FR-005 to prevent naming conflicts. Skills are organized in skill-name/SKILL.md format per constitution requirements.

## Complexity Tracking

> **No violations to justify - 100% constitution compliance**

This plugin implementation requires no deviation from constitutional principles. All requirements align with established patterns:
- Standard plugin structure with manifests at `.claude-plugin/`
- Component directories (`agents/`, `skills/`) at plugin root
- Markdown format for all content with YAML frontmatter
- JSON manifests for metadata and configuration
- File-based distribution through Git/GitHub
- Local marketplace testing workflow
- Security review for content sanitization

No complexity justification needed.
