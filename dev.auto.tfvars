aws_region   = "us-east-1"
project_name = "fargate-cluster-dev"

vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b"]

task_cpu    = "256"
task_memory = "512"

service_desired_count = 1

allowed_ips = ["0.0.0.0/0"]

max_capacity                 = 2
min_capacity                 = 1
autoscaling_cpu_threshold    = 70
autoscaling_memory_threshold = 80

domain_name = "dev.pruebatecnicadevopsfinaktiva.com"

app1_image = "554115127259.dkr.ecr.us-east-1.amazonaws.com/fargate-cluster-test-app1:dev"
app2_image = "554115127259.dkr.ecr.us-east-1.amazonaws.com/fargate-cluster-test-app2:dev"