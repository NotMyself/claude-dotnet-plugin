BeforeAll {
    $ProjectRoot = Split-Path -Parent $PSScriptRoot
    $PluginManifestPath = Join-Path $ProjectRoot '.claude-plugin\plugin.json'

    if (-not (Test-Path $PluginManifestPath)) {
        throw "Plugin manifest not found at: $PluginManifestPath"
    }

    $script:PluginManifest = Get-Content $PluginManifestPath -Raw | ConvertFrom-Json
}

Describe 'Plugin Manifest Validation' {
    Context 'Required Fields' {
        It 'Should have a name field' {
            $script:PluginManifest.name | Should -Not -BeNullOrEmpty
        }

        It 'Should have a version field' {
            $script:PluginManifest.version | Should -Not -BeNullOrEmpty
        }

        It 'Should have a description field' {
            $script:PluginManifest.description | Should -Not -BeNullOrEmpty
        }

        It 'Should have an author object' {
            $script:PluginManifest.author | Should -Not -BeNullOrEmpty
        }

        It 'Should have author.name' {
            $script:PluginManifest.author.name | Should -Not -BeNullOrEmpty
        }

        It 'Should have author.email' {
            $script:PluginManifest.author.email | Should -Not -BeNullOrEmpty
        }

        It 'Should have a license field' {
            $script:PluginManifest.license | Should -Not -BeNullOrEmpty
        }

        It 'Should have a homepage field' {
            $script:PluginManifest.homepage | Should -Not -BeNullOrEmpty
        }

        It 'Should have a repository field' {
            $script:PluginManifest.repository | Should -Not -BeNullOrEmpty
        }

        It 'Should have a keywords array' {
            $script:PluginManifest.keywords | Should -Not -BeNullOrEmpty
            # PowerShell may treat single-item arrays as strings
            if ($script:PluginManifest.keywords -isnot [string]) {
                @($script:PluginManifest.keywords).Count | Should -BeGreaterThan 0
            }
        }
    }

    Context 'Field Values' {
        It 'Name should be claude-dotnet-plugin' {
            $script:PluginManifest.name | Should -Be 'claude-dotnet-plugin'
        }

        It 'Version should follow SemVer format' {
            $script:PluginManifest.version | Should -Match '^\d+\.\d+\.\d+$'
        }

        It 'Version should be 1.0.0' {
            $script:PluginManifest.version | Should -Be '1.0.0'
        }

        It 'Author email should be valid format' {
            $script:PluginManifest.author.email | Should -Match '^.+@.+\..+$'
        }

        It 'Homepage should be a valid URL' {
            $script:PluginManifest.homepage | Should -Match '^https?://'
        }

        It 'Repository should be a valid URL' {
            $script:PluginManifest.repository | Should -Match '^https?://'
        }

        It 'Repository should point to GitHub' {
            $script:PluginManifest.repository | Should -Match 'github\.com'
        }

        It 'Repository should be NotMyself/claude-dotnet-plugin' {
            $script:PluginManifest.repository | Should -Match 'NotMyself/claude-dotnet-plugin'
        }

        It 'License should be MIT' {
            $script:PluginManifest.license | Should -Be 'MIT'
        }

        It 'Keywords should include dotnet' {
            $script:PluginManifest.keywords | Should -Contain 'dotnet'
        }

        It 'Keywords should include csharp' {
            $script:PluginManifest.keywords | Should -Contain 'csharp'
        }

        It 'Keywords should include azure' {
            $script:PluginManifest.keywords | Should -Contain 'azure'
        }
    }

    Context 'JSON Syntax' {
        It 'Should be valid JSON' {
            { Get-Content $PluginManifestPath -Raw | ConvertFrom-Json } | Should -Not -Throw
        }
    }
}
