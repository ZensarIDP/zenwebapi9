# Multi-stage build for .NET applications with multiple projects
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /src

# Copy solution file and all project files
# This supports both single project and multi-project solutions
COPY . .

# Restore dependencies for all projects in the solution
RUN dotnet restore

# Build and publish the application
# This will automatically detect the startup project (usually a web project)
# For multi-project solutions, ensure your startup project is properly configured
RUN dotnet publish -c Release -o /app/publish --no-restore

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app/publish .

# Expose port
EXPOSE 8080

# Set environment variables
ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production

# Start the application - find the main executable DLL
ENTRYPOINT ["sh", "-c", "dotnet $(find . -name '*.dll' -not -path './runtimes/*' | head -1)"]
