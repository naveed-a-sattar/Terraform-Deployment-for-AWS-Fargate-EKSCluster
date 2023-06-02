# Initialize Terraform provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.60.0"
    }
  }
}

# Configure the AWS provider
provider "aws" {
  region = "us-east-1"  # Replace with your desired AWS region
}

# Create an ECR repository
resource "aws_ecr_repository" "my_repository" {
  name = "my-docker-repo"  # Replace with your desired ECR repository name
}

# Define the AWS EKS cluster
resource "aws_eks_cluster" "my_cluster" {
  name     = "my-cluster"  # Replace with your desired EKS cluster name
  role_arn = aws_iam_role.my_cluster_role.arn
  version  = "1.21"

  vpc_config {
    subnet_ids         = ["subnet-xxxxxxxx", "subnet-xxxxxxxx"]  # Replace with your desired subnet IDs
    security_group_ids = ["sg-xxxxxxxx"]  # Replace with your desired security group IDs
  }
}

# Define the IAM role for the EKS cluster
resource "aws_iam_role" "my_cluster_role" {
  name = "my-eks-cluster-role"  # Replace with your desired IAM role name

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Attach the necessary policies to the EKS cluster role
resource "aws_iam_role_policy_attachment" "my_cluster_policy_attachment" {
  role       = aws_iam_role.my_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Define the Fargate profile for the EKS cluster
resource "aws_eks_fargate_profile" "my_fargate_profile" {
  cluster_name = aws_eks_cluster.my_cluster.name
  fargate_profile_name = "my-fargate-profile"  # Replace with your desired Fargate profile name

  subnet_ids = ["subnet-xxxxxxxx", "subnet-xxxxxxxx"]  # Replace with your desired subnet IDs

  selector {
    namespace = "default"  # Replace with your desired namespace
  }
}

# Create a task definition for the Docker container
resource "aws_ecs_task_definition" "my_task_definition" {
  family                   = "my-task-definition"  # Replace with your desired task definition name
  container_definitions    = <<DEFINITION
[
  {
    "name": "my-container",
    "image": "${aws_ecr_repository.my_repository.repository_url}:latest",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80,
        "protocol": "tcp"
      }
    ],
    "cpu": 256,
    "memory": 512
  }
]
DEFINITION
  requires_compatibilities = ["FARGATE"]
  network_mode            = "awsvpc"
  execution_role_arn      = aws_iam_role.my_task_role.arn
}

# Create an IAM role for the task execution
resource "aws_iam_role" "my_task_role" {
  name = "my-task-role"  # Replace with your desired IAM role name

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Attach the necessary policies to the task execution role
resource "aws_iam_role_policy_attachment" "my_task_policy_attachment" {
  role       = aws_iam_role.my_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Create a service in the EKS cluster to run the task
resource "aws_ecs_service" "my_service" {
  name            = "my-service"  # Replace with your desired service name
  cluster         = aws_eks_cluster.my_cluster.name
  task_definition = aws_ecs_task_definition.my_task_definition.arn
  desired_count   = 1

  deployment_controller {
    type = "ECS"
  }

  launch_type = "FARGATE"
  platform_version = "1.4.0"

  network_configuration {
    security_groups = ["sg-xxxxxxxx"]  # Replace with your desired security group IDs
    subnets         = ["subnet-xxxxxxxx", "subnet-xxxxxxxx"]  # Replace with your desired subnet IDs
  }
}
