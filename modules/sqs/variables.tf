variable "name_prefix" {
  type = string
}

variable "environment" {
  type = string
}

variable "message_retention_seconds" {
  type    = number
  default = 345600
}
