BeforeAll {
    $ProjectRoot = Split-Path -Parent $PSScriptRoot
    $MarketplaceManifestPath = Join-Path $ProjectRoot '.claude-plugin\marketplace.json'

    if (-not (Test-Path $MarketplaceManifestPath)) {
        throw "Marketplace manifest not found at: $MarketplaceManifestPath"
    }

    $script:MarketplaceManifest = Get-Content $MarketplaceManifestPath -Raw | ConvertFrom-Json
}

Describe 'Marketplace Manifest Validation' {
    Context 'Required Fields' {
        It 'Should have a plugins array or plugin object' {
            $script:MarketplaceManifest.plugins | Should -Not -BeNullOrEmpty
            # PowerShell ConvertFrom-Json may return array or single object
            # Both are valid - just ensure it exists
            $pluginsCount = @($script:MarketplaceManifest.plugins).Count
            $pluginsCount | Should -BeGreaterOrEqual 1
        }

        It 'Should have at least one plugin' {
            $count = if ($script:MarketplaceManifest.plugins -is [array]) {
                $script:MarketplaceManifest.plugins.Count
            } else {
                1
            }
            $count | Should -BeGreaterOrEqual 1
        }

        It 'First plugin should have a name' {
            $script:MarketplaceManifest.plugins[0].name | Should -Not -BeNullOrEmpty
        }

        It 'First plugin should have a source' {
            $script:MarketplaceManifest.plugins[0].source | Should -Not -BeNullOrEmpty
        }

        It 'First plugin should have a version' {
            $script:MarketplaceManifest.plugins[0].version | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Field Values' {
        It 'Plugin name should be claude-dotnet-plugin' {
            $script:MarketplaceManifest.plugins[0].name | Should -Be 'claude-dotnet-plugin'
        }

        It 'Plugin source should be current directory' {
            $script:MarketplaceManifest.plugins[0].source | Should -Be '.'
        }

        It 'Plugin version should follow SemVer format' {
            $script:MarketplaceManifest.plugins[0].version | Should -Match '^\d+\.\d+\.\d+$'
        }

        It 'Plugin version should be 1.0.0' {
            $script:MarketplaceManifest.plugins[0].version | Should -Be '1.0.0'
        }
    }

    Context 'JSON Syntax' {
        It 'Should be valid JSON' {
            { Get-Content $MarketplaceManifestPath -Raw | ConvertFrom-Json } | Should -Not -Throw
        }
    }
}
