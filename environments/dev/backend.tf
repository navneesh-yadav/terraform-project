terraform {
  backend "s3" {
    bucket         = "navneesh-yadav-terraform-project-tf-state-bucket"    # Paste output here
    key            = "dev/terraform.tfstate" 
    region         = "us-east-1"
    dynamodb_table = "navneesh-yadav-terraform-project-tf-locks"    # Paste output here
    encrypt        = true
  }
}

