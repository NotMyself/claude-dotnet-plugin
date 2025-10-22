BeforeAll {
    $ProjectRoot = Split-Path -Parent $PSScriptRoot
}

Describe 'Plugin Directory Structure' {
    Context 'Required Directories' {
        It 'Should have .claude-plugin directory' {
            Test-Path (Join-Path $ProjectRoot '.claude-plugin') | Should -Be $true
        }

        It 'Should have .claude directory' {
            Test-Path (Join-Path $ProjectRoot '.claude') | Should -Be $true
        }

        It 'Should have agents directory' {
            Test-Path (Join-Path $ProjectRoot 'agents') | Should -Be $true
        }

        It 'Should have skills directory' {
            Test-Path (Join-Path $ProjectRoot 'skills') | Should -Be $true
        }

        It 'Should have tests directory' {
            Test-Path (Join-Path $ProjectRoot 'tests') | Should -Be $true
        }

        It 'Should have specs directory' {
            Test-Path (Join-Path $ProjectRoot 'specs') | Should -Be $true
        }
    }

    Context 'Required Files' {
        It 'Should have plugin.json manifest' {
            Test-Path (Join-Path $ProjectRoot '.claude-plugin\plugin.json') | Should -Be $true
        }

        It 'Should have marketplace.json manifest' {
            Test-Path (Join-Path $ProjectRoot '.claude-plugin\marketplace.json') | Should -Be $true
        }

        It 'Should have settings.json' {
            Test-Path (Join-Path $ProjectRoot '.claude\settings.json') | Should -Be $true
        }

        It 'Should have README.md' {
            Test-Path (Join-Path $ProjectRoot 'README.md') | Should -Be $true
        }

        It 'Should have CHANGELOG.md' {
            Test-Path (Join-Path $ProjectRoot 'CHANGELOG.md') | Should -Be $true
        }

        It 'Should have LICENSE' {
            Test-Path (Join-Path $ProjectRoot 'LICENSE') | Should -Be $true
        }

        It 'Should have EXAMPLES.md' {
            Test-Path (Join-Path $ProjectRoot 'EXAMPLES.md') | Should -Be $true
        }

        It 'Should have CLAUDE.md' {
            Test-Path (Join-Path $ProjectRoot 'CLAUDE.md') | Should -Be $true
        }

        It 'Should have .gitignore' {
            Test-Path (Join-Path $ProjectRoot '.gitignore') | Should -Be $true
        }
    }

    Context 'Prohibited Directories' {
        It 'Should not have skills subdirectories (flat structure)' {
            $subdirs = Get-ChildItem -Path (Join-Path $ProjectRoot 'skills') -Directory -ErrorAction SilentlyContinue
            $subdirs.Count | Should -Be 0
        }
    }
}

