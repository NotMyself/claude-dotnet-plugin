# Claude .NET Plugin Examples

Realistic examples demonstrating how each agent and skill responds to common .NET development scenarios.

## Table of Contents

- [Primary Agents](#primary-agents)
  - [dotnet-csharp-expert](#dotnet-csharp-expert)
  - [dotnet-azure-architect](#dotnet-azure-architect)
  - [dotnet-azure-devops](#dotnet-azure-devops)
  - [dotnet-git-manager](#dotnet-git-manager)
- [Meta Agents](#meta-agents)
  - [dotnet-agent-expert](#dotnet-agent-expert)
  - [dotnet-readme-maintainer](#dotnet-readme-maintainer)
  - [dotnet-mcp-expert](#dotnet-mcp-expert)
- [Skills](#skills)
  - [README Library Template](#readme-library-template)
  - [README Script Template](#readme-script-template)

---

## Primary Agents

### dotnet-csharp-expert

**Scenario 1: Creating a New Web API Project**

```
User: "I need to create a new .NET 9 web API with minimal APIs and MSTest"

Claude: I'll use the dotnet-csharp-expert agent to guide you through creating
a modern .NET 9 web API with minimal APIs and MSTest.

Let me create the project structure:

# Create solution and projects
dotnet new sln -n MyApi
dotnet new webapi -n MyApi.Api --use-minimal-apis
dotnet new mstest -n MyApi.Tests

# Add projects to solution
dotnet sln add MyApi.Api/MyApi.Api.csproj
dotnet sln add MyApi.Tests/MyApi.Tests.csproj

# Add project reference for testing
dotnet add MyApi.Tests reference MyApi.Api

Now let's implement a sample endpoint in Program.cs:

// MyApi.Api/Program.cs
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

// Sample endpoint
app.MapGet("/api/products", () =>
    Results.Ok(new[]
    {
        new { Id = 1, Name = "Product 1", Price = 29.99 },
        new { Id = 2, Name = "Product 2", Price = 39.99 }
    }))
    .WithName("GetProducts")
    .WithOpenApi();

app.Run();

And a corresponding MSTest test:

// MyApi.Tests/ProductsEndpointTests.cs
using Microsoft.AspNetCore.Mvc.Testing;

[TestClass]
public class ProductsEndpointTests
{
    private WebApplicationFactory<Program> _factory = null!;

    [TestInitialize]
    public void Setup()
    {
        _factory = new WebApplicationFactory<Program>();
    }

    [TestMethod]
    public async Task GetProducts_ReturnsSuccessStatusCode()
    {
        // Arrange
        var client = _factory.CreateClient();

        // Act
        var response = await client.GetAsync("/api/products");

        // Assert
        Assert.IsTrue(response.IsSuccessStatusCode);
    }
}

You can run the tests with: dotnet test
And run the API with: dotnet run --project MyApi.Api
```

**Scenario 2: Implementing Entity Framework Core with Repository Pattern**

```
User: "How do I set up Entity Framework Core with the repository pattern?"

Claude: I'll use the dotnet-csharp-expert agent to show you modern EF Core
setup with the repository pattern.

First, install required packages:

dotnet add package Microsoft.EntityFrameworkCore.SqlServer
dotnet add package Microsoft.EntityFrameworkCore.Design

1. Create your entity:

public class Product
{
    public int Id { get; set; }
    public required string Name { get; set; }
    public decimal Price { get; set; }
    public DateTime CreatedAt { get; set; }
}

2. Create the DbContext:

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options) { }

    public DbSet<Product> Products => Set<Product>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Product>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Name).HasMaxLength(200);
            entity.Property(e => e.Price).HasPrecision(18, 2);
            entity.HasIndex(e => e.Name);
        });
    }
}

3. Create repository interface and implementation:

public interface IProductRepository
{
    Task<IEnumerable<Product>> GetAllAsync();
    Task<Product?> GetByIdAsync(int id);
    Task<Product> AddAsync(Product product);
    Task UpdateAsync(Product product);
    Task DeleteAsync(int id);
}

public class ProductRepository : IProductRepository
{
    private readonly AppDbContext _context;

    public ProductRepository(AppDbContext context)
    {
        _context = context;
    }

    public async Task<IEnumerable<Product>> GetAllAsync()
        => await _context.Products.ToListAsync();

    public async Task<Product?> GetByIdAsync(int id)
        => await _context.Products.FindAsync(id);

    public async Task<Product> AddAsync(Product product)
    {
        _context.Products.Add(product);
        await _context.SaveChangesAsync();
        return product;
    }

    public async Task UpdateAsync(Product product)
    {
        _context.Products.Update(product);
        await _context.SaveChangesAsync();
    }

    public async Task DeleteAsync(int id)
    {
        var product = await GetByIdAsync(id);
        if (product != null)
        {
            _context.Products.Remove(product);
            await _context.SaveChangesAsync();
        }
    }
}

4. Register services in Program.cs:

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("DefaultConnection")));

builder.Services.AddScoped<IProductRepository, ProductRepository>();

5. Add connection string to appsettings.json:

{
  "ConnectionStrings": {
    "DefaultConnection": "Server=(localdb)\\mssqllocaldb;Database=MyApiDb;Trusted_Connection=true"
  }
}

Create and run migrations:

dotnet ef migrations add InitialCreate
dotnet ef database update
```

---

### dotnet-azure-architect

**Scenario 1: Architecture for Scalable Web Application**

```
User: "What Azure services should I use for a scalable e-commerce web application?"

Claude: I'll use the dotnet-azure-architect agent to design a cost-conscious,
scalable architecture for your e-commerce application.

Here's a recommended architecture:

┌─────────────────────────────────────────────────────────────────┐
│                        Azure Front Door                         │
│                   (Global load balancing + CDN)                 │
└────────────────────────────┬────────────────────────────────────┘
                             │
            ┌────────────────┴────────────────┐
            │                                 │
┌───────────▼──────────┐          ┌──────────▼──────────┐
│  App Service (Web)   │          │  App Service (API)  │
│   (Premium v3 P1V3)  │◄─────────┤  (Premium v3 P1V3)  │
│   Auto-scale 2-10    │          │  Auto-scale 2-10    │
└──────────────────────┘          └──────────┬──────────┘
                                             │
                    ┌────────────────────────┼────────────────┐
                    │                        │                │
        ┌───────────▼──────────┐ ┌──────────▼───────┐ ┌─────▼──────┐
        │ Azure SQL Database   │ │  Azure Cache for │ │   Azure    │
        │  (General Purpose S2)│ │  Redis (Basic C1)│ │  Storage   │
        │  Read replica for    │ │  Session + Cache │ │  (Blobs)   │
        │  reporting queries   │ │                  │ │            │
        └──────────────────────┘ └──────────────────┘ └────────────┘

Cost Breakdown (Monthly USD):
- App Service Plan (P1V3 x2): ~$400
- Azure SQL Database (S2): ~$150
- Azure Cache for Redis (C1): ~$70
- Azure Storage (Blob): ~$20-50
- Application Insights: ~$25
- Azure Front Door: ~$35 + data transfer
Total: ~$700-750/month (scales with traffic)

Terraform configuration:

# resource_group.tf
resource "azurerm_resource_group" "ecommerce" {
  name     = "rg-ecommerce-${var.environment}"
  location = var.location
}

# app_service.tf
resource "azurerm_service_plan" "web" {
  name                = "asp-ecommerce-web-${var.environment}"
  resource_group_name = azurerm_resource_group.ecommerce.name
  location            = azurerm_resource_group.ecommerce.location
  os_type             = "Linux"
  sku_name            = "P1v3"
}

resource "azurerm_linux_web_app" "web" {
  name                = "app-ecommerce-web-${var.environment}"
  resource_group_name = azurerm_resource_group.ecommerce.name
  location            = azurerm_service_plan.web.location
  service_plan_id     = azurerm_service_plan.web.id

  site_config {
    always_on = true
    application_stack {
      dotnet_version = "9.0"
    }
  }

  app_settings = {
    "ASPNETCORE_ENVIRONMENT" = var.environment
    "ApplicationInsights__InstrumentationKey" = azurerm_application_insights.main.instrumentation_key
  }
}

# sql_database.tf
resource "azurerm_mssql_server" "main" {
  name                         = "sql-ecommerce-${var.environment}"
  resource_group_name          = azurerm_resource_group.ecommerce.name
  location                     = azurerm_resource_group.ecommerce.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_mssql_database" "main" {
  name         = "sqldb-ecommerce-${var.environment}"
  server_id    = azurerm_mssql_server.main.id
  sku_name     = "S2"
  collation    = "SQL_Latin1_General_CP1_CI_AS"

  threat_detection_policy {
    state = "Enabled"
  }
}

Key Design Decisions:

1. App Service Premium V3: Better price/performance than Premium V2
2. Auto-scaling: 2-10 instances based on CPU (>70% scale out, <30% scale in)
3. Azure SQL General Purpose: Read replica for reporting reduces primary load
4. Redis Cache: Session state + frequently accessed data (products, categories)
5. Azure Storage: Product images, documents (cheaper than database storage)
6. Application Insights: Full observability for performance monitoring

Cost Optimization Tips:
- Use reserved capacity for SQL Database (save 30-40%)
- Enable auto-pause for development environments
- Use Azure Front Door for CDN to reduce App Service egress costs
- Implement caching strategy to reduce database queries
```

**Scenario 2: Multi-Tenant SaaS Architecture**

```
User: "How do I design a multi-tenant SaaS application on Azure?"

Claude: I'll use the dotnet-azure-architect agent to design a secure,
scalable multi-tenant architecture.

Multi-Tenant Architecture Pattern: Database-per-Tenant (Recommended for SaaS)

┌──────────────────────────────────────────────────────────────┐
│                      Azure AD B2C                            │
│                (Tenant authentication)                       │
└────────────────────────┬─────────────────────────────────────┘
                         │
            ┌────────────▼───────────────┐
            │   Azure API Management     │
            │   (Tenant routing, rate    │
            │    limiting, API keys)     │
            └────────────┬───────────────┘
                         │
        ┌────────────────▼────────────────┐
        │   App Service (Multi-tenant)    │
        │   Tenant context middleware     │
        └───┬────────────────────────┬────┘
            │                        │
┌───────────▼──────────┐  ┌─────────▼──────────┐
│  Azure SQL Elastic   │  │   Azure Cosmos DB  │
│  Pool (Tenant DBs)   │  │  (Tenant metadata) │
│  50 DTU shared       │  │                    │
└──────────────────────┘  └────────────────────┘

Implementation in .NET:

// Tenant context middleware
public class TenantMiddleware
{
    private readonly RequestDelegate _next;

    public TenantMiddleware(RequestDelegate next)
    {
        _next = next;
    }

    public async Task InvokeAsync(HttpContext context, ITenantService tenantService)
    {
        // Extract tenant from subdomain: customer1.myapp.com
        var host = context.Request.Host.Host;
        var tenantId = host.Split('.').FirstOrDefault();

        if (string.IsNullOrEmpty(tenantId))
        {
            context.Response.StatusCode = 400;
            await context.Response.WriteAsync("Tenant not specified");
            return;
        }

        // Load tenant context
        var tenant = await tenantService.GetTenantAsync(tenantId);
        if (tenant == null)
        {
            context.Response.StatusCode = 404;
            await context.Response.WriteAsync("Tenant not found");
            return;
        }

        // Store in HttpContext for downstream use
        context.Items["TenantId"] = tenant.Id;
        context.Items["TenantContext"] = tenant;

        await _next(context);
    }
}

// Tenant-aware DbContext
public class TenantDbContext : DbContext
{
    private readonly IHttpContextAccessor _httpContextAccessor;

    public TenantDbContext(
        DbContextOptions<TenantDbContext> options,
        IHttpContextAccessor httpContextAccessor) : base(options)
    {
        _httpContextAccessor = httpContextAccessor;
    }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        if (!optionsBuilder.IsConfigured)
        {
            var tenantId = _httpContextAccessor.HttpContext?.Items["TenantId"] as string;
            var connectionString = GetTenantConnectionString(tenantId);
            optionsBuilder.UseSqlServer(connectionString);
        }
    }

    private string GetTenantConnectionString(string? tenantId)
    {
        // Retrieve from Azure Key Vault or configuration
        return $"Server=tcp:sql-tenants.database.windows.net;Database=tenant-{tenantId};...";
    }
}

Terraform for Elastic Pool:

resource "azurerm_mssql_elasticpool" "tenants" {
  name                = "sqlep-tenants-${var.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  server_name         = azurerm_mssql_server.main.name
  max_size_gb         = 50

  sku {
    name     = "StandardPool"
    tier     = "Standard"
    capacity = 50
  }

  per_database_settings {
    min_capacity = 0
    max_capacity = 50
  }
}

# Provision new tenant database
resource "azurerm_mssql_database" "tenant" {
  for_each            = var.tenants
  name                = "tenant-${each.key}"
  server_id           = azurerm_mssql_server.main.id
  elastic_pool_id     = azurerm_mssql_elasticpool.tenants.id
  collation           = "SQL_Latin1_General_CP1_CI_AS"

  tags = {
    TenantId = each.key
    TenantName = each.value.name
  }
}

Security Considerations:
1. Azure AD B2C for tenant user authentication
2. Managed identities for service-to-service auth
3. Azure Key Vault for tenant connection strings
4. Row-level security (RLS) as additional safety layer
5. API Management for rate limiting per tenant
```

---

### dotnet-azure-devops

**Scenario 1: Creating a CI/CD Pipeline for .NET 9 Web API**

```
User: "Create an Azure DevOps pipeline for my .NET 9 web API that builds, tests,
and deploys to Azure App Service"

Claude: I'll use the dotnet-azure-devops agent to create a comprehensive YAML
pipeline with build, test, and deployment stages.

# azure-pipelines.yml
trigger:
  branches:
    include:
      - main
      - develop
  paths:
    exclude:
      - README.md
      - docs/**

variables:
  buildConfiguration: 'Release'
  dotnetVersion: '9.x'
  azureSubscription: 'Azure-Production'
  webAppName: 'app-myapi-prod'

stages:
- stage: Build
  displayName: 'Build and Test'
  jobs:
  - job: BuildJob
    displayName: 'Build .NET Application'
    pool:
      vmImage: 'ubuntu-latest'

    steps:
    - task: UseDotNet@2
      displayName: 'Install .NET 9 SDK'
      inputs:
        version: $(dotnetVersion)
        includePreviewVersions: false

    - task: DotNetCoreCLI@2
      displayName: 'Restore NuGet packages'
      inputs:
        command: 'restore'
        projects: '**/*.csproj'

    - task: DotNetCoreCLI@2
      displayName: 'Build solution'
      inputs:
        command: 'build'
        projects: '**/*.csproj'
        arguments: '--configuration $(buildConfiguration) --no-restore'

    - task: DotNetCoreCLI@2
      displayName: 'Run unit tests'
      inputs:
        command: 'test'
        projects: '**/*Tests.csproj'
        arguments: '--configuration $(buildConfiguration) --no-build --collect:"XPlat Code Coverage" --logger trx'
        publishTestResults: true

    - task: PublishCodeCoverageResults@2
      displayName: 'Publish code coverage'
      inputs:
        codeCoverageTool: 'Cobertura'
        summaryFileLocation: '$(Agent.TempDirectory)/**/coverage.cobertura.xml'

    - task: DotNetCoreCLI@2
      displayName: 'Publish application'
      inputs:
        command: 'publish'
        publishWebProjects: true
        arguments: '--configuration $(buildConfiguration) --output $(Build.ArtifactStagingDirectory)'
        zipAfterPublish: true

    - publish: $(Build.ArtifactStagingDirectory)
      displayName: 'Publish build artifacts'
      artifact: drop

- stage: DeployDev
  displayName: 'Deploy to Development'
  dependsOn: Build
  condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/develop'))
  jobs:
  - deployment: DeployDevJob
    displayName: 'Deploy to Dev Environment'
    environment: 'development'
    pool:
      vmImage: 'ubuntu-latest'
    strategy:
      runOnce:
        deploy:
          steps:
          - task: AzureWebApp@1
            displayName: 'Deploy to Azure Web App (Dev)'
            inputs:
              azureSubscription: $(azureSubscription)
              appType: 'webAppLinux'
              appName: 'app-myapi-dev'
              package: '$(Pipeline.Workspace)/drop/**/*.zip'
              runtimeStack: 'DOTNETCORE|9.0'

- stage: DeployProduction
  displayName: 'Deploy to Production'
  dependsOn: Build
  condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
  jobs:
  - deployment: DeployProdJob
    displayName: 'Deploy to Production Environment'
    environment: 'production'
    pool:
      vmImage: 'ubuntu-latest'
    strategy:
      runOnce:
        deploy:
          steps:
          - task: AzureWebApp@1
            displayName: 'Deploy to Azure Web App (Production)'
            inputs:
              azureSubscription: $(azureSubscription)
              appType: 'webAppLinux'
              appName: $(webAppName)
              package: '$(Pipeline.Workspace)/drop/**/*.zip'
              runtimeStack: 'DOTNETCORE|9.0'
              deploymentMethod: 'zipDeploy'

          - task: AzureAppServiceSettings@1
            displayName: 'Configure App Settings'
            inputs:
              azureSubscription: $(azureSubscription)
              appName: $(webAppName)
              resourceGroupName: 'rg-myapi-prod'
              appSettings: |
                [
                  {
                    "name": "ASPNETCORE_ENVIRONMENT",
                    "value": "Production",
                    "slotSetting": false
                  }
                ]

Pipeline features:
✅ .NET 9 SDK installation
✅ Restore, build, test workflow
✅ Code coverage collection and publishing
✅ Artifact publishing
✅ Environment-specific deployments (dev on develop, prod on main)
✅ Azure App Service deployment with runtime configuration
✅ Manual approval required for production (via environment settings)

Set up Azure DevOps environments:
1. Go to Pipelines > Environments
2. Create "development" and "production" environments
3. Add approval gate to "production" environment
```

**Scenario 2: Managing Work Items with Conventional Commits**

```
User: "How do I link commits to Azure DevOps work items?"

Claude: I'll use the dotnet-azure-devops agent to show you the conventional
commit format with Azure DevOps integration.

Commit Message Format:

<type>(<scope>): <description> (#<work-item-id>)

<optional body>

<optional footer>

Examples:

1. Feature with work item link:
git commit -m "feat(auth): add JWT authentication (#1234)

Implemented JWT bearer token authentication with refresh tokens.

Related work items: #1234, #1235"

2. Bug fix:
git commit -m "fix(api): resolve null reference in product controller (#2345)

Fixed NullReferenceException when product category is null.
Added defensive null checks and unit tests."

3. Multiple work items:
git commit -m "refactor(database): migrate to EF Core 9 (#3456, #3457)

Upgraded Entity Framework Core from 8 to 9.
Updated all DbContext configurations for new features."

Azure DevOps automatically:
- Links commit to work item #1234
- Updates work item with commit reference
- Shows commits in work item "Development" section
- Transitions work item state (if configured)

PowerShell function for conventional commits:

function New-Commit {
    param(
        [Parameter(Mandatory)]
        [ValidateSet('feat', 'fix', 'docs', 'refactor', 'test', 'chore')]
        [string]$Type,

        [Parameter(Mandatory)]
        [string]$Description,

        [string]$Scope,

        [int[]]$WorkItems,

        [string]$Body
    )

    $scopePart = if ($Scope) { "($Scope)" } else { "" }
    $workItemPart = if ($WorkItems) { " (#$($WorkItems -join ', #'))" } else { "" }

    $message = "$Type$scopePart: $Description$workItemPart"

    if ($Body) {
        $message += "`n`n$Body"
    }

    git commit -m $message
}

# Usage:
New-Commit -Type feat -Scope auth -Description "add OAuth2 support" -WorkItems 1234,1235

Work Item State Transitions (configured in Azure DevOps):
- Commit with "feat:" or "fix:" → Moves to "In Progress"
- PR created → Moves to "In Review"
- PR completed → Moves to "Done"
```

---

### dotnet-git-manager

**Scenario 1: Feature Branch Workflow**

```
User: "Walk me through creating a feature branch and submitting a PR"

Claude: I'll use the dotnet-git-manager agent to guide you through the
recommended Git workflow.

Step 1: Sync with main branch

# Switch to main and update
git checkout main
git pull origin main

Step 2: Create feature branch

# Create feature branch with descriptive name
git checkout -b feature/user-authentication

# Verify you're on the new branch
git branch --show-current

Step 3: Make changes and commit

# Stage changes
git add src/Auth/

# Commit with conventional commit format
git commit -m "feat(auth): implement JWT authentication

Added JWT bearer token authentication with:
- Token generation and validation
- Refresh token support
- Role-based claims

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

Step 4: Push feature branch

# Push to remote (first time)
git push -u origin feature/user-authentication

# Subsequent pushes
git push

Step 5: Keep feature branch updated (if main changes)

# Fetch latest from main
git fetch origin main

# Rebase your feature onto main (cleaner history)
git rebase origin/main

# If conflicts occur, resolve them then:
git add .
git rebase --continue

# Force push after rebase (only for feature branches!)
git push --force-with-lease

Step 6: Create pull request

# Using GitHub CLI
gh pr create --title "feat: implement JWT authentication" \
  --body "$(cat <<'EOF'
## Summary
- Added JWT bearer token authentication
- Implemented refresh token mechanism
- Added role-based authorization claims

## Testing
- [x] Unit tests for token generation
- [x] Unit tests for token validation
- [x] Integration tests for auth flow
- [ ] Manual testing in staging environment

## Related Work Items
Closes #1234

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"

Step 7: Address PR feedback

# Make changes based on review
git add .
git commit -m "fix(auth): address PR feedback

- Improved error handling in token validation
- Added XML documentation comments
- Refactored token service for better testability"

git push

Step 8: After PR approval, squash and merge

# Using GitHub CLI
gh pr merge --squash --delete-branch

Best Practices:
✅ Keep feature branches short-lived (< 1 week)
✅ Rebase instead of merge to keep history clean
✅ Use conventional commits for clear history
✅ Delete branch after merge to reduce clutter
✅ Never force push to main or shared branches
```

**Scenario 2: Resolving Merge Conflicts**

```
User: "I have merge conflicts when rebasing. How do I resolve them?"

Claude: I'll use the dotnet-git-manager agent to walk you through
conflict resolution step-by-step.

Current situation: You ran `git rebase main` and got conflicts

Step 1: Identify conflicted files

git status

# Output shows:
# both modified:   src/Services/ProductService.cs
# both modified:   src/Models/Product.cs

Step 2: Open conflicted file and resolve

# File: src/Services/ProductService.cs
<<<<<<< HEAD (your changes)
public async Task<Product> GetProductAsync(int id)
{
    return await _context.Products
        .Include(p => p.Category)
        .Include(p => p.Reviews)
        .FirstOrDefaultAsync(p => p.Id == id);
}
=======
public async Task<Product?> GetProductAsync(int id)
{
    return await _context.Products
        .Include(p => p.Category)
        .FirstOrDefaultAsync(p => p.Id == id);
}
>>>>>>> main (incoming changes)

Resolution strategy:
1. Keep nullable return type from main (Product?)
2. Keep your additional Include for Reviews
3. Remove conflict markers

# Resolved version:
public async Task<Product?> GetProductAsync(int id)
{
    return await _context.Products
        .Include(p => p.Category)
        .Include(p => p.Reviews)
        .FirstOrDefaultAsync(p => p.Id == id);
}

Step 3: Stage resolved files

git add src/Services/ProductService.cs
git add src/Models/Product.cs

Step 4: Continue rebase

git rebase --continue

# If more conflicts, repeat steps 2-4
# If no more conflicts, rebase completes successfully

Step 5: Verify resolution

# Run tests to ensure nothing broke
dotnet test

# Check diff against main
git diff main

Step 6: Push updated branch

# Use --force-with-lease for safety (fails if remote changed)
git push --force-with-lease

Conflict Resolution Tools:

# Option 1: Use VS Code merge editor
code .
# VS Code shows visual merge interface with "Accept Incoming", "Accept Current", "Accept Both"

# Option 2: Use Git merge tool
git mergetool

# Option 3: Abort and try merge instead
git rebase --abort
git merge main
# Merge creates merge commit instead of rewriting history

When to abort:
- Too many conflicts (>10 files)
- Conflicts are complex and risky
- Feature branch is very old (>2 weeks behind main)

Alternative: Use merge instead of rebase for long-lived branches
```

---

## Meta Agents

### dotnet-agent-expert

**Scenario: Creating a Specialized Testing Agent**

```
User: "I want to create an agent that specializes in MSTest and NSubstitute
for .NET testing"

Claude: I'll use the dotnet-agent-expert agent to create a comprehensive
testing specialist agent for you.

I'll create a new agent called "dotnet-test-specialist" in the agents/ directory:

# agents/dotnet-test-specialist.md
---
name: dotnet-test-specialist
description: >
  Use this agent when working with MSTest and NSubstitute for .NET unit testing.
  Specializes in test project setup, test patterns, mocking, and test organization.
  Examples: <example>Context: User writing unit tests user: 'How do I mock a
  DbContext in MSTest?' assistant: 'I'll use the dotnet-test-specialist agent
  to show you DbContext mocking with NSubstitute'</example>
color: yellow
tools: Read, Write, Edit, MultiEdit, Bash, Grep, Glob, Task
---

# .NET Test Specialist Agent

Expert guidance for MSTest testing framework and NSubstitute mocking library.

## Domain Expertise

### MSTest Framework
- Test class and method organization
- Test lifecycle (TestInitialize, TestCleanup, ClassInitialize, ClassCleanup)
- Assertions (Assert.AreEqual, Assert.ThrowsException, CollectionAssert)
- Data-driven tests with DataRow and DynamicData
- Test categories and traits

[... rest of agent content ...]

The agent has been created! It includes:

✅ Comprehensive MSTest guidance (all assertion types, lifecycle methods)
✅ NSubstitute mocking patterns (Returns, Throws, Received, Arg.Is)
✅ Test organization best practices (AAA pattern, one assert per test)
✅ Database testing strategies (in-memory, repository mocking)
✅ Integration testing with WebApplicationFactory
✅ Code examples for common scenarios

You can now use this agent by mentioning testing scenarios like:
- "How do I write MSTest tests for this service?"
- "Create unit tests with NSubstitute mocks"
- "Set up integration tests for my API"
```

---

### dotnet-readme-maintainer

**Scenario: Updating README with New Features**

```
User: "Update the README to reflect the new authentication features I just added"

Claude: I'll use the dotnet-readme-maintainer agent to update your README
with the new authentication features.

I'll analyze your recent changes and update the README hierarchically:

[Agent searches for authentication-related code]

Found new authentication features:
- src/Auth/JwtTokenService.cs
- src/Auth/RefreshTokenHandler.cs
- src/Middleware/JwtAuthenticationMiddleware.cs

Updating README.md:

# MyWebApi

> Modern .NET 9 web API with JWT authentication and role-based authorization

[Existing content preserved...]

## Features

- **JWT Authentication**: Secure token-based authentication with refresh tokens
  - Access token expiration: 15 minutes
  - Refresh token expiration: 7 days
  - Role-based claims support
- **Role-Based Authorization**: Granular permissions for Admin, User, and Guest roles
- **RESTful API**: Clean, resource-based endpoints
- **Entity Framework Core**: Code-first database with migrations
- **Swagger UI**: Interactive API documentation

## Authentication

### Obtaining Tokens

POST /api/auth/login
{
  "username": "user@example.com",
  "password": "SecurePassword123!"
}

Response:
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "9b1c3e5f-7a2d-4b8e-9c3a-1e5f7a2d4b8e",
  "expiresIn": 900
}

### Using Access Tokens

Include the access token in the Authorization header:

GET /api/products
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

### Refreshing Tokens

POST /api/auth/refresh
{
  "refreshToken": "9b1c3e5f-7a2d-4b8e-9c3a-1e5f7a2d4b8e"
}

## Configuration

Add JWT settings to appsettings.json:

{
  "Jwt": {
    "SecretKey": "your-secret-key-min-32-characters",
    "Issuer": "https://yourdomain.com",
    "Audience": "https://yourdomain.com",
    "AccessTokenExpirationMinutes": 15,
    "RefreshTokenExpirationDays": 7
  }
}

[Rest of README preserved...]

Changes made:
✅ Added "Features" section highlighting JWT authentication
✅ Added "Authentication" section with usage examples
✅ Added JWT configuration guidance
✅ Preserved existing README structure and content
✅ Used consistent formatting and code blocks

The README now reflects your authentication implementation!
```

---

### dotnet-mcp-expert

**Scenario: Creating an Azure MCP Server**

```
User: "I need an MCP server for Azure resource management operations"

Claude: I'll use the dotnet-mcp-expert agent to create a comprehensive
Azure MCP server specification.

I'll create the MCP server configuration in .claude/mcp/servers/azure.json:

{
  "name": "azure-resources",
  "version": "1.0.0",
  "description": "Azure resource management and querying via Azure SDK",
  "protocol": "mcp/1.0",
  "capabilities": {
    "resources": true,
    "tools": true,
    "prompts": false
  },
  "authentication": {
    "type": "azure-cli",
    "scopes": [
      "https://management.azure.com/.default"
    ]
  },
  "tools": [
    {
      "name": "list-resource-groups",
      "description": "List all resource groups in the subscription",
      "parameters": {
        "type": "object",
        "properties": {
          "subscriptionId": {
            "type": "string",
            "description": "Azure subscription ID"
          }
        },
        "required": ["subscriptionId"]
      }
    },
    {
      "name": "get-app-service",
      "description": "Get details of an Azure App Service",
      "parameters": {
        "type": "object",
        "properties": {
          "subscriptionId": {
            "type": "string",
            "description": "Azure subscription ID"
          },
          "resourceGroup": {
            "type": "string",
            "description": "Resource group name"
          },
          "appServiceName": {
            "type": "string",
            "description": "App Service name"
          }
        },
        "required": ["subscriptionId", "resourceGroup", "appServiceName"]
      }
    },
    {
      "name": "restart-app-service",
      "description": "Restart an Azure App Service",
      "parameters": {
        "type": "object",
        "properties": {
          "subscriptionId": {
            "type": "string"
          },
          "resourceGroup": {
            "type": "string"
          },
          "appServiceName": {
            "type": "string"
          }
        },
        "required": ["subscriptionId", "resourceGroup", "appServiceName"]
      }
    }
  ],
  "resources": [
    {
      "uri": "azure://subscriptions/{subscriptionId}/resourceGroups",
      "name": "Resource Groups",
      "description": "List of all resource groups"
    },
    {
      "uri": "azure://subscriptions/{subscriptionId}/providers/Microsoft.Web/sites",
      "name": "App Services",
      "description": "List of all App Services"
    }
  ]
}

Implementation guide for the MCP server:

1. Install required packages:
dotnet add package Azure.Identity
dotnet add package Azure.ResourceManager
dotnet add package Azure.ResourceManager.AppService

2. Create MCP server implementation:

using Azure.Identity;
using Azure.ResourceManager;
using Azure.ResourceManager.AppService;

public class AzureMcpServer
{
    private readonly ArmClient _client;

    public AzureMcpServer()
    {
        _client = new ArmClient(new DefaultAzureCredential());
    }

    public async Task<object> ExecuteToolAsync(string toolName, JsonElement parameters)
    {
        return toolName switch
        {
            "list-resource-groups" => await ListResourceGroupsAsync(
                parameters.GetProperty("subscriptionId").GetString()!),
            "get-app-service" => await GetAppServiceAsync(
                parameters.GetProperty("subscriptionId").GetString()!,
                parameters.GetProperty("resourceGroup").GetString()!,
                parameters.GetProperty("appServiceName").GetString()!),
            "restart-app-service" => await RestartAppServiceAsync(
                parameters.GetProperty("subscriptionId").GetString()!,
                parameters.GetProperty("resourceGroup").GetString()!,
                parameters.GetProperty("appServiceName").GetString()!),
            _ => throw new NotImplementedException($"Tool '{toolName}' not implemented")
        };
    }

    private async Task<object> ListResourceGroupsAsync(string subscriptionId)
    {
        var subscription = await _client.GetSubscriptionResource(
            new ResourceIdentifier($"/subscriptions/{subscriptionId}")).GetAsync();

        var resourceGroups = new List<object>();
        await foreach (var rg in subscription.Value.GetResourceGroups())
        {
            resourceGroups.Add(new
            {
                name = rg.Data.Name,
                location = rg.Data.Location.Name,
                id = rg.Id.ToString()
            });
        }

        return resourceGroups;
    }

    private async Task<object> GetAppServiceAsync(
        string subscriptionId, string resourceGroup, string appServiceName)
    {
        var subscription = await _client.GetSubscriptionResource(
            new ResourceIdentifier($"/subscriptions/{subscriptionId}")).GetAsync();

        var rg = await subscription.Value.GetResourceGroups()
            .GetAsync(resourceGroup);

        var appService = await rg.Value.GetWebSites()
            .GetAsync(appServiceName);

        return new
        {
            name = appService.Value.Data.Name,
            state = appService.Value.Data.State,
            defaultHostName = appService.Value.Data.DefaultHostName,
            location = appService.Value.Data.Location.Name
        };
    }

    private async Task<object> RestartAppServiceAsync(
        string subscriptionId, string resourceGroup, string appServiceName)
    {
        var subscription = await _client.GetSubscriptionResource(
            new ResourceIdentifier($"/subscriptions/{subscriptionId}")).GetAsync();

        var rg = await subscription.Value.GetResourceGroups()
            .GetAsync(resourceGroup);

        var appService = await rg.Value.GetWebSites()
            .GetAsync(appServiceName);

        await appService.Value.RestartAsync();

        return new { status = "restarted", appService = appServiceName };
    }
}

Usage in Claude Code:

User: "List my Azure resource groups"
Claude: [Uses azure-resources MCP server]
       [Calls list-resource-groups tool with your default subscription]

       Found 3 resource groups:
       - rg-production-eastus (East US)
       - rg-development-westus (West US)
       - rg-shared-resources (Central US)

User: "Restart the production web app"
Claude: [Uses azure-resources MCP server]
       [Calls restart-app-service with identified App Service]

       ✅ Restarted app-myapi-prod successfully

The MCP server is now configured and ready to use!
```

---

## Skills

### README Library Template

**Scenario: Generating README for NuGet Package**

```
User: "Create a README for my NuGet package for logging utilities"

Claude: I'll use the README Library Template skill to generate comprehensive
documentation for your logging library.

[Skill analyzes project structure]

Detected library project:
- LoggingUtilities.csproj (OutputType: Library)
- Target framework: net9.0
- Package ID: CompanyName.LoggingUtilities

Generating README.md:

![NuGet](https://img.shields.io/nuget/v/CompanyName.LoggingUtilities)
![Downloads](https://img.shields.io/nuget/dt/CompanyName.LoggingUtilities)
![Build Status](https://img.shields.io/github/actions/workflow/status/user/repo/build.yml)
![License](https://img.shields.io/github/license/user/repo)

# Logging Utilities

> Comprehensive logging extensions and utilities for .NET applications

A powerful .NET library providing advanced logging capabilities including structured
logging, log enrichment, and integration with popular logging frameworks.

## Built With

- C# 13 / .NET 9
- Microsoft.Extensions.Logging abstractions
- No external dependencies beyond .NET BCL

## Getting Started

### Prerequisites

- .NET 9 SDK or higher

### Installation

#### NuGet Package Manager

dotnet add package CompanyName.LoggingUtilities

#### Package Manager Console

Install-Package CompanyName.LoggingUtilities

### Usage

using CompanyName.LoggingUtilities;

// Basic usage
var loggerFactory = LoggerFactory.Create(builder =>
{
    builder.AddConsole();
    builder.AddStructuredLogging(); // Extension from this library
});

var logger = loggerFactory.CreateLogger<MyClass>();
logger.LogInformation("User {UserId} logged in", userId);

// Advanced usage with enrichment
services.AddLogging(builder =>
{
    builder.AddStructuredLogging(options =>
    {
        options.EnrichWithMachineName = true;
        options.EnrichWithEnvironment = true;
        options.MinimumLevel = LogLevel.Information;
    });
});

## API Documentation

### Key Classes

#### StructuredLoggingExtensions

Extension methods for adding structured logging to ILoggingBuilder.

**Methods:**
- `AddStructuredLogging(Action<StructuredLoggingOptions>)` - Configures structured logging
- `AddLogEnricher<T>()` - Adds custom log enricher

#### LogEnricher

Base class for creating custom log enrichers.

**Methods:**
- `Enrich(LogContext context)` - Abstract method to enrich log context

**Properties:**
- `EnricherName` - Unique name for the enricher

### Extension Methods

csharp
// Correlation ID enrichment
logger.WithCorrelationId(correlationId).LogInformation("Processing request");

// Scoped logging context
using (logger.BeginScope(new { UserId = userId, TenantId = tenantId }))
{
    logger.LogInformation("User action");
}

## Building

dotnet build

### Run Tests

dotnet test

### Create NuGet Package

dotnet pack -c Release

## Configuration

Add to appsettings.json:

{
  "StructuredLogging": {
    "MinimumLevel": "Information",
    "EnrichWithMachineName": true,
    "EnrichWithEnvironment": true,
    "EnrichWithThreadId": false
  }
}

## Contributing

Contributions, issues, and feature requests are welcome!

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built with Microsoft.Extensions.Logging
- Inspired by Serilog and NLog structured logging patterns

---

README.md created successfully!

Would you like me to customize any sections? I can add:
- Specific API examples for your use cases
- Performance benchmarks section
- Migration guide from other logging libraries
- Troubleshooting section
```

---

### README Script Template

**Scenario: Generating README for PowerShell Deployment Scripts**

```
User: "Create a README for my Azure deployment PowerShell scripts"

Claude: I'll use the README Script Template skill to generate documentation
for your automation scripts.

[Skill analyzes project structure]

Detected script project:
- Deploy-AzureResources.ps1
- Remove-OldResources.ps1
- Get-ResourceStatus.ps1
- Module manifest: AzureDeployment.psd1

Generating README.md:

![PowerShell Gallery](https://img.shields.io/powershellgallery/v/AzureDeployment)
![Build Status](https://img.shields.io/github/actions/workflow/status/user/repo/test.yml)
![License](https://img.shields.io/github/license/user/repo)

# Azure Deployment Scripts

> Automated Azure resource deployment and management scripts

Comprehensive PowerShell module for deploying and managing Azure resources with
infrastructure as code principles and best practices.

## Built With

- PowerShell 7+
- Azure PowerShell modules (Az.*)
- Pester 5.x for testing

## Getting Started

### Prerequisites

- PowerShell 7 or higher
- Azure PowerShell modules:
  powershell
  Install-Module -Name Az -AllowClobber -Scope CurrentUser

- Azure subscription with Contributor or Owner role
- Azure CLI (optional, for hybrid scenarios)

### Installation

#### PowerShell Gallery

Install-Module -Name AzureDeployment

#### From Source

git clone https://github.com/user/azure-deployment.git
cd azure-deployment
Import-Module ./AzureDeployment.psd1

### Usage

# Connect to Azure
Connect-AzAccount

# Deploy resources
./Deploy-AzureResources.ps1 -ResourceGroup "rg-production" -Location "eastus" -Environment "prod"

# With custom configuration
./Deploy-AzureResources.ps1 -ResourceGroup "rg-production" -ConfigFile "./config.json"

# Check deployment status
./Get-ResourceStatus.ps1 -ResourceGroup "rg-production"

## Parameters

### Deploy-AzureResources.ps1

#### Required Parameters

- `-ResourceGroup`: Name of the Azure resource group to create/use
- `-Location`: Azure region for deployment (e.g., "eastus", "westus2")
- `-Environment`: Environment name (dev, staging, prod)

#### Optional Parameters

- `-ConfigFile`: Path to JSON configuration file (default: ./config.json)
- `-WhatIf`: Preview changes without deploying (default: false)
- `-Verbose`: Enable detailed logging (default: false)
- `-Tags`: Hashtable of tags to apply to resources

### Examples

# Example 1: Basic deployment
./Deploy-AzureResources.ps1 -ResourceGroup "rg-app-prod" -Location "eastus" -Environment "prod"

# Example 2: Preview mode (no actual deployment)
./Deploy-AzureResources.ps1 -ResourceGroup "rg-app-dev" -Location "westus" -Environment "dev" -WhatIf

# Example 3: Custom configuration with tags
./Deploy-AzureResources.ps1 `
    -ResourceGroup "rg-app-staging" `
    -Location "centralus" `
    -Environment "staging" `
    -ConfigFile "./staging-config.json" `
    -Tags @{ CostCenter = "Engineering"; Project = "WebApp" }

# Example 4: Verbose logging
./Deploy-AzureResources.ps1 -ResourceGroup "rg-app-prod" -Location "eastus" -Environment "prod" -Verbose

## Configuration

### Environment Variables

- `AZURE_SUBSCRIPTION_ID`: Target Azure subscription (optional, uses default if not set)
- `AZURE_TENANT_ID`: Azure AD tenant ID (optional)

### Configuration File

Create `config.json` in the script directory:

{
  "resourcePrefix": "app",
  "environment": "prod",
  "appServicePlan": {
    "sku": "P1v3",
    "capacity": 2
  },
  "sqlDatabase": {
    "sku": "S2",
    "maxSizeGB": 250
  },
  "enableMonitoring": true,
  "enableBackup": true
}

### Example Configurations

Development:
{
  "resourcePrefix": "app",
  "environment": "dev",
  "appServicePlan": { "sku": "B1", "capacity": 1 },
  "sqlDatabase": { "sku": "Basic", "maxSizeGB": 2 },
  "enableMonitoring": false
}

Production:
{
  "resourcePrefix": "app",
  "environment": "prod",
  "appServicePlan": { "sku": "P1v3", "capacity": 3 },
  "sqlDatabase": { "sku": "S3", "maxSizeGB": 500 },
  "enableMonitoring": true,
  "enableBackup": true
}

## Testing

# Run all Pester tests
Invoke-Pester

# Run specific test file
Invoke-Pester -Path ./tests/Deploy-AzureResources.Tests.ps1

# Run tests with code coverage
Invoke-Pester -CodeCoverage ./Deploy-AzureResources.ps1

## Troubleshooting

### Common Issues

**Issue**: "Connect-AzAccount: No subscription found"
**Solution**: Run `Connect-AzAccount` and select the correct subscription with `Set-AzContext`

**Issue**: "Insufficient permissions to create resource group"
**Solution**: Ensure your account has Contributor or Owner role on the subscription

**Issue**: "Resource already exists"
**Solution**: Use `-WhatIf` to preview, or delete existing resources first

## Contributing

Contributions welcome! Please read CONTRIBUTING.md for details.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

MIT License - see [LICENSE](LICENSE) for details.

## Author

Your Name - [@yourtwitter](https://twitter.com/yourtwitter)

---

README.md created successfully!

Would you like me to add:
- Detailed troubleshooting guide for Azure-specific errors?
- Rollback procedures for failed deployments?
- Multi-region deployment examples?
- CI/CD integration guidance?
```

---

## Summary

This document demonstrates realistic usage scenarios for all 7 agents and 2 skills in the Claude .NET Plugin:

**Primary Agents** provide specialized guidance for:
- Modern .NET 9/C# 13 development (dotnet-csharp-expert)
- Azure cloud architecture and cost optimization (dotnet-azure-architect)
- Azure DevOps CI/CD pipelines (dotnet-azure-devops)
- Git workflows and conventional commits (dotnet-git-manager)

**Meta Agents** assist with:
- Creating new specialized agents (dotnet-agent-expert)
- Maintaining README documentation (dotnet-readme-maintainer)
- Designing MCP integrations (dotnet-mcp-expert)

**Skills** auto-generate documentation for:
- Library/package projects with API docs (README Library Template)
- Script/automation projects with usage examples (README Script Template)

Each agent activates automatically based on context, providing expert guidance tailored to your specific .NET development needs.
