BeforeAll {
    $ProjectRoot = Split-Path -Parent $PSScriptRoot
    $AgentsPath = Join-Path $ProjectRoot 'agents'

    if (-not (Test-Path $AgentsPath)) {
        throw "Agents directory not found at: $AgentsPath"
    }

    $script:AgentFiles = Get-ChildItem -Path $AgentsPath -Filter '*.md'

    # Expected agents
    $script:ExpectedAgents = @(
        'dotnet-csharp-expert.md'
        'dotnet-azure-architect.md'
        'dotnet-azure-devops.md'
        'dotnet-git-manager.md'
        'dotnet-agent-expert.md'
        'dotnet-readme-maintainer.md'
        'dotnet-mcp-expert.md'
    )

    # Function to parse YAML frontmatter
    function Get-YamlFrontmatter {
        param([string]$FilePath)

        $content = Get-Content $FilePath -Raw
        if ($content -match '(?s)^---\r?\n(.*?)\r?\n---') {
            $yamlContent = $matches[1]

            # Parse YAML manually
            $frontmatter = @{}
            $currentKey = $null
            $multilineValue = @()

            $yamlContent -split '\r?\n' | ForEach-Object {
                $line = $_

                # New key:value pair
                if ($line -match '^(\w[\w-]*):\s*(.*)$') {
                    # Save previous multi-line value if exists
                    if ($currentKey -and $multilineValue.Count -gt 0) {
                        $frontmatter[$currentKey] = ($multilineValue -join ' ').Trim()
                        $multilineValue = @()
                    }

                    $key = $matches[1]
                    $value = $matches[2].Trim()

                    if ($value -eq '>' -or $value -eq '') {
                        # Multi-line value starting
                        $currentKey = $key
                        $multilineValue = @()
                    } else {
                        # Simple value
                        $frontmatter[$key] = $value
                        $currentKey = $null
                    }
                }
                # Continuation of multi-line value (indented line)
                elseif ($line -match '^\s+(.+)$' -and $currentKey) {
                    $multilineValue += $matches[1].Trim()
                }
            }

            # Save last multi-line value if exists
            if ($currentKey -and $multilineValue.Count -gt 0) {
                $frontmatter[$currentKey] = ($multilineValue -join ' ').Trim()
            }

            return $frontmatter
        }

        return $null
    }

    $script:GetYamlFrontmatter = ${function:Get-YamlFrontmatter}
}

Describe 'Agent Files Structure' {
    Context 'Expected Agent Files' {
        It 'Should have exactly 7 agent files' {
            $script:AgentFiles.Count | Should -Be 7
        }

        It 'Should have dotnet-csharp-expert.md' {
            $script:AgentFiles.Name | Should -Contain 'dotnet-csharp-expert.md'
        }

        It 'Should have dotnet-azure-architect.md' {
            $script:AgentFiles.Name | Should -Contain 'dotnet-azure-architect.md'
        }

        It 'Should have dotnet-azure-devops.md' {
            $script:AgentFiles.Name | Should -Contain 'dotnet-azure-devops.md'
        }

        It 'Should have dotnet-git-manager.md' {
            $script:AgentFiles.Name | Should -Contain 'dotnet-git-manager.md'
        }

        It 'Should have dotnet-agent-expert.md' {
            $script:AgentFiles.Name | Should -Contain 'dotnet-agent-expert.md'
        }

        It 'Should have dotnet-readme-maintainer.md' {
            $script:AgentFiles.Name | Should -Contain 'dotnet-readme-maintainer.md'
        }

        It 'Should have dotnet-mcp-expert.md' {
            $script:AgentFiles.Name | Should -Contain 'dotnet-mcp-expert.md'
        }
    }

    Context 'Namespace Prefix' {
        It 'All agents should start with dotnet- prefix' {
            $script:AgentFiles | ForEach-Object {
                $_.Name | Should -Match '^dotnet-'
            }
        }
    }
}