Describe 'Documentation Files Validation' {
    Context 'README.md' {
        BeforeAll {
            $ReadmePath = Join-Path $ProjectRoot 'README.md'
            $script:ReadmeContent = Get-Content $ReadmePath -Raw
        }

        It 'Should have Installation section' {
            $script:ReadmeContent | Should -Match '## Installation'
        }

        It 'Should have Settings section' {
            $script:ReadmeContent | Should -Match '## Settings'
        }

        It 'Should have Usage section' {
            $script:ReadmeContent | Should -Match '## Usage'
        }

        It 'Should have Agents section' {
            $script:ReadmeContent | Should -Match '## Agents'
        }

        It 'Should have License section' {
            $script:ReadmeContent | Should -Match '## License'
        }

        It 'Should mention all 4 primary agents' {
            $script:ReadmeContent | Should -Match 'dotnet-csharp-expert'
            $script:ReadmeContent | Should -Match 'dotnet-azure-architect'
            $script:ReadmeContent | Should -Match 'dotnet-azure-devops'
            $script:ReadmeContent | Should -Match 'dotnet-git-manager'
        }

        It 'Should mention 3 meta agents' {
            $script:ReadmeContent | Should -Match '3 Meta Agents'
        }

        It 'Should have installation instructions' {
            $script:ReadmeContent | Should -Match '/plugin marketplace add'
            $script:ReadmeContent | Should -Match 'NotMyself/claude-dotnet-plugin'
        }

        It 'Should have permissions documentation' {
            $script:ReadmeContent | Should -Match 'Auto-Approved Operations'
            $script:ReadmeContent | Should -Match 'Confirmation Required'
        }
    }

    Context 'CHANGELOG.md' {
        BeforeAll {
            $ChangelogPath = Join-Path $ProjectRoot 'CHANGELOG.md'
            $script:ChangelogContent = Get-Content $ChangelogPath -Raw
        }

        It 'Should follow Keep a Changelog format' {
            $script:ChangelogContent | Should -Match '## \[1\.0\.0\]'
        }

        It 'Should have version 1.0.0' {
            $script:ChangelogContent | Should -Match '\[1\.0\.0\]'
        }

        It 'Should have Added section' {
            $script:ChangelogContent | Should -Match '### Added'
        }

        It 'Should have Security section' {
            $script:ChangelogContent | Should -Match '### Security'
        }

        It 'Should mention 3 meta agents' {
            $script:ChangelogContent | Should -Match '\*\*Meta Agents\*\* \(3\)'
        }

        It 'Should have release link' {
            $script:ChangelogContent | Should -Match 'https://github.com/NotMyself/claude-dotnet-plugin/releases/tag/v1.0.0'
        }
    }

    Context 'EXAMPLES.md' {
        BeforeAll {
            $ExamplesPath = Join-Path $ProjectRoot 'EXAMPLES.md'
            $script:ExamplesContent = Get-Content $ExamplesPath -Raw
            $script:ExamplesLines = (Get-Content $ExamplesPath).Count
        }

        It 'Should have substantial content (>1000 lines)' {
            $script:ExamplesLines | Should -BeGreaterThan 1000
        }

        It 'Should have examples for all primary agents' {
            $script:ExamplesContent | Should -Match 'dotnet-csharp-expert'
            $script:ExamplesContent | Should -Match 'dotnet-azure-architect'
            $script:ExamplesContent | Should -Match 'dotnet-azure-devops'
            $script:ExamplesContent | Should -Match 'dotnet-git-manager'
        }

        It 'Should have examples for all meta agents' {
            $script:ExamplesContent | Should -Match 'dotnet-agent-expert'
            $script:ExamplesContent | Should -Match 'dotnet-readme-maintainer'
            $script:ExamplesContent | Should -Match 'dotnet-mcp-expert'
        }

        It 'Should have examples for all skills' {
            $script:ExamplesContent | Should -Match 'README Library Template'
            $script:ExamplesContent | Should -Match 'README Script Template'
        }

        It 'Should have code examples' {
            $script:ExamplesContent | Should -Match '```'
        }
    }

    Context 'LICENSE' {
        BeforeAll {
            $LicensePath = Join-Path $ProjectRoot 'LICENSE'
            $script:LicenseContent = Get-Content $LicensePath -Raw
        }

        It 'Should be MIT License' {
            $script:LicenseContent | Should -Match 'MIT License'
        }

        It 'Should have copyright notice' {
            $script:LicenseContent | Should -Match 'Copyright'
        }
    }
}

Describe 'Specification Files' {
    Context '001-installable-plugin Spec' {
        BeforeAll {
            $SpecPath = Join-Path $ProjectRoot 'specs\001-installable-plugin'
        }

        It 'Should have spec.md' {
            Test-Path (Join-Path $SpecPath 'spec.md') | Should -Be $true
        }

        It 'Should have plan.md' {
            Test-Path (Join-Path $SpecPath 'plan.md') | Should -Be $true
        }

        It 'Should have tasks.md' {
            Test-Path (Join-Path $SpecPath 'tasks.md') | Should -Be $true
        }

        It 'Should have CODE-REVIEW.md' {
            Test-Path (Join-Path $SpecPath 'CODE-REVIEW.md') | Should -Be $true
        }

        It 'Should have REMEDIATION-PLAN.md' {
            Test-Path (Join-Path $SpecPath 'REMEDIATION-PLAN.md') | Should -Be $true
        }
    }
}

Describe 'Version Consistency' {
    Context 'Version Synchronization' {
        BeforeAll {
            $PluginManifest = Get-Content (Join-Path $ProjectRoot '.claude-plugin\plugin.json') -Raw | ConvertFrom-Json
            $MarketplaceManifest = Get-Content (Join-Path $ProjectRoot '.claude-plugin\marketplace.json') -Raw | ConvertFrom-Json
            $ChangelogContent = Get-Content (Join-Path $ProjectRoot 'CHANGELOG.md') -Raw

            $script:PluginVersion = $PluginManifest.version
            $script:MarketplaceVersion = $MarketplaceManifest.plugins[0].version
            $script:ChangelogHasVersion = $ChangelogContent -match '\[1\.0\.0\]'
        }

        It 'plugin.json version should be 1.0.0' {
            $script:PluginVersion | Should -Be '1.0.0'
        }

        It 'marketplace.json version should be 1.0.0' {
            $script:MarketplaceVersion | Should -Be '1.0.0'
        }

        It 'CHANGELOG.md should document version 1.0.0' {
            $script:ChangelogHasVersion | Should -Be $true
        }

        It 'All versions should match' {
            $script:PluginVersion | Should -Be $script:MarketplaceVersion
        }
    }
}
