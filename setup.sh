#!/bin/bash

# .NET Application Setup Script
# This script helps set up your local development environment

echo "🚀 Setting up .NET Application Development Environment"
echo "=================================================="

# Check if .NET is installed
if command -v dotnet &> /dev/null; then
    echo "✅ .NET SDK found: $(dotnet --version)"
else
    echo "❌ .NET SDK not found. Please install .NET 8.0 SDK"
    echo "   Download from: https://dotnet.microsoft.com/download"
    exit 1
fi

# Check if Docker is installed
if command -v docker &> /dev/null; then
    echo "✅ Docker found: $(docker --version)"
else
    echo "❌ Docker not found. Please install Docker"
    echo "   Download from: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if gcloud is installed
if command -v gcloud &> /dev/null; then
    echo "✅ Google Cloud CLI found: $(gcloud --version | head -n 1)"
else
    echo "❌ Google Cloud CLI not found. Please install gcloud"
    echo "   Download from: https://cloud.google.com/sdk/docs/install"
    exit 1
fi

echo ""
echo "🔧 Environment Setup Complete!"
echo ""
echo "Next steps:"
echo "1. Add your .NET application code to this repository"
echo "2. Ensure your app listens on port 8080"
echo "3. Implement health check endpoint at /health"
echo "4. Test locally with: dotnet run"
echo "5. Push to main branch to trigger deployment"
echo ""
echo "📚 Documentation:"
echo "- Health Check Guide: docs/HEALTH_CHECK.md"
echo "- Database Setup: docs/DATABASE_SETUP.md"
echo "- Template Guide: docs/TEMPLATE_GUIDE.md"
echo ""
echo "🔑 Required GitHub Secrets:"
echo "- GCP_PROJECT_ID: Your Google Cloud Project ID"
echo "- GCP_REGION: Your Google Cloud Region"  
echo "- GCP_SA_KEY: Base64 encoded service account key"