Describe 'Agent Frontmatter Validation' -ForEach @(
    @{ File = 'dotnet-csharp-expert.md' }
    @{ File = 'dotnet-azure-architect.md' }
    @{ File = 'dotnet-azure-devops.md' }
    @{ File = 'dotnet-git-manager.md' }
    @{ File = 'dotnet-agent-expert.md' }
    @{ File = 'dotnet-readme-maintainer.md' }
    @{ File = 'dotnet-mcp-expert.md' }
) {
    BeforeAll {
        $ProjectRoot = Split-Path -Parent $PSScriptRoot
        $AgentPath = Join-Path $ProjectRoot "agents\$($_.File)"
        $script:Frontmatter = & $script:GetYamlFrontmatter -FilePath $AgentPath
        $script:AgentContent = Get-Content $AgentPath -Raw
    }

    Context "Agent: $($_.File)" {
        It 'Should have YAML frontmatter' {
            $script:Frontmatter | Should -Not -BeNullOrEmpty
        }

        It 'Should have name field in frontmatter' {
            $script:Frontmatter.name | Should -Not -BeNullOrEmpty
        }

        It 'Should have description field in frontmatter' {
            $script:Frontmatter.description | Should -Not -BeNullOrEmpty
        }

        It 'Should have color field in frontmatter' {
            $script:Frontmatter.color | Should -Not -BeNullOrEmpty
        }

        It 'Name should match filename (without .md)' {
            $expectedName = $_.File -replace '\.md$', ''
            $script:Frontmatter.name | Should -Be $expectedName
        }

        It 'Color should be a valid color' {
            $validColors = @('blue', 'green', 'yellow', 'red', 'purple', 'orange', 'pink', 'cyan', 'gray')
            $validColors | Should -Contain $script:Frontmatter.color
        }

        It 'Description should contain usage examples' {
            # Description should be multiline with examples
            $script:AgentContent | Should -Match 'Examples?:'
        }

        It 'Should have content after frontmatter' {
            $contentAfterFrontmatter = $script:AgentContent -replace '^---.*?---', ''
            $contentAfterFrontmatter.Trim() | Should -Not -BeNullOrEmpty
        }

        It 'Should not contain security vulnerabilities' {
            $script:AgentContent | Should -Not -Match 'password\s*=\s*[^{]'
            $script:AgentContent | Should -Not -Match 'api[_-]?key\s*=\s*[^{]'
        }
    }
}

Describe 'Primary Agents Content Validation' -ForEach @(
    @{ File = 'dotnet-csharp-expert.md'; MinLines = 400 }
    @{ File = 'dotnet-azure-architect.md'; MinLines = 600 }
    @{ File = 'dotnet-azure-devops.md'; MinLines = 600 }
    @{ File = 'dotnet-git-manager.md'; MinLines = 700 }
) {
    BeforeAll {
        $ProjectRoot = Split-Path -Parent $PSScriptRoot
        $AgentPath = Join-Path $ProjectRoot "agents\$($_.File)"
        $script:LineCount = (Get-Content $AgentPath).Count
    }

    Context "Primary Agent: $($_.File)" {
        It "Should have at least $($_.MinLines) lines of content" {
            $script:LineCount | Should -BeGreaterOrEqual $_.MinLines
        }
    }
}

Describe 'Meta Agents Tools Validation' -ForEach @(
    @{ File = 'dotnet-readme-maintainer.md'; ShouldHaveTools = $true }
    @{ File = 'dotnet-agent-expert.md'; ShouldHaveTools = $false }
    @{ File = 'dotnet-mcp-expert.md'; ShouldHaveTools = $false }
) {
    BeforeAll {
        $ProjectRoot = Split-Path -Parent $PSScriptRoot
        $AgentPath = Join-Path $ProjectRoot "agents\$($_.File)"
        $script:Frontmatter = & $script:GetYamlFrontmatter -FilePath $AgentPath
    }

    Context "Meta Agent: $($_.File)" {
        It 'Should have valid tools field if present' {
            # Tools field is optional for meta agents, but if present should be valid
            if ($_.ShouldHaveTools) {
                # This agent should have tools
                $script:Frontmatter.ContainsKey('tools') | Should -Be $true
                $script:Frontmatter.tools | Should -Not -BeNullOrEmpty
            } else {
                # Tools field is optional, but if present should not be empty
                if ($script:Frontmatter.ContainsKey('tools')) {
                    $script:Frontmatter.tools | Should -Not -BeNullOrEmpty
                } else {
                    $true | Should -Be $true  # Pass if not present
                }
            }
        }
    }
}
