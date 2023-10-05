resource "aws_instance" "jenkins-slave" {
    ami = var.image
    instance_type = var.instance_type
    vpc_security_group_ids = ["${var.security_groups}"]
    subnet_id = var.subnet_id
    user_data = file("${path.module}/jenkins_slave.sh")
    key_name = "osdevops7"

    tags = {
      Name = "Jenkins-slave"
    }
}