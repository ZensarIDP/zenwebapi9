# Database Configuration Guide
This guide shows how to configure your .NET application to use the provisioned database.

## Database Details

- **Type**: Mysql
- **Database Name**: app_db
- **Username**: app_user

## Connection Configuration

### appsettings.json

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=YOUR_HOST;Database=app_db;Uid=app_user;Pwd=YOUR_PASSWORD;"
  }
}
```

### Program.cs Configuration

#### For MySQL:

```csharp
// Add this NuGet package: MySql.EntityFrameworkCore
using Microsoft.EntityFrameworkCore;

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseMySQL(connectionString));
```

#### For PostgreSQL:

```csharp
// Add this NuGet package: Npgsql.EntityFrameworkCore.PostgreSQL
using Microsoft.EntityFrameworkCore;

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseNpgsql(connectionString));
```

## Required NuGet Packages

### MySQL:
```xml
<PackageReference Include="MySql.EntityFrameworkCore" Version="8.0.0" />
```

### PostgreSQL:
```xml
<PackageReference Include="Npgsql.EntityFrameworkCore.PostgreSQL" Version="8.0.0" />
```

## DbContext Example

```csharp
public class ApplicationDbContext : DbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
    }

    // Your DbSets here
    public DbSet<User> Users { get; set; }
    
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // Your model configuration
        base.OnModelCreating(modelBuilder);
    }
}
```

## Environment Variables

The deployment pipeline will set up the connection string automatically:
- **GKE**: Connection string will be injected via Kubernetes secrets

## Database Migrations

To run migrations during deployment, add this to your `Program.cs`:

```csharp
// Auto-migrate database on startup (for simple scenarios)
using (var scope = app.Services.CreateScope())
{
    var context = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
    context.Database.Migrate();
}
```

For production environments, consider running migrations separately from application startup.
