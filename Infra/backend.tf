terraform {
  required_version = ">= 1.1.0"
  backend "s3" {
    bucket         = "techopsbucket123"
    key            = "vpcec2/terraform.tfstateeks"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "demo_table123"
  }
}
