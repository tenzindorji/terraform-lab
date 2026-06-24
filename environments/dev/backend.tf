terraform {
  backend "s3" {
    bucket       = "my-pulumi-state-bucket-379755567760"
    key          = "dev/terraform.tfstate"
    region       = "us-east-2"
    encrypt      = true
    use_lockfile = true
  }
}