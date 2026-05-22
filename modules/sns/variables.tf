variable "name_prefix" {
  type = string
}

variable "environment" {
  type = string
}

variable "enable_sqs_subscription" {
  type    = bool
  default = false
}

variable "sqs_queue_arn" {
  type    = string
  default = null
}

variable "sqs_queue_url" {
  type    = string
  default = null
}
