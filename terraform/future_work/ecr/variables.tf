variable "name" {
  description = "the name of your stack, e.g. \"demo\""
}
variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

variable "tag" {
  description = "tag to use for our new docker image"
}