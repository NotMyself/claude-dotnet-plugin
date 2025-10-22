---
name: README Library Template
description: Generate README.md for library/package projects. ONLY trigger when user explicitly mentions library/package context such as "library", "package", "NuGet", "npm package", "SDK", or "API documentation". Also triggers when README.md is missing AND project structure indicates library (*.csproj with OutputType=Library, package.json without bin entry, .nuspec files). DO NOT trigger on generic "create README" without library/package context.
allowed-tools:
  - Write
  - Read
  - Glob
---

# Library Project README Template Skill

Generates comprehensive README.md files for library projects with standard sections and best practices formatting.

## Trigger Scenarios

### Explicit Requests
- "create README for library"
- "generate documentation for this library"
- "add README to this library project"
- "I need a README for my NuGet package"
- "create README.md"

### Missing README Detection
- User in project root directory
- No README.md file present
- Project structure indicates library:
  - `*.csproj` with `<OutputType>Library</OutputType>`
  - `package.json` without "bin" entry
  - Presence of library-specific files (`.nuspec`, `Directory.Build.props`)

### Project Initialization
- User creates new library project: `dotnet new classlib`
- User initializes git repository in library project
- User discusses project documentation needs
- User mentions "library" or "package" in context of new project

## Implementation

When triggered, generate README.md with these sections:

### 1. Title and Badges
```markdown
[appropriate badges for build status, version, license, downloads]

# Project Name

> One paragraph statement about the library's purpose.

Additional description about the library's features and capabilities.
```

### 2. Built With
```markdown
## Built With

- C# / .NET 9
- Major frameworks or dependencies
- Technologies used
```

### 3. Getting Started

```markdown
## Getting Started

### Prerequisites

- .NET 9 SDK or higher
- Any additional requirements

### Installation

#### NuGet
\`\`\`bash
dotnet add package {PackageName}
\`\`\`

#### Package Manager Console
\`\`\`powershell
Install-Package {PackageName}
\`\`\`

### Usage

\`\`\`csharp
using {Namespace};

// Basic usage example
var service = new {ClassName}();
var result = service.DoSomething();
\`\`\`
```

### 4. API Documentation
```markdown
## API Documentation

### Key Classes

#### {ClassName}

Description of main class.

**Methods:**
- `MethodName(param1, param2)` - Description
- `AnotherMethod()` - Description

**Properties:**
- `PropertyName` - Description
```

### 5. Building and Testing
```markdown
## Building

\`\`\`bash
dotnet build
\`\`\`

### Run Tests

\`\`\`bash
dotnet test
\`\`\`

### Create NuGet Package

\`\`\`bash
dotnet pack -c Release
\`\`\`
```

### 6. Contributing and License
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

1. "What is the main purpose of your library?"
2. "What are the key features or capabilities?"
3. "Are there any specific prerequisites or dependencies?"
4. "Would you like to add specific API examples?"
5. "Do you need additional sections (e.g., Configuration, Advanced Usage, FAQ)?"

## File Detection Logic

To determine if project is a library:

1. Check for `*.csproj` files with `<OutputType>Library</OutputType>`
2. Check for `package.json` without executable configuration
3. Look for `.nuspec` or NuGet-related files
4. Check for `Directory.Build.props` with library settings
5. Absence of `Program.cs` or `Main` entry point

## Example Output

```markdown
![Build Status](https://img.shields.io/github/actions/workflow/status/user/repo/build.yml)
![NuGet](https://img.shields.io/nuget/v/PackageName)
![License](https://img.shields.io/github/license/user/repo)

# MyAwesomeLibrary

> A powerful .NET library for advanced data processing and transformation.

MyAwesomeLibrary provides a comprehensive set of tools for working with complex data structures, offering high-performance algorithms and intuitive APIs.

## Built With

- C# 13 / .NET 9
- No external dependencies
- Cross-platform compatible

## Getting Started

### Prerequisites

- .NET 9 SDK or higher

### Installation

#### NuGet
\`\`\`bash
dotnet add package MyAwesomeLibrary
\`\`\`

### Usage

\`\`\`csharp
using MyAwesomeLibrary;

var processor = new DataProcessor();
var result = processor.Transform(inputData);
\`\`\`

## API Documentation

### DataProcessor

Main class for data processing operations.

**Methods:**
- `Transform(data)` - Transforms input data using configured rules
- `Validate(data)` - Validates data against schema

**Properties:**
- `Options` - Configuration options for processing

## Building

\`\`\`bash
dotnet build
\`\`\`

### Run Tests

\`\`\`bash
dotnet test
\`\`\`

### Create NuGet Package

\`\`\`bash
dotnet pack -c Release
\`\`\`

## 🤝 Contributing

Contributions welcome! Please read CONTRIBUTING.md for details.

## 📝 License

MIT License - see [LICENSE](LICENSE) for details.
```
