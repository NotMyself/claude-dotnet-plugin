BeforeAll {
    $ProjectRoot = Split-Path -Parent $PSScriptRoot
    $SkillsPath = Join-Path $ProjectRoot 'skills'

    if (-not (Test-Path $SkillsPath)) {
        throw "Skills directory not found at: $SkillsPath"
    }

    $script:SkillFiles = Get-ChildItem -Path $SkillsPath -Filter '*.md'

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
            $isArray = $false

            $yamlContent -split '\r?\n' | ForEach-Object {
                $line = $_

                # New key:value pair
                if ($line -match '^(\w[\w-]*):\s*(.*)$') {
                    # Save previous multi-line/array value if exists
                    if ($currentKey) {
                        if ($isArray) {
                            # Already saved as array items
                        } elseif ($multilineValue.Count -gt 0) {
                            $frontmatter[$currentKey] = ($multilineValue -join ' ').Trim()
                        }
                        $multilineValue = @()
                    }

                    $key = $matches[1]
                    $value = $matches[2].Trim()

                    if ($value -eq '>' -or $value -eq '') {
                        # Multi-line value or array starting
                        $currentKey = $key
                        $multilineValue = @()
                        $frontmatter[$key] = @()  # Initialize as array for now
                        $isArray = $false
                    } else {
                        # Simple value
                        $frontmatter[$key] = $value
                        $currentKey = $null
                        $isArray = $false
                    }
                }
                # Array item
                elseif ($line -match '^\s+-\s+(.+)$' -and $currentKey) {
                    $frontmatter[$currentKey] += $matches[1].Trim()
                    $isArray = $true
                }
                # Continuation of multi-line value (indented line, not array)
                elseif ($line -match '^\s+(.+)$' -and $currentKey -and -not $isArray) {
                    $multilineValue += $matches[1].Trim()
                }
            }

            # Save last multi-line value if exists
            if ($currentKey -and -not $isArray -and $multilineValue.Count -gt 0) {
                $frontmatter[$currentKey] = ($multilineValue -join ' ').Trim()
            }

            return $frontmatter
        }

        return $null
    }

    $script:GetYamlFrontmatter = ${function:Get-YamlFrontmatter}
}

Describe 'Skill Files Structure' {
    Context 'Expected Skill Files' {
        It 'Should have exactly 2 skill files' {
            $script:SkillFiles.Count | Should -Be 2
        }

        It 'Should have readme-library-template.md' {
            $script:SkillFiles.Name | Should -Contain 'readme-library-template.md'
        }

        It 'Should have readme-script-template.md' {
            $script:SkillFiles.Name | Should -Contain 'readme-script-template.md'
        }
    }

    Context 'Flat File Structure' {
        It 'Should not have subdirectories' {
            $subdirs = Get-ChildItem -Path $SkillsPath -Directory
            $subdirs.Count | Should -Be 0
        }

        It 'Skills should be .md files directly in skills/ directory' {
            $script:SkillFiles | ForEach-Object {
                $_.DirectoryName | Should -Be $SkillsPath
            }
        }
    }
}

