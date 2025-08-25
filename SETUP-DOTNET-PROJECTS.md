# zenwebapi9 Solution

This is a placeholder solution file. Replace this with your actual .NET solution file structure.

## Adding Your .NET Projects

1. **Remove this file** and add your actual solution file (`.sln`)
2. **Add your project directories** containing `.csproj` files
3. **Update the solution file** to reference all your projects
4. **Ensure one project is marked as the startup project** for the web application

## Multi-Project Structure Example

```
zenwebapi9/
├── zenwebapi9.sln
├── src/
│   ├── zenwebapi9.Api/
│   │   └── zenwebapi9.Api.csproj
│   ├── zenwebapi9.Core/
│   │   └── zenwebapi9.Core.csproj
│   └── zenwebapi9.Infrastructure/
│       └── zenwebapi9.Infrastructure.csproj
└── tests/
    └── zenwebapi9.Tests/
        └── zenwebapi9.Tests.csproj
```

## Docker Build

The included Dockerfile is designed to:
- Copy all files (including multiple projects)
- Run `dotnet restore` to restore all project dependencies
- Run `dotnet publish` which will automatically detect and build the startup project
- Create a runtime image with the published output

## GitHub Actions

The CI/CD workflow will:
- Build the Docker image with your multi-project solution
- Push to Google Container Registry
- Deploy to your selected target (Cloud Run or GKE)
