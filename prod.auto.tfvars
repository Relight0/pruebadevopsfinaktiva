aws_region   = "us-west-2"
project_name = "fargate-cluster-prod"

vpc_cidr             = "10.2.0.0/16"
public_subnet_cidrs  = ["10.2.1.0/24", "10.2.2.0/24"]
private_subnet_cidrs = ["10.2.3.0/24", "10.2.4.0/24"]
availability_zones   = ["us-west-2a", "us-west-2b"]

task_cpu    = "1024"
task_memory = "2048"

service_desired_count = 2

allowed_ips = ["0.0.0.0/0"]

max_capacity                 = 4
min_capacity                 = 2
autoscaling_cpu_threshold    = 60
autoscaling_memory_threshold = 70

domain_name = "pruebatecnicadevopsfinaktiva.com"

app1_image = "554115127259.dkr.ecr.us-west-2.amazonaws.com/fargate-cluster-test-app1:prod"
app2_image = "554115127259.dkr.ecr.us-west-2.amazonaws.com/fargate-cluster-test-app2:prod"