# Feature Specification: Claude .NET Plugin

**Feature Branch**: `001-installable-plugin`
**Created**: 2025-10-22
**Status**: Draft
**Input**: User description: "the migrate directory contains a set of agents and templates. I want to create an installable claude code plugin based on the contents following best practices."

## Clarifications

### Session 2025-10-22

- Q: How should the plugin handle installation failures (missing Git, network issues, corrupted files)? → A: Display clear error message explaining the issue and required prerequisites
- Q: What user phrases or contexts should trigger the README template skills to activate automatically? → A: Combined triggers - Explicit requests, missing README detection, and project initialization contexts
- Q: When an agent name conflicts with an existing Claude Code agent, what should happen? → A: Namespace prefix all agents - Prepend "dotnet-" to all agent names during installation, allow user override
- Q: What is the minimum Claude Code version required, and how should version compatibility be enforced? → A: Last 6 months - Support Claude Code versions released in last 6 months, show warning on older versions but allow installation
- Q: Should the agent content be reviewed for security concerns (credentials, API keys, sensitive patterns) before inclusion in the public plugin? → A: Audit and sanitize - Review all agents for credentials, API keys, or sensitive patterns; replace with placeholders or examples

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Plugin Installation and Discovery (Priority: P1)

A developer wants to install the .NET plugin to enhance their Claude Code environment with .NET-specific capabilities and workflows.

**Why this priority**: This is the foundation - without proper installation, users cannot access any plugin features. This delivers immediate value by making the plugin discoverable and installable.

**Independent Test**: Can be fully tested by installing the plugin via marketplace and verifying it appears in the plugins list without errors.

**Acceptance Scenarios**:

1. **Given** a user has Claude Code installed, **When** they add the plugin marketplace and install the .NET plugin, **Then** the plugin installs successfully and appears in their enabled plugins list
2. **Given** the plugin is installed, **When** the user runs `/help`, **Then** all plugin commands appear in the help output with descriptions
3. **Given** the plugin is installed, **When** the user checks plugin details, **Then** they see complete metadata (version, author, description, homepage)

---

### User Story 2 - .NET Development Agent Usage (Priority: P1)

A developer working on a .NET 9/C# 13 project wants Claude to provide expert guidance using modern .NET practices, patterns, and tooling.

**Why this priority**: The .NET development agent is the core value proposition - it provides specialized expertise that immediately improves developer productivity on .NET projects.

**Independent Test**: Can be fully tested by asking Claude .NET-specific questions and verifying the agent provides accurate, modern .NET 9/C# 13 guidance with proper code examples.

**Acceptance Scenarios**:

1. **Given** a user is working on a .NET project, **When** they ask about C# 13 features, **Then** Claude provides guidance using the .NET agent with modern patterns (primary constructors, collection expressions)
2. **Given** a user needs to create a new web API, **When** they request project setup, **Then** Claude uses the .NET agent to provide .NET 9 project creation commands with proper structure
3. **Given** a user encounters a build error, **When** they describe the issue, **Then** Claude uses the .NET agent's troubleshooting knowledge to diagnose and solve the problem

---

### User Story 3 - Azure and DevOps Agent Support (Priority: P2)

A developer working with Azure services and Azure DevOps wants specialized guidance for cloud architecture and pipeline configuration.

**Why this priority**: Azure/DevOps expertise extends the plugin's value for cloud-native development teams, complementing the core .NET development capabilities.

**Independent Test**: Can be fully tested by asking Azure-specific questions and verifying the appropriate specialized agent (Azure Architect or Azure DevOps Manager) provides relevant guidance.

**Acceptance Scenarios**:

1. **Given** a user is designing cloud architecture, **When** they ask about Azure service selection, **Then** Claude uses the Azure Architect agent to provide appropriate recommendations
2. **Given** a user needs to create a CI/CD pipeline, **When** they request pipeline configuration, **Then** Claude uses the Azure DevOps agent to provide YAML pipeline examples
3. **Given** a user is troubleshooting deployment issues, **When** they describe the problem, **Then** Claude uses the appropriate Azure agent to diagnose and resolve the issue

---

### User Story 4 - Git Workflow Management (Priority: P3)

A developer wants Git operation guidance that follows team conventions and handles common Git workflows efficiently.

**Why this priority**: Git management is valuable but less critical than core development capabilities - teams can function without specialized Git guidance.

**Independent Test**: Can be fully tested by requesting Git operations and verifying the Git Manager agent provides appropriate commands and workflow guidance.

**Acceptance Scenarios**:

1. **Given** a user needs to create a feature branch, **When** they request branch creation, **Then** Claude uses the Git Manager agent to provide proper Git commands
2. **Given** a user has merge conflicts, **When** they ask for help resolving conflicts, **Then** Claude provides conflict resolution strategies using Git best practices
3. **Given** a user needs to create a commit, **When** they request commit guidance, **Then** Claude provides conventional commit message format

---

### User Story 5 - Project Template Usage (Priority: P3)

A developer creating documentation wants to use standardized README templates that follow consistent structure and quality standards.

**Why this priority**: Documentation templates are helpful but not blocking - developers can create documentation without specialized templates.

**Independent Test**: Can be fully tested by requesting README generation and verifying the appropriate template is used with proper structure.

**Acceptance Scenarios**:

1. **Given** a user explicitly requests README generation, **When** they say "create README" or "generate documentation", **Then** Claude uses the appropriate template (library or script) based on project context
2. **Given** a user is in a project root directory without README.md, **When** they discuss project documentation needs, **Then** Claude automatically offers to generate a README using the appropriate template
3. **Given** a user is initializing a new project or repository, **When** the setup process begins, **Then** Claude proactively suggests README generation with the appropriate template
4. **Given** a user wants to customize the template, **When** they specify custom sections, **Then** Claude adapts the template to include requested content

