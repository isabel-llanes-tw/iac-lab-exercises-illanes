terraform {
  backend "s3" {
    bucket       = "illanes-iac-lab-tfstate"
    key          = "illanes-iac-lab/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
}