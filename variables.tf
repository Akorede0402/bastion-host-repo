# create a variable for the VPC CIDR block
variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block for the VPC"
}
# create a variable for the public subnet az1a CIDR block
variable "public_subnet_az1a_cidr" {
  type        = string
  default     = "10.0.1.0/24"
  description = "The CIDR block for the public subnet in availability zone 1a"
}
# create a variable for the private app subnet az1a CIDR block
variable "private_app_az1a_cidr" {
  type        = string
  default     = "10.0.3.0/24"
  description = "the CIDR block for the private app subnet in availability zone 1a"
}