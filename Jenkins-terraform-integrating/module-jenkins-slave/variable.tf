variable "instance_type" {
  default = "t2.medium"
}

variable "image" {
  default = "ami-022d03f649d12a49d"
  }

  variable "security_groups" {}
  variable "subnet_id" {
    default = "subnet-04ab1d47630fbcbad"
  }