variable "aws_region" {
  type        = string
  description = "The target AWS deployment region"
  default     = "us-east-1"
}

variable "aws_account_id" {
  type        = string
  description = "Your 12-digit AWS account number"
}
