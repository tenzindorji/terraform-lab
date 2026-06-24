variable "vpc_id" {type = string}
variable "environment" {}

variable "allowed_ports" {
    type = set(string)
    default = ["80", "443"]
}