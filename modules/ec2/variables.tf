variable "name" {
  type = string
}

variable "environment" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type    = string
  default = null
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type    = string
  default = null
}

variable "allowed_ssh_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}
