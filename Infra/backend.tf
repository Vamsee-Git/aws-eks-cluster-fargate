terraform{
  backend "s3" {
    bucket         = "terraform-state-backend-vamsee"
    key            = "terraform/eksfargate"
    region         = "us-west-1"
    encrypt        = true
    ##dynamodb_table = "Dynamodb-lock"
  }
}
