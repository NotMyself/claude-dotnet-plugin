BeforeAll {
    $ProjectRoot = Split-Path -Parent $PSScriptRoot
    $SettingsPath = Join-Path $ProjectRoot '.claude\settings.json'

    if (-not (Test-Path $SettingsPath)) {
        throw "Settings file not found at: $SettingsPath"
    }

    $script:Settings = Get-Content $SettingsPath -Raw | ConvertFrom-Json
}

Describe 'Settings File Validation' {
    Context 'JSON Structure' {
        It 'Should be valid JSON' {
            { Get-Content (Join-Path (Split-Path -Parent $PSScriptRoot) '.claude\settings.json') -Raw | ConvertFrom-Json } | Should -Not -Throw
        }

        It 'Should have permissions object' {
            $script:Settings.permissions | Should -Not -BeNullOrEmpty
        }

        It 'Should have permissions.allow array' {
            $script:Settings.permissions.allow | Should -Not -BeNullOrEmpty
            # Ensure it's array-like (may be single string if only one item)
            @($script:Settings.permissions.allow).Count | Should -BeGreaterThan 0
        }

        It 'Should have permissions.deny array' {
            $script:Settings.permissions.PSObject.Properties.Name | Should -Contain 'deny'
            # Deny may be empty array
            $denyValue = $script:Settings.permissions.deny
            if ($null -eq $denyValue) {
                $true | Should -Be $true  # Empty is valid
            } else {
                @($denyValue).Count | Should -BeGreaterOrEqual 0
            }
        }

        It 'Should have permissions.ask array' {
            $script:Settings.permissions.ask | Should -Not -BeNullOrEmpty
            # Ensure it's array-like
            @($script:Settings.permissions.ask).Count | Should -BeGreaterThan 0
        }
    }

    Context 'Auto-Approved Permissions' {
        It 'Should allow PowerShell commands' {
            $script:Settings.permissions.allow | Where-Object { $_ -match 'pwsh' } | Should -Not -BeNullOrEmpty
        }

        It 'Should allow Git commands' {
            $script:Settings.permissions.allow | Where-Object { $_ -match 'git' } | Should -Not -BeNullOrEmpty
        }

        It 'Should allow GitHub CLI commands' {
            $script:Settings.permissions.allow | Where-Object { $_ -match 'gh' } | Should -Not -BeNullOrEmpty
        }

        It 'Should allow .NET CLI commands' {
            $script:Settings.permissions.allow | Where-Object { $_ -match 'dotnet' } | Should -Not -BeNullOrEmpty
        }

        It 'Should allow Azure CLI commands' {
            $script:Settings.permissions.allow | Where-Object { $_ -match 'az' } | Should -Not -BeNullOrEmpty
        }

        It 'Should allow Docker commands' {
            $script:Settings.permissions.allow | Where-Object { $_ -match 'docker' } | Should -Not -BeNullOrEmpty
        }

        It 'Should allow VSCode commands' {
            $script:Settings.permissions.allow | Where-Object { $_ -match 'code' } | Should -Not -BeNullOrEmpty
        }

        It 'Should allow npm commands' {
            $script:Settings.permissions.allow | Where-Object { $_ -match 'npm' } | Should -Not -BeNullOrEmpty
        }

        It 'Should allow wget commands' {
            $script:Settings.permissions.allow | Where-Object { $_ -match 'wget' } | Should -Not -BeNullOrEmpty
        }

        It 'Should allow curl commands' {
            $script:Settings.permissions.allow | Where-Object { $_ -match 'curl' } | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Confirmation Required Permissions' {
        It 'Should ask before git push --force' {
            $script:Settings.permissions.ask | Where-Object { $_ -match 'git push --force' } | Should -Not -BeNullOrEmpty
        }

        It 'Should ask before git reset --hard' {
            $script:Settings.permissions.ask | Where-Object { $_ -match 'git reset --hard' } | Should -Not -BeNullOrEmpty
        }

        It 'Should ask before az account operations' {
            $script:Settings.permissions.ask | Where-Object { $_ -match 'az account' } | Should -Not -BeNullOrEmpty
        }

        It 'Should ask before az delete operations' {
            $script:Settings.permissions.ask | Where-Object { $_ -match 'az .* delete' } | Should -Not -BeNullOrEmpty
        }

        It 'Should ask before az devops delete operations' {
            $script:Settings.permissions.ask | Where-Object { $_ -match 'az devops .* delete' } | Should -Not -BeNullOrEmpty
        }

        It 'Should ask before docker system prune' {
            $script:Settings.permissions.ask | Where-Object { $_ -match 'docker system prune' } | Should -Not -BeNullOrEmpty
        }

        It 'Should ask before rm -rf' {
            $script:Settings.permissions.ask | Where-Object { $_ -match 'rm -rf' } | Should -Not -BeNullOrEmpty
        }

        It 'Should ask before Remove-Item -Recurse -Force' {
            $script:Settings.permissions.ask | Where-Object { $_ -match 'Remove-Item.*-Recurse -Force' } | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Security Validation' {
        It 'Should not auto-approve destructive operations' {
            $script:Settings.permissions.allow | Where-Object { $_ -match '--force' } | Should -BeNullOrEmpty
        }

        It 'Should not auto-approve hard resets' {
            $script:Settings.permissions.allow | Where-Object { $_ -match '--hard' } | Should -BeNullOrEmpty
        }

        It 'Should not auto-approve delete operations' {
            $script:Settings.permissions.allow | Where-Object { $_ -match 'delete|remove' -and $_ -notmatch 'Remove-Item' } | Should -BeNullOrEmpty
        }
    }

    Context 'Permissions Count' {
        It 'Should have at least 10 auto-approved permissions' {
            $script:Settings.permissions.allow.Count | Should -BeGreaterOrEqual 10
        }

        It 'Should have at least 8 ask-first permissions' {
            $script:Settings.permissions.ask.Count | Should -BeGreaterOrEqual 8
        }
    }
}
