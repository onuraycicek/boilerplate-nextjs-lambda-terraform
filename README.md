# AWS Infrastructure Template

A production-ready boilerplate for deploying Next.js applications with AWS infrastructure using Terraform. This template provides a complete setup for both staging and production environments with CDN, serverless functions, and SSL certificates.

## 🌟 Features

- **Frontend**
  - Next.js static website hosting on S3
  - CloudFront CDN with custom domain
  - Automatic SSL certificate management
  - Optimized caching strategies

- **Backend**
  - Serverless Lambda functions
  - Python runtime support
  - Custom CloudFront functions
  - Extensible module structure

- **Infrastructure**
  - Multi-environment setup (staging/production)
  - Infrastructure as Code with Terraform
  - Automated deployment pipelines
  - Cost-effective serverless architecture

## 📋 Prerequisites

1. **AWS Setup**
   - AWS CLI installed and configured
   - Appropriate IAM permissions for resource creation
   - AWS credentials configured locally

2. **Development Tools**
   - Terraform >= 1.0.0
   - Node.js >= 16
   - Python >= 3.12 (for Lambda functions)

3. **Domain Requirements**
   - Registered domain name
   - Access to DNS management

## 🚀 Quick Start

1. **Clone and Setup**
   ```bash
   # Clone the repository
   git clone git@github.com:onuraycicek/boilerplate-nextjs-lambda-terraform.git
   cd boilerplate-nextjs-lambda-terraform

   # Install dependencies
   make install
   ```

2. **Configure Environment Variables**
   ```bash
   # Copy example variables for your environment
   cp infra/environments/terraform.tfvars.example infra/environments/staging/terraform.tfvars
   cp infra/environments/terraform.tfvars.example infra/environments/prod/terraform.tfvars

   # Edit the terraform.tfvars files with your values
   ```

3. **Deploy Infrastructure**
   ```bash
   # For staging environment
   make deploy-staging
   make deploy-frontend-staging

   # For production environment
   make deploy-prod
   make deploy-frontend-prod
   ```

## 🏗️ Project Structure

```
.
├── apps/
│   ├── frontend/              # Next.js application
│   │   ├── src/              # Frontend source code
│   │   └── public/           # Static assets
│   └── backend/
│       └── functions/        # Lambda functions
│           ├── hello-world/  # Example function
│           └── custom-func/  # Your custom functions
├── infra/
│   ├── modules/              # Terraform modules
│   │   ├── acm/             # SSL certificate management
│   │   ├── cloudfront/      # CDN distribution
│   │   ├── lambda/          # Serverless functions
│   │   └── s3/              # Static website hosting
│   └── environments/        # Environment configurations
│       ├── terraform.tfvars.example  # Example variables
│       ├── staging/         # Staging environment
│       └── prod/           # Production environment
└── Makefile                # Deployment commands
```

## 🔧 Configuration

### Environment Variables

Edit `terraform.tfvars` in your environment directory:

```hcl
# Required variables
aws_region    = "us-east-1"              # AWS Region
domain_name   = "your-domain.com"        # Your domain
company_name  = "Your Company"           # Company name
environment   = "prod"                   # Environment name

# Optional
# project_name = "my-project"            # Defaults to domain name
```

## 🛠️ Managing Lambda Functions

### Adding a New Function

1. **Create Function Directory**
   ```bash
   mkdir -p apps/backend/functions/your-function-name/src
   ```

2. **Add Function Code**
   ```python
   # apps/backend/functions/your-function-name/src/lambda_function.py
   def lambda_handler(event, context):
       return {
           'statusCode': 200,
           'body': 'Hello from your new function!'
       }
   ```

3. **Add to Terraform Configuration**
   ```hcl
   # infra/environments/[env]/main.tf
   module "your_function" {
     source = "../../modules/lambda"
     
     function_name = "${local.name_prefix}-your-function"
     source_dir    = "../../../apps/backend/functions/your-function-name/src"
     runtime       = "python3.12"
     handler       = "lambda_function.lambda_handler"
     
     tags = local.common_tags
   }
   ```

### Removing a Function

1. Remove the module block from your Terraform configuration
2. Run `make tf-plan-[env]` to verify changes
3. Apply changes with `make tf-apply-[env]`
4. Optionally remove the function code directory

## 📝 Available Commands

### Infrastructure Management
- `make deploy-staging`: Deploy to staging
- `make deploy-prod`: Deploy to production
- `make destroy-staging`: Destroy staging environment
- `make destroy-prod`: Destroy production environment

### Development
- `make dev`: Run development environment
- `make build`: Build the application
- `make clean`: Clean build artifacts

### Deployment
- `make deploy-frontend-staging`: Deploy frontend to staging
- `make deploy-frontend-prod`: Deploy frontend to production
- `make verify-deploy`: Verify deployment status

### Certificate Management
- `make create-cert-staging`: Create staging SSL certificate
- `make create-cert-prod`: Create production SSL certificate
- `make show-dns-records`: Show DNS validation records

## 🔍 Monitoring and Maintenance

### Health Checks
- Monitor CloudFront distribution status
- Check Lambda function logs in CloudWatch
- Verify S3 bucket accessibility

### Cost Management
- Resources are tagged for cost tracking
- Use AWS Cost Explorer to monitor expenses
- Set up billing alarms for cost control

## 🔒 Security Best Practices

1. **Access Control**
   - Use IAM roles with least privilege
   - Regularly rotate AWS credentials
   - Enable MFA for AWS users

2. **Data Protection**
   - SSL/TLS encryption in transit
   - S3 bucket policies for access control
   - CloudFront security headers

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📚 Additional Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS Lambda Documentation](https://docs.aws.amazon.com/lambda)
- [Next.js Documentation](https://nextjs.org/docs)

## ⚠️ Important Notes

- Always test changes in staging before production
- Keep your dependencies updated
- Regularly backup your Terraform state
- Monitor AWS costs and resource usage
- Follow security best practices for AWS resources