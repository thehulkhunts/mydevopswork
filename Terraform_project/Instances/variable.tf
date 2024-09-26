variable "image" {
  type = string
  default = "ami-08718895af4dfa033"
}
variable "instance_type" {
  type = list(string)
  default = [ "t2.micro", "t2.medium"]
}
variable "subnet_id" {
  type = string
}
variable "vpc_security_group_ids" {
  type = string
}