Describe 'Skill Frontmatter Validation' -ForEach @(
    @{ File = 'readme-library-template.md'; ExpectedName = 'README Library Template' }
    @{ File = 'readme-script-template.md'; ExpectedName = 'README Script Template' }
) {
    BeforeAll {
        $ProjectRoot = Split-Path -Parent $PSScriptRoot
        $SkillPath = Join-Path $ProjectRoot "skills\$($_.File)"
        $script:Frontmatter = & $script:GetYamlFrontmatter -FilePath $SkillPath
        $script:SkillContent = Get-Content $SkillPath -Raw
    }

    Context "Skill: $($_.File)" {
        It 'Should have YAML frontmatter' {
            $script:Frontmatter | Should -Not -BeNullOrEmpty
        }

        It 'Should have name field in frontmatter' {
            $script:Frontmatter.name | Should -Not -BeNullOrEmpty
        }

        It 'Should have description field in frontmatter' {
            $script:Frontmatter.description | Should -Not -BeNullOrEmpty
        }

        It 'Should have allowed-tools field in frontmatter' {
            $script:Frontmatter.'allowed-tools' | Should -Not -BeNullOrEmpty
        }

        It "Name should be '$($_.ExpectedName)'" {
            $script:Frontmatter.name | Should -Be $_.ExpectedName
        }

        It 'allowed-tools should be an array or have multiple tools' {
            # PowerShell may parse as single string or array
            $tools = $script:Frontmatter.'allowed-tools'
            if ($tools -is [string]) {
                $tools | Should -Not -BeNullOrEmpty
            } else {
                @($tools).Count | Should -BeGreaterThan 0
            }
        }

        It 'allowed-tools should include Write' {
            $script:Frontmatter.'allowed-tools' | Should -Contain 'Write'
        }

        It 'allowed-tools should include Read' {
            $script:Frontmatter.'allowed-tools' | Should -Contain 'Read'
        }

        It 'allowed-tools should include Glob' {
            $script:Frontmatter.'allowed-tools' | Should -Contain 'Glob'
        }

        It 'Should have content after frontmatter' {
            $contentAfterFrontmatter = $script:SkillContent -replace '^---.*?---', ''
            $contentAfterFrontmatter.Trim() | Should -Not -BeNullOrEmpty
        }
    }
}

Describe 'Skill Trigger Specificity' {
    Context 'Library Template Triggers' {
        BeforeAll {
            $ProjectRoot = Split-Path -Parent $PSScriptRoot
            $LibrarySkillPath = Join-Path $ProjectRoot 'skills\readme-library-template.md'
            $script:Frontmatter = & $script:GetYamlFrontmatter -FilePath $LibrarySkillPath
        }

        It 'Description should mention ONLY trigger' {
            $script:Frontmatter.description | Should -Match 'ONLY trigger'
        }

        It 'Description should mention library context' {
            $script:Frontmatter.description | Should -Match 'library|package|NuGet'
        }

        It 'Description should prevent generic README triggers' {
            $script:Frontmatter.description | Should -Match 'DO NOT trigger on generic'
        }
    }

    Context 'Script Template Triggers' {
        BeforeAll {
            $ProjectRoot = Split-Path -Parent $PSScriptRoot
            $ScriptSkillPath = Join-Path $ProjectRoot 'skills\readme-script-template.md'
            $script:Frontmatter = & $script:GetYamlFrontmatter -FilePath $ScriptSkillPath
        }

        It 'Description should mention ONLY trigger' {
            $script:Frontmatter.description | Should -Match 'ONLY trigger'
        }

        It 'Description should mention script context' {
            $script:Frontmatter.description | Should -Match 'script|automation|PowerShell'
        }

        It 'Description should prevent generic README triggers' {
            $script:Frontmatter.description | Should -Match 'DO NOT trigger on generic'
        }
    }
}

Describe 'Skill Content Validation' -ForEach @(
    @{ File = 'readme-library-template.md'; MinLines = 200 }
    @{ File = 'readme-script-template.md'; MinLines = 250 }
) {
    BeforeAll {
        $ProjectRoot = Split-Path -Parent $PSScriptRoot
        $SkillPath = Join-Path $ProjectRoot "skills\$($_.File)"
        $script:LineCount = (Get-Content $SkillPath).Count
        $script:Content = Get-Content $SkillPath -Raw
    }

    Context "Skill: $($_.File)" {
        It "Should have at least $($_.MinLines) lines of content" {
            $script:LineCount | Should -BeGreaterOrEqual $_.MinLines
        }

        It 'Should have implementation instructions' {
            $script:Content | Should -Match 'Implementation|When triggered'
        }

        It 'Should have example output' {
            $script:Content | Should -Match 'Example|Output'
        }

        It 'Should not contain hardcoded credentials' {
            $script:Content | Should -Not -Match 'password\s*[:=]\s*[^{]'
            $script:Content | Should -Not -Match 'api[_-]?key\s*[:=]\s*[^{]'
        }
    }
}
