# Common variables
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "The AWS region to deploy the infra"
}

variable "environment" {
  type        = string
  description = "Default environment for the infrastructure (e.g. dev, stg, prod, etc.)"
}

variable "service" {
  type        = string
  default     = "microblog"
  description = "Service or Product to identify the infra with"
}

# Network/VPC variables
variable "cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR Block of the VPC"
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnets CIDR Blocks"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnets CIDR Blocks"
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "app_image" {
  type        = string
  default     = "microblog:latest"
  description = "Docker image to run in the ECS cluster"
}

# Fargate Resource Configurations
variable "task_cpu" {
  type        = number
  default     = 256
  description = "Fargate instance CPU units for ID service (1 vCPU = 1024 CPU units)"
}

variable "task_memory" {
  type        = number
  default     = 512
  description = "Fargate instance memory for ID service (in MiB)"
}

variable "application_port" {
  type        = number
  default     = 5000
  description = "Fargate application port"
}

variable "app_desired_count" {
  type        = number
  default     = 2
  description = "Number of docker containers to run"
}

variable "force_image_rebuild" {
  type        = bool
  default     = false
  description = "whether to force a docker image rebuild or not"
}
