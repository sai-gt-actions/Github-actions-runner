# variable "project" {
#     default = "roboshop"
# }

# variable "environment" {
#     default = "dev"
# }

# variable "zone_name" {
#   type        = string
#   default     = "saidaws86s.fun"
#   description = "description"
# }

# variable "zone_id" {
#   type        = string
#   default     = "Z0506429205Z4ZA4IXHNC"
#   description = "description"
# }

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "private_subnet_ids" {
  type    = list(string)
  default = [
    "subnet-0bf3d53e59ef42889", # 10.0.11.0/24
    "subnet-0bf3d53e59ef42890"  # 10.0.12.0/24
  ]
}

variable "project" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "zone_name" {
  type        = string
  default     = "saidaws86s.fun"
  description = "Route53 zone name"
}

variable "zone_id" {
  type        = string
  default     = "Z0506429205Z4ZA4IXHNC"
  description = "Route53 zone ID"
}
