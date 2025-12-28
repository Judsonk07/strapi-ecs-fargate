# Terraform for Strapi Blue/Green Deployment

This folder contains Terraform to deploy a Strapi application on ECS Fargate using an ALB and CodeDeploy Blue/Green deployments.

Key resources
- ALB with two target groups (`blue`, `green`) and listeners (HTTP 80, optional HTTPS 443, test listener 9000).
- ECS Cluster, Task Definition (Fargate), and Service with `deployment_controller = CODE_DEPLOY`.
- CodeDeploy Application and Deployment Group configured for Blue/Green deploys.
- Security groups for ALB, ECS tasks, and RDS.

Quick validation and apply

1. Provide required variables in `terraform.tfvars` (see `variable.tf`). Important ones:
   - `vpc_id`, `public_subnets`, `private_subnets`
   - `image_url` (ECR image URL to deploy)
   - secrets: `db_password`, `app_keys`, `api_token_salt`, `admin_jwt_secret`, `transfer_token_salt`, `encryption_key`, `jwt_secret`
   - Optional: `acm_certificate_arn` to enable HTTPS listener on port 443

2. Initialize and plan

```bash
cd terraform
terraform init
terraform plan -var-file=terraform.tfvars
```

3. Apply

```bash
terraform apply -var-file=terraform.tfvars
```

Outputs
- `alb_url`: ALB DNS name
- `ecs_cluster_name`, `ecs_service_name`
- `codedeploy_app_name`

Notes
- The test listener on port 9000 can be opened to the internet for debugging. Control this with the `enable_test_listener_ingress` variable in `variable.tf` (default `false`). Set it to `true` in `terraform.tfvars` to allow external access.
- Ensure the IAM roles (already defined) are acceptable in your account; update names if you need a naming convention.
- To enable HTTPS, set `acm_certificate_arn` to a valid certificate in the same region.

If you want, I can also:
- Add more outputs (CodeDeploy deployment group name, ALB listener ARNs).
- Make the port 9000 ingress conditional behind a variable.
