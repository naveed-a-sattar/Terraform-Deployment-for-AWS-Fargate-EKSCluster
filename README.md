# Terraform Deployment for AWS Fargate EKS Cluster

This Terraform script allows you to deploy a Docker container on an AWS Fargate EKS cluster using resources such as ECR repository, EKS cluster, Fargate profile, task definition, and ECS service.

## Prerequisites

Before deploying the Terraform script, ensure that you have the following prerequisites:

- Terraform: Install Terraform by downloading it from the official website (https://www.terraform.io/downloads.html) and adding it to your system's PATH.
- AWS CLI: Install the AWS Command Line Interface (CLI) and configure it with your AWS account credentials.

## Deployment Steps

To deploy the Terraform script, follow these steps:

1. Clone the Repository: Clone this repository to your local machine or create a new directory where you want to store the Terraform files.

2. Set AWS Credentials: Configure your AWS credentials by running `aws configure` in your terminal and providing your AWS access key, secret key, default region, and output format.

3. Modify Variables (Optional): Open the `main.tf` file and modify the variable values according to your requirements. Replace placeholder values such as region, subnet IDs, security group IDs, ECR repository name, EKS cluster name, namespace, and resource names.

4. Initialize Terraform: Open a terminal, navigate to the directory where the `main.tf` file is located, and run the following command to initialize Terraform:
   ```
   terraform init
   ```

5. Preview the Changes: Run the following command to preview the changes that Terraform will make without actually applying them:
   ```
   terraform plan
   ```
   Review the output to ensure that the planned changes align with your expectations.

6. Apply the Changes: If the plan looks correct, apply the changes by running the following command:
   ```
   terraform apply
   ```
   Terraform will prompt you to confirm the changes. Enter `yes` to proceed. The script will create the necessary AWS resources.

7. Monitor the Deployment: Terraform will start provisioning the resources defined in the script. Monitor the progress in the output logs. Once the deployment is complete, you will see a summary of the created resources.

## Cleaning Up

To clean up the resources created by the Terraform script, follow these steps:

1. Destroy the Resources: Open a terminal, navigate to the directory where the `main.tf` file is located, and run the following command to destroy the resources:
   ```
   terraform destroy
   ```
   Terraform will prompt you to confirm the destruction of the resources. Enter `yes` to proceed. The script will delete the resources created during deployment.

2. Verify Deletion: Check the output logs to ensure that all resources have been successfully deleted.

## Conclusion

By following the above steps, you can deploy a Docker container on an AWS Fargate EKS cluster using Terraform. The script automates the creation of resources, making it easy to provision and manage your infrastructure.

Remember to review the Terraform script and modify the variables to match your requirements before deploying it. For more information about Terraform commands and configuration, refer to the official Terraform documentation.

For any issues or questions, please feel free to reach out for assistance.

Happy deploying!
