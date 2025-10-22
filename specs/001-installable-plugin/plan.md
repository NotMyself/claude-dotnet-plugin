# Implementation Plan: Claude .NET Plugin

**Branch**: `001-installable-plugin` | **Date**: 2025-10-22 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-installable-plugin/spec.md`

## Summary

Transform the existing migrate directory contents (agents and templates) into a production-ready, installable Claude Code plugin following constitutional best practices. The plugin will provide .NET 9/C# 13 development expertise, Azure/DevOps guidance, Git workflow management, and project documentation templates through Claude Code's agent and skill system. Primary technical approach involves converting JSON agent specifications to markdown with YAML frontmatter, creating proper plugin manifests, implementing security sanitization, and establishing marketplace distribution infrastructure.

## Technical Context

**Language/Version**: Markdown (agents/skills), JSON (manifests), PowerShell 7+ (testing scripts)
**Primary Dependencies**: Claude Code plugin system, Git (for distribution), CommonMark/GFM markdown, Pester (testing framework)
**Storage**: File-based (markdown files in agents/ and skills/, JSON manifests in .claude-plugin/, settings in .claude/)
**Testing**: Local development marketplace with install/uninstall cycle validation, automated Pester test suite, manual functional testing
**Target Platform**: Windows 11 (primary), cross-platform Claude Code support (secondary)
**Project Type**: Plugin (static content distribution - no runtime code execution)
**Performance Goals**: <2 minute installation, <5 second agent response time, zero plugin load errors
**Constraints**: Must comply with all 5 constitution principles, 6-month Claude Code version compatibility, markdown-only format for content
**Scale/Scope**: 7 agents (4 primary + 3 meta), 2 skills (README templates), 1 marketplace catalog, comprehensive documentation, automated test suite

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
├── .claude/                               # Plugin settings
│   └── settings.json                     # Permission grants for tools
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
├── tests/                                 # Automated test suite (Pester)
│   ├── Invoke-PluginTests.ps1            # Test runner
│   ├── Manifest.Tests.ps1                # Manifest validation tests
│   ├── Settings.Tests.ps1                # Settings validation tests
│   ├── Agent.Tests.ps1                   # Agent validation tests
│   ├── Skill.Tests.ps1                   # Skill validation tests
│   └── Structure.Tests.ps1               # Directory structure tests
│
├── migrate/                               # Source content (deleted after conversion per FR-025)
│   ├── agents/                           # Original JSON agent definitions
│   └── templates/                        # Original template files
│
├── docs/                                  # Documentation
│   └── research/                         # Research artifacts
│       └── claude-code-plugin-developer-guide.md
│
├── .specify/                              # Specification framework (excluded from distribution per FR-026)
│   ├── memory/                           # Project governance
│   │   └── constitution.md
│   ├── templates/                        # Templates
│   └── scripts/                          # Automation scripts
│
├── README.md                              # Main documentation
├── CHANGELOG.md                           # Version history
├── EXAMPLES.md                            # Agent interaction examples (FR-031)
├── LICENSE                                # MIT license
├── CLAUDE.md                              # Development guidelines (excluded from distribution per FR-026)
└── .gitignore                            # Git ignore rules
```

**Structure Decision**: Plugin structure follows constitution's "Single Plugin" distribution pattern with components at root. The migrate directory contains source content for conversion and will be deleted after successful conversion per FR-025. All agent files use "dotnet-" namespace prefix per FR-005 to prevent naming conflicts. Skills are organized in skill-name/SKILL.md format per constitution requirements.

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

---

## Testing Strategy

**Approach**: Comprehensive automated testing with Pester framework plus manual functional validation per FR-027 through FR-030.

### Automated Testing (Phase 8)

**Framework**: Pester (PowerShell testing framework)
**Coverage Target**: 100% validation of plugin structure, manifests, agents, skills, and settings
**Test Suites**: 37 automated test tasks organized by validation domain

