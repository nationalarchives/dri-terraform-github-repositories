terraform {
  backend "s3" {
    bucket         = "mgmt-dp-terraform-state"
    key            = "terraform.github.state"
    region         = "eu-west-2"
    dynamodb_table = "mgmt-dp-terraform-state-lock"
  }
}
