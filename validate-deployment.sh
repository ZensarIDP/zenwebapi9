#!/bin/bash

# .NET Template Deployment Validation Script
# This script validates that all components are properly configured

set -e

echo "🔍 .NET Template Deployment Validation"
echo "======================================"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    if [ $2 -eq 0 ]; then
        echo -e "${GREEN}✅ $1${NC}"
    else
        echo -e "${RED}❌ $1${NC}"
    fi
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Check if we're in a .NET project
echo "Checking .NET project structure..."
if [ -f "*.sln" ] || [ -f "*.csproj" ] || find . -name "*.csproj" -type f | grep -q .; then
    print_status "Found .NET project files" 0
else
    print_status "No .NET project files found" 1
    exit 1
fi

# Check Docker configuration
echo "Checking Docker configuration..."
if [ -f "Dockerfile" ]; then
    print_status "Dockerfile present" 0
    
    # Validate Dockerfile for multi-project support
    if grep -q "find . -name '\*.dll'" Dockerfile; then
        print_status "Multi-project support configured" 0
    else
        print_warning "Multi-project support not detected in Dockerfile"
    fi
else
    print_status "Dockerfile missing" 1
fi

# Check GitHub Actions workflows
echo "Checking CI/CD configuration..."
if [ -d ".github/workflows" ]; then
    print_status ".github/workflows directory present" 0
    
    if [ -f ".github/workflows/deploy.yml" ]; then
        print_status "Deployment workflow present" 0
    else
        print_status "Deployment workflow missing" 1
    fi
    
    if [ -f ".github/workflows/infra-provisioning.yml" ]; then
        print_status "Infrastructure workflow present" 0
    else
        print_warning "Infrastructure workflow missing (optional)"
    fi
else
    print_status "GitHub Actions workflows missing" 1
fi

# Check Kubernetes manifests
echo "Checking Kubernetes configuration..."
if [ -d "k8s" ]; then
    print_status "Kubernetes manifests directory present" 0
    
    if [ -f "k8s/deployment.yaml" ] && [ -f "k8s/service.yaml" ]; then
        print_status "Kubernetes manifests present" 0
    else
        print_status "Kubernetes manifests incomplete" 1
    fi
else
    print_warning "Kubernetes manifests missing (required for GKE deployment)"
fi

# Check Terraform configuration
echo "Checking Infrastructure as Code..."
if [ -d "terraform" ]; then
    print_status "Terraform directory present" 0
    
    if [ -f "terraform/main.tf" ]; then
        print_status "Terraform configuration present" 0
    else
        print_status "Terraform main configuration missing" 1
    fi
else
    print_warning "Terraform configuration missing (optional)"
fi

# Check documentation
echo "Checking documentation..."
if [ -f "README.md" ]; then
    print_status "README.md present" 0
else
    print_status "README.md missing" 1
fi

if [ -f "DEPLOYMENT.md" ] || [ -f "DEPLOYMENT-GUIDE.md" ]; then
    print_status "Deployment guide present" 0
else
    print_warning "Deployment guide missing"
fi

# Check Backstage integration
echo "Checking Backstage integration..."
if [ -f "catalog-info.yaml" ]; then
    print_status "Backstage catalog integration present" 0
else
    print_status "Backstage catalog integration missing" 1
fi

echo ""
echo "🏁 Validation Summary"
echo "===================="

# Count .NET projects
PROJECT_COUNT=$(find . -name "*.csproj" -type f | wc -l)
echo "📁 .NET Projects found: $PROJECT_COUNT"

if [ $PROJECT_COUNT -gt 1 ]; then
    print_warning "Multi-project solution detected - ensure Dockerfile handles multiple projects"
fi

# Check for common .NET project types
if find . -name "*.csproj" -exec grep -l "Microsoft.AspNetCore" {} \; | grep -q .; then
    echo "🌐 ASP.NET Core Web application detected"
elif find . -name "*.csproj" -exec grep -l "Microsoft.NET.Sdk.Web" {} \; | grep -q .; then
    echo "🌐 Web application detected"
else
    echo "📦 Console/Library application detected"
fi

echo ""
echo "📋 Next Steps:"
echo "1. Configure GitHub repository secrets:"
echo "   - GCP_PROJECT_ID"
echo "   - GCP_REGION" 
echo "   - GCP_SA_KEY"
echo ""
echo "2. Push code to main branch to trigger deployment"
echo ""
echo "3. Monitor GitHub Actions for deployment status"
echo ""
echo "4. Check Cloud Run or GKE console for service status"

# Exit with error if critical components are missing
if [ ! -f "Dockerfile" ] || [ ! -d ".github/workflows" ] || [ ! -f "catalog-info.yaml" ]; then
    echo ""
    print_status "Validation completed with errors - please fix missing components" 1
    exit 1
else
    echo ""
    print_status "Validation completed successfully - ready for deployment!" 0
    exit 0
fi
