variable "name_prefix" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "allowed_http_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "target_port" {
  type    = number
  default = 80
}

variable "health_check_path" {
  type    = string
  default = "/"
}

variable "target_instance_id" {
  type    = string
  default = null
}
