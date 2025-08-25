# .NET Application Configuration

This file contains the deployment configuration for your .NET application.

## Deployment Configuration

- **Application Name**: zenwebapi9
- **Cloud Provider**: gcp
- **Deployment Type**: gke
- **Region**: asia-south1
- **GKE Cluster**: zenhotel-cluster
- **Namespace**: default
## Infrastructure Configuration

- **Infrastructure Provisioning**: Enabled
- **Database Type**: mysql
- **Database Name**: app_db
- **Database Username**: app_user

## Required GitHub Secrets

Make sure the following secrets are configured in your GitHub repository:

- `GCP_PROJECT_ID`: Your Google Cloud Project ID
- `GCP_REGION`: Your Google Cloud Region  
- `GCP_SA_KEY`: Base64 encoded service account key with necessary permissions

## Getting Started

1. Clone this repository
2. Add your .NET application code (Web API or Web App)
3. Ensure your application listens on port 8080
4. Push to the `main` branch to trigger deployment

## Application Requirements

Your .NET application should:

- Listen on port 8080 (configured via `ASPNETCORE_URLS` environment variable)
- Include a health check endpoint at `/health` (for GKE deployments)
- Be ready for containerization (no specific host dependencies)

## Database Connection (if enabled)
The database connection string will be available as an environment variable:
- `ConnectionStrings__DefaultConnection`

For GKE deployments, this will be injected via Kubernetes secrets.
For Cloud Run deployments, you can set this as an environment variable.
