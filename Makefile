.PHONY: install dev build clean tf-init-prod tf-plan-prod tf-apply-prod tf-init-staging tf-plan-staging tf-apply-staging deploy-prod deploy-staging destroy-prod destroy-staging verify-deploy show-dns-records create-cert-staging create-cert-prod enable-cloudfront-staging enable-cloudfront-prod deploy-frontend-staging deploy-frontend-prod

# Frontend deployment commands
deploy-frontend-staging: build
	@echo "Deploying frontend to staging S3 bucket..."
	$(eval BUCKET_NAME=$(shell cd infra/environments/staging && terraform output -raw s3_bucket_name))
	cd apps/frontend/out && aws s3 sync . s3://$(BUCKET_NAME)
	@echo "Frontend deployed to staging!"

deploy-frontend-prod: build
	@echo "Deploying frontend to production S3 bucket..."
	$(eval BUCKET_NAME=$(shell cd infra/environments/prod && terraform output -raw s3_bucket_name))
	cd apps/frontend/out && aws s3 sync . s3://$(BUCKET_NAME)
	@echo "Frontend deployed to production!"

# Certificate management commands
create-cert-staging:
	@echo "Creating ACM certificate for staging..."
	cd infra/environments/staging && terraform init && terraform apply -target=module.acm -auto-approve
	@echo "\nPlease add the following DNS records to your DNS settings:"
	@cd infra/environments/staging && terraform output -json acm_validation_records
	@echo "\nAfter adding DNS records and validating the certificate, run 'make enable-cloudfront-staging'"

create-cert-prod:
	@echo "Creating ACM certificate for production..."
	cd infra/environments/prod && terraform init && terraform apply -target=module.acm -auto-approve
	@echo "\nPlease add the following DNS records to your DNS settings:"
	@cd infra/environments/prod && terraform output -json acm_validation_records
	@echo "\nAfter adding DNS records and validating the certificate, run 'make enable-cloudfront-prod'"

enable-cloudfront-staging:
	@echo "Enabling CloudFront for staging..."
	@echo "First, uncomment the CloudFront module in infra/environments/staging/main.tf"
	@echo "Then run: make deploy-staging"

enable-cloudfront-prod:
	@echo "Enabling CloudFront for production..."
	@echo "First, uncomment the CloudFront module in infra/environments/prod/main.tf"
	@echo "Then run: make deploy-prod"

# Node.js commands
install:
	npm install

dev:
	npx turbo run dev

build:
	npx turbo run build

clean:
	rm -rf node_modules
	rm -rf .turbo
	find . -name "dist" -type d -exec rm -rf {} +
	find . -name ".next" -type d -exec rm -rf {} +
	find . -name "__pycache__" -type d -exec rm -rf {} +

# Terraform commands for production
tf-init-prod:
	cd infra/environments/prod && terraform init

tf-plan-prod:
	cd infra/environments/prod && terraform plan

tf-apply-prod:
	cd infra/environments/prod && terraform apply -auto-approve

tf-destroy-prod:
	cd infra/environments/prod && terraform destroy -auto-approve

# Terraform commands for staging
tf-init-staging:
	cd infra/environments/staging && terraform init

tf-plan-staging:
	cd infra/environments/staging && terraform plan

tf-apply-staging:
	cd infra/environments/staging && terraform apply -auto-approve

tf-destroy-staging:
	cd infra/environments/staging && terraform destroy -auto-approve

# Combined commands
tf-init-all: tf-init-prod tf-init-staging
tf-plan-all: tf-plan-prod tf-plan-staging
tf-apply-all: tf-apply-prod tf-apply-staging
tf-destroy-all: tf-destroy-prod tf-destroy-staging

# Deploy commands
deploy-prod: install build tf-init-prod tf-apply-prod
	@echo "Production deployment completed!"
	@echo "Please verify the following:"
	@echo "1. Frontend is accessible"
	@echo "2. Lambda functions are working"
	@echo "3. CloudFront distribution is active"
	@echo "4. SSL certificate is validated"

deploy-staging: install build tf-init-staging tf-apply-staging
	@echo "Staging deployment completed!"
	@echo "Please verify the following:"
	@echo "1. Frontend is accessible"
	@echo "2. Lambda functions are working"
	@echo "3. CloudFront distribution is active"
	@echo "4. SSL certificate is validated"

# Destroy commands
destroy-prod:
	@echo "⚠️ WARNING: This will destroy the PRODUCTION environment!"
	@echo "Type 'yes' to continue:"
	@read -p "" response; \
	if [ "$$response" = "yes" ]; then \
		$(MAKE) tf-destroy-prod; \
		echo "Production environment destroyed successfully!"; \
	else \
		echo "Destroy cancelled."; \
	fi

destroy-staging:
	@echo "⚠️ WARNING: This will destroy the STAGING environment!"
	@echo "Type 'yes' to continue:"
	@read -p "" response; \
	if [ "$$response" = "yes" ]; then \
		$(MAKE) tf-destroy-staging; \
		echo "Staging environment destroyed successfully!"; \
	else \
		echo "Destroy cancelled."; \
	fi

# Helper commands
verify-deploy:
	@echo "Verifying deployment..."
	@echo "Checking Lambda functions..."
	aws lambda list-functions --region us-east-1
	@echo "Checking CloudFront distributions..."
	aws cloudfront list-distributions
	@echo "Checking ACM certificates..."
	aws acm list-certificates --region us-east-1
	@echo "Deployment verification completed."

show-dns-records:
	@echo "Fetching DNS validation records..."
	@cd infra/environments/prod && terraform output -json acm_validation_records || true
	@echo "\nStaging Environment:"
	@cd infra/environments/staging && terraform output -json acm_validation_records || true
	@echo "\nAdd these CNAME records to your DNS settings." 