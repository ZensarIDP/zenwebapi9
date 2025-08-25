# .NET Application Setup Script for Windows
# This script helps set up your local development environment

Write-Host "🚀 Setting up .NET Application Development Environment" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green

# Check if .NET is installed
try {
    $dotnetVersion = dotnet --version
    Write-Host "✅ .NET SDK found: $dotnetVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ .NET SDK not found. Please install .NET 8.0 SDK" -ForegroundColor Red
    Write-Host "   Download from: https://dotnet.microsoft.com/download" -ForegroundColor Yellow
    exit 1
}

# Check if Docker is installed
try {
    $dockerVersion = docker --version
    Write-Host "✅ Docker found: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker not found. Please install Docker Desktop" -ForegroundColor Red
    Write-Host "   Download from: https://docs.docker.com/desktop/windows/" -ForegroundColor Yellow
    exit 1
}

# Check if gcloud is installed
try {
    $gcloudVersion = gcloud --version | Select-Object -First 1
    Write-Host "✅ Google Cloud CLI found: $gcloudVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Google Cloud CLI not found. Please install gcloud" -ForegroundColor Red
    Write-Host "   Download from: https://cloud.google.com/sdk/docs/install" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "🔧 Environment Setup Complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Add your .NET application code to this repository"
Write-Host "2. Ensure your app listens on port 8080"
Write-Host "3. Implement health check endpoint at /health"
Write-Host "4. Test locally with: dotnet run"
Write-Host "5. Push to main branch to trigger deployment"
Write-Host ""
Write-Host "📚 Documentation:" -ForegroundColor Cyan
Write-Host "- Health Check Guide: docs/HEALTH_CHECK.md"
Write-Host "- Database Setup: docs/DATABASE_SETUP.md"
Write-Host "- Template Guide: docs/TEMPLATE_GUIDE.md"
Write-Host ""
Write-Host "🔑 Required GitHub Secrets:" -ForegroundColor Cyan
Write-Host "- GCP_PROJECT_ID: Your Google Cloud Project ID"
Write-Host "- GCP_REGION: Your Google Cloud Region"
Write-Host "- GCP_SA_KEY: Base64 encoded service account key"