---

### Edge Cases

- Installation failures (missing Git, network issues, corrupted files) MUST display clear error messages explaining the issue and listing required prerequisites
- Agent name conflicts with existing Claude Code agents MUST be prevented by prepending "dotnet-" namespace prefix to all agent names during installation, with user option to override prefix if needed
- Claude Code versions older than 6 months MUST trigger compatibility warning during installation but allow installation to proceed, with notice of potentially missing features
- Broken or unavailable marketplace.json references MUST result in clear error messages with troubleshooting guidance
- .NET-specific agent usage on non-.NET projects SHOULD provide graceful degradation with generic development guidance
- Agent content containing credentials, API keys, or sensitive patterns MUST be sanitized before distribution, replacing with placeholder values or safe examples

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Plugin MUST have valid `.claude-plugin/plugin.json` manifest with name, version (1.0.0), description, author, repository, and license fields
- **FR-002**: Plugin MUST include `.claude-plugin/marketplace.json` for distribution with proper owner and plugin entry metadata
- **FR-003**: Plugin MUST convert all existing agents (modern_dotnet_agent, git_manager_agent, azure_devops_manager_agent, azure_architect_agent) to Claude Code agent format (markdown with YAML frontmatter)
- **FR-004**: Plugin MUST place all agents in `agents/` directory at plugin root with descriptive filenames using kebab-case
- **FR-005**: Each agent MUST include `name`, `description` with usage examples, and `color` fields in YAML frontmatter, with "dotnet-" namespace prefix to prevent conflicts (e.g., "dotnet-csharp-expert")
- **FR-006**: Plugin MUST convert JSON agent specifications to markdown format preserving all domain knowledge, commands, patterns, and workflows, after security audit to remove or sanitize any credentials, API keys, or sensitive patterns (replacing with placeholders or example values)
- **FR-007**: Plugin MUST include meta agents (agent-expert, feature-prompt, readme-maintainer, mcp-expert) as specialized Claude Code agents
- **FR-008**: Plugin MUST place templates in `skills/` directory as Claude Code skills with proper YAML frontmatter
- **FR-009**: README templates MUST be converted to skills that trigger on: explicit requests ("create README", "generate documentation"), detection of missing README.md in project root, and project initialization contexts (new project creation, repository setup)
- **FR-010**: Plugin MUST include root `README.md` documenting purpose, features, installation instructions, and usage examples
- **FR-011**: Plugin MUST include `CHANGELOG.md` documenting version 1.0.0 as initial release with feature list
- **FR-012**: Plugin MUST follow semantic versioning (1.0.0 for initial release)
- **FR-013**: Plugin MUST use kebab-case naming convention: `claude-dotnet-plugin`
- **FR-014**: All markdown files MUST follow CommonMark specification with proper formatting
- **FR-015**: Agent descriptions MUST include 2-3 realistic usage examples in the format specified by constitution
- **FR-016**: Plugin MUST be installable via marketplace using `/plugin marketplace add` command
- **FR-017**: Plugin MUST work on Windows environments (primary target platform for .NET development)
- **FR-018**: Plugin MUST include MIT license file
- **FR-019**: Plugin repository MUST be configured for GitHub distribution
- **FR-020**: Agent frontmatter MUST specify `allowed-tools` restrictions for skills where appropriate
- **FR-021**: Plugin installation process MUST display clear error messages when prerequisites are missing (Git unavailable, network failures, file corruption) and list required actions to resolve
- **FR-022**: Plugin MUST detect Claude Code version during installation and display compatibility warning if version is older than 6 months, while still allowing installation to proceed
- **FR-023**: All agent content from migrate directory MUST undergo security review to identify and sanitize credentials, API keys, connection strings, or sensitive configuration patterns before public distribution

### Key Entities

- **Plugin Manifest**: Metadata file (`plugin.json`) defining plugin identity, version, author, and component locations
- **Marketplace Catalog**: Distribution configuration (`marketplace.json`) listing plugin availability and source location
- **Agent**: Specialized domain expert (markdown file) providing targeted guidance for specific technologies or workflows
- **Skill**: Autonomous capability (markdown in skill directory) that triggers automatically based on user context
- **Template**: Reusable document structure for standardizing project documentation
- **Component Directory**: Organizational structure (`agents/`, `skills/`) containing plugin functionality

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can install the plugin from marketplace in under 2 minutes with a single command sequence
- **SC-002**: All 7 agents (4 primary + 3 meta) load without errors and appear correctly in Claude Code
- **SC-003**: .NET developers receive specialized guidance within 5 seconds of asking .NET-specific questions
- **SC-004**: Plugin structure passes all constitution compliance checks (valid JSON, proper directory structure, correct frontmatter)
- **SC-005**: README documentation is comprehensive enough that 90% of users can install and use the plugin without external support
- **SC-006**: All agent descriptions trigger appropriate agent selection when users describe related tasks
- **SC-007**: Plugin installation does not interfere with other installed Claude Code plugins or agents
- **SC-008**: Plugin can be updated to version 1.1.0 following SemVer without breaking user workflows

## Assumptions

- Users have Claude Code installed and functional (versions from last 6 months recommended for full feature support)
- Users have Git available for cloning plugin repositories
- Target users are familiar with .NET development on Windows
- Users understand basic Claude Code plugin concepts
- Plugin will be distributed via public GitHub repository
- Users have appropriate permissions to install plugins in their Claude Code environment
- The existing agent JSON files contain accurate and current .NET 9/C# 13 information
- Claude Code supports the plugin architecture as defined in the constitution
