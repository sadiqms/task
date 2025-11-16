variable "vpc_cidr"        { type = string }
variable "public_subnet_a" { type = string }
variable "public_subnet_b" { type = string }
variable "az_a"            { type = string }
variable "az_b"            { type = string }

variable "cluster_name"    { type = string }
variable "alb_name"        { type = string }
variable "task_family"     { type = string }

variable "cpu"             { type = string }
variable "memory"          { type = string }

variable "image_repo"      { type = string }
variable "image_tag"       { type = string }

variable "service_name"    { type = string }
variable "desired_count"   { type = number }

variable "env_vars" {
  type    = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "tags"            { type = map(string) }


