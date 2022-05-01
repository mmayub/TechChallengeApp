variable "name" {
  description = "name of stack, e.g. \"demo\""
}

variable "environment" {
  description = "name of environment, e.g. \"prod\""
  default     = "npe"
}

variable "aws-region" {
  type        = string
  description = "AWS region where infrasturcture is launched"
  default     = "ap-souteast-2"
}

variable "aws-access-key" {
  type = string
}

variable "aws-secret-key" {
  type = string
}
