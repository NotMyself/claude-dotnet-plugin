---
name: README Script Template
description: Generate README.md for script/automation projects. ONLY trigger when user explicitly mentions script/automation context such as "script", "automation", "PowerShell module", "Bash script", "Python script", or "CLI tool". Also triggers when README.md is missing AND project structure indicates scripts (multiple *.ps1, *.sh, or *.py files, presence of *.psm1/*.psd1 module files). DO NOT trigger on generic "create README" without script/automation context.
allowed-tools:
  - Write
  - Read
  - Glob
---

# Script Project README Template Skill

Generates comprehensive README.md files for script projects with standard sections and best practices formatting.

## Trigger Scenarios

### Explicit Requests
- "create README for script"
- "generate documentation for this script project"
- "add README to scripts"
- "I need documentation for my PowerShell module"
- "create README for automation scripts"

### Missing README Detection
- User in project root directory
- No README.md file present
- Project structure indicates scripts:
  - Multiple `*.ps1` files (PowerShell)
  - Multiple `*.sh` files (Bash)
  - Multiple `*.py` files with executable permissions
  - Presence of script-specific files (`*.psm1`, `*.psd1`)

### Project Initialization
- User creates new script project
- User initializes git repository in script directory
- User discusses script documentation needs
- User mentions "script", "automation", or "module" in context

## Implementation

When triggered, generate README.md with these sections:

### 1. Title and Badges
```markdown
[appropriate badges for build status, version, license]

# Project Name

> One paragraph statement about the script's purpose.

Additional description about the script's features and automation capabilities.
```

### 2. Built With
```markdown
## Built With

- PowerShell 7+ / Bash / Python 3.x
- Major modules or dependencies
- Platform requirements
```

### 3. Getting Started

```markdown
## Getting Started

### Prerequisites

- PowerShell 7+ (for .ps1 scripts)
- Bash 4+ (for .sh scripts)
- Python 3.8+ (for .py scripts)
- Any additional requirements

### Installation

#### From Source
\`\`\`bash
git clone https://github.com/user/repo.git
cd repo
\`\`\`

#### Module Installation (PowerShell)
\`\`\`powershell
Install-Module -Name {ModuleName}
\`\`\`

### Usage

\`\`\`bash
# PowerShell
.\script-name.ps1 -Parameter1 "value" -Parameter2 "value"

# Bash
./script-name.sh --param1=value --param2=value

# Python
python script-name.py --param1 value --param2 value
\`\`\`
```

### 4. Parameters and Arguments
```markdown
## Parameters

### Required Parameters

- `-Parameter1` / `--param1`: Description of required parameter
- `-Parameter2` / `--param2`: Description of required parameter

### Optional Parameters

- `-Verbose` / `--verbose`: Enable verbose output
- `-WhatIf` / `--dry-run`: Show what would happen without executing

### Examples

\`\`\`powershell
# Example 1: Basic usage
.\script.ps1 -Param1 "value"

# Example 2: With optional parameters
.\script.ps1 -Param1 "value" -Verbose

# Example 3: Advanced usage
.\script.ps1 -Param1 "value" -Param2 "value" -WhatIf
\`\`\`
```

### 5. Configuration
```markdown
## Configuration

### Environment Variables

- `ENV_VAR_NAME`: Description of environment variable
- `ANOTHER_VAR`: Description

### Configuration Files

Create a configuration file at `./config.json`:

\`\`\`json
{
  "setting1": "value1",
  "setting2": "value2"
}
\`\`\`
```

### 6. Testing
```markdown
## Testing

### Run Tests

\`\`\`bash
# PowerShell (Pester)
Invoke-Pester

# Python (pytest)
pytest tests/

# Bash (bats)
bats tests/
\`\`\`
```

### 7. Contributing and License
```markdown
## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

1. Fork the project
2. Create your feature branch (\`git checkout -b feature/AmazingFeature\`)
3. Commit your changes (\`git commit -m 'feat: add amazing feature'\`)
4. Push to the branch (\`git push origin feature/AmazingFeature\`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
```

## Customization Prompts

After generating the template, ask the user:

1. "What is the main purpose of your script?"
2. "What parameters or arguments does it accept?"
3. "Are there any environment variables or configuration files?"
4. "What are the system requirements?"
5. "Would you like to add troubleshooting or FAQ sections?"

## File Detection Logic

To determine if project contains scripts:

1. Check for multiple `*.ps1` files (PowerShell scripts)
2. Check for multiple `*.sh` files (Bash scripts)
3. Check for multiple `*.py` files with `#!/usr/bin/env python`
4. Look for module manifests (`*.psd1`, `*.psm1`)
5. Check for script-specific directories (`scripts/`, `bin/`)
6. Look for test directories with script tests

## Example Output

```markdown
![Build Status](https://img.shields.io/github/actions/workflow/status/user/repo/test.yml)
![PowerShell Gallery](https://img.shields.io/powershellgallery/v/ModuleName)
![License](https://img.shields.io/github/license/user/repo)

# Azure Resource Deployer

> Automated Azure resource deployment and configuration script.

This PowerShell module provides a comprehensive set of scripts for deploying and managing Azure resources with infrastructure as code principles.

## Built With

- PowerShell 7+
- Azure CLI
- Azure PowerShell Modules

## Getting Started

### Prerequisites

- PowerShell 7 or higher
- Azure CLI installed
- Azure subscription with appropriate permissions

### Installation

#### PowerShell Gallery
\`\`\`powershell
Install-Module -Name AzureResourceDeployer
\`\`\`

#### From Source
\`\`\`bash
git clone https://github.com/user/azure-deployer.git
cd azure-deployer
\`\`\`

### Usage

\`\`\`powershell
# Deploy resources
.\Deploy-AzureResources.ps1 -ResourceGroup "rg-production" -Location "eastus"

# With custom configuration
.\Deploy-AzureResources.ps1 -ResourceGroup "rg-production" -ConfigFile "./config.json"
\`\`\`

## Parameters

### Required Parameters

- `-ResourceGroup`: Name of the Azure resource group
- `-Location`: Azure region for deployment

### Optional Parameters

- `-ConfigFile`: Path to configuration file (default: ./config.json)
- `-WhatIf`: Preview changes without deploying
- `-Verbose`: Enable detailed logging

### Examples

\`\`\`powershell
# Example 1: Basic deployment
.\Deploy-AzureResources.ps1 -ResourceGroup "rg-app" -Location "eastus"

# Example 2: Preview mode
.\Deploy-AzureResources.ps1 -ResourceGroup "rg-app" -Location "eastus" -WhatIf

# Example 3: Custom configuration
.\Deploy-AzureResources.ps1 -ResourceGroup "rg-app" -ConfigFile ".\prod-config.json"
\`\`\`

## Configuration

### Environment Variables

- `AZURE_SUBSCRIPTION_ID`: Target Azure subscription
- `AZURE_TENANT_ID`: Azure AD tenant ID

### Configuration File

Create `config.json` in the script directory:

\`\`\`json
{
  "resourcePrefix": "app",
  "environment": "prod",
  "enableMonitoring": true
}
\`\`\`

## Testing

\`\`\`powershell
# Run Pester tests
Invoke-Pester

# Run specific test
Invoke-Pester -Path .\tests\Deploy-AzureResources.Tests.ps1
\`\`\`

## 🤝 Contributing

Contributions welcome! Please read CONTRIBUTING.md for details.

## 📝 License

MIT License - see [LICENSE](LICENSE) for details.
```
