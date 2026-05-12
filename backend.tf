terraform {
  backend "s3" {
    bucket = "terraform-lab-iti"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}
