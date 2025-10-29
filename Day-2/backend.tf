terraform {
  backend "s3" {
    bucket = "legin-terraform-state-bucket"
    key    = "iac-day-2/terraform.tfstate"
    region = "us-east-1"   
    use_lockfile = true
    encrypt = true
  }
}