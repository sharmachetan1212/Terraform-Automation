variable "name" {
  type = string
}

variable "environment" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "subnet_count" {
  type    = number
  default = 2
}

variable "map_public_ip_on_launch" {
  type    = bool
  default = true
}
