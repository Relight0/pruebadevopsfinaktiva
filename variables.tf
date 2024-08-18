variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "The availability zones to use"
  type        = list(string)
}

variable "task_cpu" {
  description = "The number of CPU units to reserve for the container"
  type        = string
}

variable "task_memory" {
  description = "The amount of memory (in MiB) to allow the container to use"
  type        = string
}

variable "service_desired_count" {
  description = "The number of instances of the task definition to place and keep running"
  type        = number
}

variable "allowed_ips" {
  description = "List of allowed IP addresses"
  type        = list(string)
}

variable "max_capacity" {
  description = "Maximum capacity for autoscaling"
  type        = number
}

variable "min_capacity" {
  description = "Minimum capacity for autoscaling"
  type        = number
}

variable "autoscaling_cpu_threshold" {
  description = "CPU threshold for autoscaling"
  type        = number
}

variable "autoscaling_memory_threshold" {
  description = "Memory threshold for autoscaling"
  type        = number
}

variable "domain_name" {
  description = "Domain name for the SSL certificate"
  type        = string
}

variable "app1_image" {
  description = "Docker image for app1"
  type        = string
}

variable "app2_image" {
  description = "Docker image for app2"
  type        = string
}

variable "environment" {
  description = "The deployment environment (dev, staging, prod)"
  type        = string
}