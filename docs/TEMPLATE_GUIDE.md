# .NET Template Usage Guide

This template creates a .NET application repository with automated CI/CD pipeline and optional infrastructure provisioning.

## Template Features

### ✅ Deployment Options
- **Cloud Run**: Serverless deployment with automatic scaling
- **Google Kubernetes Engine (GKE)**: Container orchestration with full control

### ✅ Infrastructure Provisioning (Optional)
- **MySQL** or **PostgreSQL** database
- Terraform-based infrastructure as code
- Cost-optimized configurations for PoC/Demo purposes

### ✅ CI/CD Pipeline
- **Build**: Docker image creation and push to Google Container Registry
- **Deploy**: Automatic deployment to selected target (Cloud Run or GKE)
- **Infrastructure**: Terraform-based database provisioning (if enabled)

## Quick Start

1. **Use the Template**: Select the ".NET Application" template in Backstage
2. **Configure Options**: Choose your deployment type and infrastructure needs
3. **Create Repository**: The template will create a GitHub repository with all configurations
4. **Add Your Code**: Clone the repository and add your .NET application
5. **Deploy**: Push to main branch to trigger automatic deployment

## Template Configuration Options

### Application Information
- **Name**: Unique identifier for your application
- **Description**: Brief description of your application
- **Owner**: Team or individual responsible for the application

### Cloud Configuration
- **Cloud Provider**: Google Cloud Platform (GCP) - only option currently
- **Deployment Type**: 
  - Cloud Run (recommended for web apps and APIs)
  - GKE (for complex applications requiring Kubernetes features)

### Deployment Configuration
- **Region**: Select from available GCP regions
- **GKE Options** (if GKE selected):
  - Cluster name (default: zenhotel-cluster)
  - Namespace (default: default)

### Infrastructure Provisioning (Optional)
- **Enable/Disable**: Choose whether to provision infrastructure
- **Database Type**: MySQL or PostgreSQL
- **Database Configuration**: Name and username settings

## What Gets Created

### Repository Structure
```
your-app/
├── .github/workflows/          # CI/CD pipelines
│   ├── infra-provisioning.yml  # Infrastructure setup
│   └── deploy.yml              # Application deployment
├── k8s/                        # Kubernetes manifests (if GKE)
│   ├── deployment.yaml
│   └── service.yaml
├── terraform/                  # Infrastructure as code (if enabled)
│   └── main.tf
├── docs/                       # Documentation
│   ├── HEALTH_CHECK.md
│   └── DATABASE_SETUP.md
├── Dockerfile                  # Container configuration
├── DEPLOYMENT.md               # Deployment guide
└── README.md                   # Project documentation
```

### GitHub Actions Workflows

1. **Infrastructure Provisioning** (`infra-provisioning.yml`)
   - Triggers on repository creation
   - Uses Terraform to provision database (if enabled)
   - Outputs connection details securely

2. **Application Deployment** (`deploy.yml`)
   - Triggers on push to main branch
   - Builds Docker image
   - Deploys to Cloud Run or GKE based on configuration

## Prerequisites

### GitHub Repository Secrets
Ensure these secrets are configured in your GitHub repository:

- `GCP_PROJECT_ID`: Your Google Cloud Project ID
- `GCP_REGION`: Your Google Cloud Region
- `GCP_SA_KEY`: Base64 encoded service account key

### Service Account Permissions
Your GCP service account needs these permissions:

- Cloud Run Admin (for Cloud Run deployments)
- Kubernetes Engine Admin (for GKE deployments)
- Cloud SQL Admin (for database provisioning)
- Artifact Registry Admin (for container images)
- Compute Admin (for networking)

## Application Requirements

Your .NET application should meet these requirements:

### Port Configuration
```csharp
// In Program.cs
app.UseUrls("http://+:8080");
// Or set via environment variable
Environment.SetEnvironmentVariable("ASPNETCORE_URLS", "http://+:8080");
```

### Health Check Endpoint (Required for GKE)
```csharp
// Add health checks
builder.Services.AddHealthChecks();

// Map health check endpoint
app.MapHealthChecks("/health");
```

### Database Configuration (If using provisioned database)
```csharp
// Connection string will be provided via environment variables
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
```

## Deployment Process

### First Time Setup
1. Clone the generated repository
2. Add your .NET application code
3. Ensure your app meets the requirements above
4. Push to main branch

### Infrastructure Provisioning (If Enabled)
- Runs automatically on repository creation
- Creates database instance with minimal cost configuration
- Stores connection details securely

### Application Deployment
- Builds Docker image using provided Dockerfile
- Pushes to Google Container Registry
- Deploys to configured target (Cloud Run or GKE)

## Cost Optimization

The template is configured for cost-effective PoC/Demo usage:

### Database
- **Tier**: `db-f1-micro` (shared-core, cheapest option)
- **Disk**: `PD_HDD` (cheapest disk type)
- **Size**: 10GB minimum
- **Backups**: Disabled
- **High Availability**: Disabled

### Cloud Run
- **Memory**: 512Mi
- **CPU**: 1
- **Min Instances**: 0 (scales to zero)
- **Max Instances**: 10

### GKE
- Uses existing cluster (`zenhotel-cluster`)
- Resource limits configured for minimal usage

## Troubleshooting

### Common Issues

1. **Build Failures**
   - Ensure Dockerfile is compatible with your .NET version
   - Check that all dependencies are properly restored

2. **Deployment Failures**
   - Verify GitHub secrets are correctly configured
   - Check service account permissions
   - Ensure GKE cluster exists (for GKE deployments)

3. **Database Connection Issues**
   - Verify infrastructure provisioning completed successfully
   - Check connection string format for your database type
   - Ensure firewall rules allow connections

### Getting Help

- Check GitHub Actions logs for detailed error messages
- Review the generated documentation in your repository
- Verify your application meets the requirements outlined above

## Next Steps

After successful deployment:

1. **Monitor**: Use GCP Console to monitor your application
2. **Scale**: Adjust resource limits based on actual usage
3. **Secure**: Review and tighten security configurations for production
4. **Optimize**: Monitor costs and optimize resources as needed

## Production Considerations

This template is optimized for PoC/Demo usage. For production deployments:

- Enable database backups and high availability
- Configure proper monitoring and alerting
- Implement proper security measures
- Set up proper DNS and SSL certificates
- Configure appropriate resource limits and scaling policies
