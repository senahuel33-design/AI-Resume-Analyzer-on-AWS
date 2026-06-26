terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# 1. Fetch available availability zones in your target region
data "aws_availability_zones" "available" {
  state = "available"
}

# 2. Base Networking Isolation Layer (VPC)
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "ai-resume-vpc"
  }
}

# 3. Public Subnets (Spread across 2 Availability Zones for high availability)
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "ai-resume-public-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "ai-resume-public-2"
  }
}

# 4. Internet Gateway to connect our subnets to the public internet
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "ai-resume-igw"
  }
}

# 5. Route Table routing traffic out to the Internet Gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "ai-resume-public-rt"
  }
}

# 6. Associate our subnets with our Route Table
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# 7. Security Group (Firewall) allowing public web traffic to access your container port
resource "aws_security_group" "ecs_tasks" {
  name        = "ai-resume-ecs-tasks-sg"
  description = "Allow inbound HTTP traffic to the FastAPI application container"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 8000  # Assumes your FastAPI application binds to port 8000
    to_port     = 8000
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 8. The Amazon ECS Management Cluster
resource "aws_ecs_cluster" "main" {
  name = "ai-resume-cluster"
}

# 9. ECS Task Definition (Tells Fargate how much resources to allocate to your container)
resource "aws_ecs_task_definition" "app" {
  family                   = "ai-resume-app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256" # 0.25 vCPU (Perfect for Free Tier / low cost development)
  memory                   = "512" # 512 MB RAM
  execution_role_arn       = "arn:aws:iam::${var.aws_account_id}:role/github-actions-ecr-role"

  container_definitions = jsonencode([{
    name      = "ai-resume-container"
    image     = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/ai-resume-analyzer:latest"
    essential = true
    portMappings = [{
      containerPort = 8000
      hostPort      = 8000
    }]
  }])
}

# 10. The ECS Service running the task definitions serverlessly on Fargate
resource "aws_ecs_service" "main" {
  name            = "ai-resume-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = [aws_subnet.public_1.id, aws_subnet.public_2.id]
    assign_public_ip = true
  }
}