#### Test Categories

1. **Manifest Validation** (7 tests)
   - plugin.json: Valid JSON, required fields, SemVer version, kebab-case name
   - marketplace.json: Valid JSON, required fields, version synchronization

2. **Settings Validation** (4 tests - FR-029)
   - settings.json: Valid JSON, permissions structure
   - Required tools present: pwsh, git, dotnet, az, docker
   - Appropriate ask permissions for destructive operations

3. **Agent Validation** (7 tests - FR-028)
   - All agents exist and have valid YAML frontmatter
   - Required frontmatter fields present (name, description, color)
   - All agent names use "dotnet-" namespace prefix
   - Descriptions include 2-3 usage examples
   - No credential patterns (API keys, passwords, tokens)
   - CommonMark specification compliance

4. **Skill Validation** (4 tests)
   - All skill directories and SKILL.md files exist
   - Valid YAML frontmatter with allowed-tools specified

5. **Structure Validation** (4 tests)
   - Required directories exist (.claude-plugin, .claude, agents, skills)
   - Required files exist (README.md, CHANGELOG.md, LICENSE)
   - .gitignore excludes CLAUDE.md and .specify/ per FR-026

**Success Criteria**: All tests pass with zero failures before 1.0.0 release per SC-010.

### Manual Functional Testing (Phase 10)

**Scope**: End-to-end validation per FR-030

1. **Installation Workflow**: Fresh Claude Code instance installation test
2. **Agent Activation**: Verify all 7 agents activate on appropriate questions
3. **Skill Triggers**: Verify both skills trigger on expected scenarios
4. **Settings Configuration**: Verify permissions properly applied
5. **Documentation Accuracy**: Validate README, CHANGELOG, EXAMPLES completeness
6. **Error Handling**: Verify no installation errors or warnings

---

## Clarification Session Outcomes

The following requirements were added during the clarification session and are fully integrated into the implementation plan:

### Settings Configuration (FR-024)

**Decision**: Include `.claude/settings.json` with pre-configured permissions for .NET development tools
**Rationale**: Provides automatic permission grants for plugin functionality (PowerShell, Git, .NET CLI, Azure CLI, Docker)
**Tasks**: T011 (copy settings), T014-T015 (validation), T121-T124 (automated tests)

### Source Artifact Cleanup (FR-025)

**Decision**: Delete `migrate/` directory after successful conversion
**Rationale**: Clean distribution package, no source artifacts in final plugin
**Tasks**: T188-T191 (verify conversions), T194 (commit deletion)

### Distribution Exclusions (FR-026)

**Decision**: Exclude `CLAUDE.md` and `.specify/` from distributed plugin package
**Rationale**: Development-time artifacts not needed by end users
**Tasks**: T027-T028 (.gitignore configuration), T139 (test validation), T192-T193 (verify exclusion)

### Example Documentation (FR-031)

**Decision**: Create separate `EXAMPLES.md` file with agent interaction samples
**Rationale**: Improve user onboarding with concrete usage examples for each agent
**Tasks**: T158-T165 (create examples file with samples for all 7 agents)

---

## Platform Dependencies

The following requirements are **Claude Code platform responsibilities** rather than plugin implementation tasks:

### FR-021: Installation Error Messages

**Requirement**: "Plugin installation process MUST display clear error messages when prerequisites are missing..."
**Ownership**: Claude Code plugin system handles installation error detection and messaging
**Plugin Responsibility**: Document installation requirements in README.md (covered by T023)

### FR-022: Version Compatibility Warnings

**Requirement**: "Plugin MUST detect Claude Code version during installation and display compatibility warning..."
**Ownership**: Claude Code plugin system performs version detection and compatibility checks
**Plugin Responsibility**: Document supported versions in README.md (covered by T023)

**Note**: Plugins are passive content packages; runtime installation logic resides in the Claude Code platform.
