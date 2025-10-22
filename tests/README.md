# Claude .NET Plugin Test Suite

Comprehensive Pester tests for validating the Claude .NET Plugin structure, manifests, agents, skills, and configuration.

## Test Files

### Plugin.Tests.ps1
Validates the `.claude-plugin/plugin.json` manifest:
- Required fields (name, version, description, author, license, homepage, repository, keywords)
- Version format (SemVer)
- URL validation
- Author information
- JSON syntax

### Marketplace.Tests.ps1
Validates the `.claude-plugin/marketplace.json` manifest:
- Plugin array structure
- Required fields (name, source, version)
- Version synchronization with plugin.json
- JSON syntax

### Agents.Tests.ps1
Validates all agent files in `agents/`:
- Expected agent count (7 agents)
- Namespace prefix (dotnet-)
- YAML frontmatter structure
- Required frontmatter fields (name, description, color)
- Usage examples in descriptions
- Content length validation
- Security validation (no exposed credentials)
- Tools validation for meta agents

**Agents Tested:**
- dotnet-csharp-expert.md
- dotnet-azure-architect.md
- dotnet-azure-devops.md
- dotnet-git-manager.md
- dotnet-agent-expert.md
- dotnet-readme-maintainer.md
- dotnet-mcp-expert.md

### Skills.Tests.ps1
Validates all skill files in `skills/`:
- Expected skill count (2 skills)
- Flat file structure (no subdirectories)
- YAML frontmatter structure
- Required frontmatter fields (name, description, allowed-tools)
- Trigger specificity validation
- Content length validation
- Security validation

**Skills Tested:**
- readme-library-template.md
- readme-script-template.md

### Settings.Tests.ps1
Validates `.claude/settings.json`:
- JSON structure
- Permissions object structure
- Auto-approved permissions (allow array)
- Confirmation-required permissions (ask array)
- Security validation (no auto-approved destructive operations)
- Expected tool permissions (pwsh, git, gh, dotnet, az, docker, code, npm, wget, curl)

### Structure.Tests.ps1
Validates plugin directory structure and documentation:
- Required directories (.claude-plugin, .claude, agents, skills, tests, specs)
- Required files (manifests, README, CHANGELOG, LICENSE, EXAMPLES, CLAUDE.md)
- Documentation content validation
- Version consistency across manifests and CHANGELOG
- Specification files validation

## Running Tests

### Run All Tests

```powershell
.\Run-Tests.ps1
```

### Run Specific Test File

```powershell
Invoke-Pester -Path .\Plugin.Tests.ps1
```

### Run with NUnit XML Output

```powershell
.\Run-Tests.ps1 -OutputFormat NUnitXml
```

### Run with JUnit XML Output

```powershell
.\Run-Tests.ps1 -OutputFormat JUnitXml
```

## Prerequisites

- PowerShell 7+ (recommended)
- Pester 5.0 or higher

Install Pester if not already installed:

```powershell
Install-Module -Name Pester -Force -SkipPublisherCheck -Scope CurrentUser
```

## Test Coverage

The test suite validates:

- ✅ **Plugin Manifest**: Structure, required fields, version format, URLs
- ✅ **Marketplace Manifest**: Structure, version synchronization
- ✅ **Agent Files**: Count, naming, frontmatter, content, security
- ✅ **Skill Files**: Count, structure, frontmatter, triggers, content
- ✅ **Settings File**: Permissions configuration, security safeguards
- ✅ **Directory Structure**: Required directories and files
- ✅ **Documentation**: README, CHANGELOG, EXAMPLES, LICENSE content
- ✅ **Version Consistency**: Synchronized versions across all manifests

## Test Results

Expected test counts (as of v1.0.0):
- **Plugin.Tests.ps1**: ~25 tests
- **Marketplace.Tests.ps1**: ~10 tests
- **Agents.Tests.ps1**: ~80 tests (per-agent validation)
- **Skills.Tests.ps1**: ~35 tests
- **Settings.Tests.ps1**: ~25 tests
- **Structure.Tests.ps1**: ~40 tests

**Total**: ~215 tests

## CI/CD Integration

### Azure DevOps Pipeline

```yaml
- task: PowerShell@2
  displayName: 'Run Pester Tests'
  inputs:
    filePath: 'tests/Run-Tests.ps1'
    arguments: '-OutputFormat NUnitXml'
    pwsh: true

- task: PublishTestResults@2
  displayName: 'Publish Test Results'
  inputs:
    testResultsFormat: 'NUnit'
    testResultsFiles: '**/TestResults.nunitxml.xml'
    failTaskOnFailedTests: true
```

### GitHub Actions

```yaml
- name: Run Pester Tests
  shell: pwsh
  run: |
    ./tests/Run-Tests.ps1 -OutputFormat JUnitXml

- name: Publish Test Results
  uses: EnricoMi/publish-unit-test-result-action@v2
  if: always()
  with:
    files: tests/TestResults.junitxml.xml
```

## Troubleshooting

### Pester Version Issues

If you encounter errors related to Pester version:

```powershell
# Remove old Pester versions
Get-Module Pester -ListAvailable | Uninstall-Module -Force

# Install Pester 5.x
Install-Module -Name Pester -MinimumVersion 5.0 -Force -SkipPublisherCheck
```

### Test Failures

If tests fail:

1. Check the error message for specific validation failures
2. Verify all required files exist
3. Validate JSON syntax in manifests
4. Ensure all agents have proper YAML frontmatter
5. Check that version numbers are synchronized

### Path Issues

If tests can't find files:

- Ensure you're running from the `tests/` directory or using `Run-Tests.ps1`
- Verify the plugin directory structure is intact
- Check that no files were accidentally moved or deleted

## Contributing

When adding new agents or skills:

1. Update the expected counts in `Agents.Tests.ps1` or `Skills.Tests.ps1`
2. Add specific validation tests for new components
3. Run the full test suite before committing
4. Ensure all tests pass

## License

MIT License - see [LICENSE](../LICENSE) for details
