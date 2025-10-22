<#
.SYNOPSIS
    Runs all Pester tests for the Claude .NET Plugin

.DESCRIPTION
    Executes the complete test suite for the Claude .NET Plugin, including:
    - Plugin manifest validation
    - Marketplace manifest validation
    - Agent structure and frontmatter validation
    - Skill structure and frontmatter validation
    - Settings.json permissions validation
    - Directory structure validation
    - Documentation validation

.PARAMETER OutputFormat
    Test output format (NUnitXml, JUnitXml, or None). Default: None

.PARAMETER CodeCoverage
    Enable code coverage reporting. Default: false

.EXAMPLE
    .\Run-Tests.ps1
    Runs all tests with default output

.EXAMPLE
    .\Run-Tests.ps1 -OutputFormat NUnitXml
    Runs all tests and generates NUnit XML report
#>

[CmdletBinding()]
param(
    [Parameter()]
    [ValidateSet('NUnitXml', 'JUnitXml', 'None')]
    [string]$OutputFormat = 'None',

    [Parameter()]
    [switch]$CodeCoverage
)

# Ensure Pester is installed
if (-not (Get-Module -ListAvailable -Name Pester)) {
    Write-Host "Pester is not installed. Installing Pester..." -ForegroundColor Yellow
    Install-Module -Name Pester -Force -SkipPublisherCheck -Scope CurrentUser
}

# Import Pester
Import-Module Pester -MinimumVersion 5.0 -ErrorAction Stop

# Get test files
$TestFiles = Get-ChildItem -Path $PSScriptRoot -Filter '*.Tests.ps1'

Write-Host "`nClaude .NET Plugin Test Suite" -ForegroundColor Cyan
Write-Host "==============================`n" -ForegroundColor Cyan

# Configure Pester
$PesterConfig = New-PesterConfiguration
$PesterConfig.Run.Path = $PSScriptRoot
$PesterConfig.Run.PassThru = $true
$PesterConfig.Output.Verbosity = 'Detailed'
$PesterConfig.TestResult.Enabled = $OutputFormat -ne 'None'

if ($OutputFormat -ne 'None') {
    $PesterConfig.TestResult.OutputFormat = $OutputFormat
    $PesterConfig.TestResult.OutputPath = Join-Path $PSScriptRoot "TestResults.$($OutputFormat.ToLower()).xml"
}

# Run tests
Write-Host "Running tests..." -ForegroundColor Green
Write-Host "Test files found: $($TestFiles.Count)`n" -ForegroundColor Gray

$Result = Invoke-Pester -Configuration $PesterConfig

# Display summary
Write-Host "`n==============================" -ForegroundColor Cyan
Write-Host "Test Summary" -ForegroundColor Cyan
Write-Host "==============================`n" -ForegroundColor Cyan

Write-Host "Total Tests:  $($Result.TotalCount)" -ForegroundColor White
Write-Host "Passed:       $($Result.PassedCount)" -ForegroundColor Green
Write-Host "Failed:       $($Result.FailedCount)" -ForegroundColor $(if ($Result.FailedCount -eq 0) { 'Green' } else { 'Red' })
Write-Host "Skipped:      $($Result.SkippedCount)" -ForegroundColor Yellow
Write-Host "Duration:     $($Result.Duration)`n" -ForegroundColor White

if ($OutputFormat -ne 'None') {
    Write-Host "Test results saved to: $($PesterConfig.TestResult.OutputPath)" -ForegroundColor Cyan
}

# Exit with appropriate code
if ($Result.FailedCount -gt 0) {
    Write-Host "Tests FAILED" -ForegroundColor Red
    exit 1
} else {
    Write-Host "All tests PASSED" -ForegroundColor Green
    exit 0
}
