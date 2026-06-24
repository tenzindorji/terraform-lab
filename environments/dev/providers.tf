provider "aws" {
  region = "us-east-2"

  assume_role {
    # The exact ARN of the target role you want to assume
    role_arn = "arn:aws:iam::379755567760:role/pulumi-python"

    # Optional descriptive identifier for tracing actions in CloudTrail
    session_name = "terraform-deployment-session"

    # Optional if your security policy requires an External ID for third parties
    # external_id  = "your-company-secure-id"
  }
}
