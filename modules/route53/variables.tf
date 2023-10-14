variable "record" { type = string }
variable "primary" {}
variable "www" {}
variable "record-dev" {
  type = string
}

variable "record-live" {}
variable "main-lb" {}
variable "zone" {}
variable "test" {}

variable "env_name" { default = ["dev", "stage", "buld"] }
