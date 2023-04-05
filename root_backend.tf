terraform {
  backend "s3" {
    bucket = "dri-terraform-state-store"
    key    = "terraform.github.state"
    region = "eu-west-2"
  }
}
