# Health Check Implementation Guide

To ensure your .NET application works correctly with the deployment pipeline, you should implement a health check endpoint.

## For ASP.NET Core Web API

Add this to your `Program.cs` or `Startup.cs`:

```csharp
// Add health checks service
builder.Services.AddHealthChecks();

// Configure the app
var app = builder.Build();

// Map health check endpoint
app.MapHealthChecks("/health");
```

## For ASP.NET Core Web App (MVC)

Add this to your `Program.cs`:

```csharp
// Add health checks service
builder.Services.AddHealthChecks();

// Configure the app
var app = builder.Build();

// Map health check endpoint
app.MapHealthChecks("/health");

// Your existing MVC configuration
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");
```

## Custom Health Check (Optional)

For more advanced health checks, you can create a custom implementation:

```csharp
public class DatabaseHealthCheck : IHealthCheck
{
    private readonly IDbConnection _connection;

    public DatabaseHealthCheck(IDbConnection connection)
    {
        _connection = connection;
    }

    public async Task<HealthCheckResult> CheckHealthAsync(
        HealthCheckContext context,
        CancellationToken cancellationToken = default)
    {
        try
        {
            await _connection.OpenAsync(cancellationToken);
            return HealthCheckResult.Healthy("Database connection is healthy.");
        }
        catch (Exception ex)
        {
            return HealthCheckResult.Unhealthy(
                "Database connection failed.", ex);
        }
    }
}

// Register in Program.cs
builder.Services.AddHealthChecks()
    .AddCheck<DatabaseHealthCheck>("database");
```

## Required NuGet Packages

Add this package to your project:

```xml
<PackageReference Include="Microsoft.Extensions.Diagnostics.HealthChecks" Version="8.0.0" />
```

For database health checks:

```xml
<PackageReference Include="Microsoft.Extensions.Diagnostics.HealthChecks.EntityFrameworkCore" Version="8.0.0" />
```

## Configuration for Different Environments

```csharp
// Configure health checks for different environments
if (app.Environment.IsDevelopment())
{
    app.MapHealthChecks("/health", new HealthCheckOptions
    {
        ResponseWriter = async (context, report) =>
        {
            context.Response.ContentType = "application/json";
            var response = new
            {
                status = report.Status.ToString(),
                checks = report.Entries.Select(x => new
                {
                    name = x.Key,
                    status = x.Value.Status.ToString(),
                    description = x.Value.Description
                })
            };
            await context.Response.WriteAsync(JsonSerializer.Serialize(response));
        }
    });
}
else
{
    // Simple health check for production
    app.MapHealthChecks("/health");
}
```
