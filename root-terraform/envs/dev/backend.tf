terraform {
  backend "s3" {
    bucket = "your-dev-terraform-state-bucket"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}
