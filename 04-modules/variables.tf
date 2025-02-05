variable "region" {
  description = "region"
  type        = string
}

variable "access_key" {
  description = "access_key"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "secret_key"
  type        = string
  sensitive   = true
}

variable "instance_names" {
  description = "instance_names"
  type        = set(string)
}