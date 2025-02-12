variable "region" {
  description = "region provider"
  type        = string
}

variable "access_key" {
  description = "access key provider"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "secret key provider"
  type        = string
  sensitive   = true
}