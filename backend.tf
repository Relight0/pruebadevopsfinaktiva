terraform {
  backend "s3" {
    bucket         = "prueba-devops-finaktiva-tf-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "prueba-devops-finaktiva-tf-state-lock"
    encrypt        = true
  }
}