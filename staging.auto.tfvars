aws_region   = "us-east-2"
project_name = "fargate-cluster-staging"

vpc_cidr             = "10.1.0.0/16"
public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = ["10.1.3.0/24", "10.1.4.0/24"]
availability_zones   = ["us-east-2a", "us-east-2b"]

task_cpu    = "512"
task_memory = "1024"

service_desired_count = 2

allowed_ips = ["0.0.0.0/0"]

max_capacity                 = 3
min_capacity                 = 1
autoscaling_cpu_threshold    = 70
autoscaling_memory_threshold = 80

domain_name = "staging.pruebatecnicadevopsfinaktiva.com"

app1_image = "554115127259.dkr.ecr.us-east-2.amazonaws.com/fargate-cluster-test-app1:staging"
app2_image = "554115127259.dkr.ecr.us-east-2.amazonaws.com/fargate-cluster-test-app2:staging"