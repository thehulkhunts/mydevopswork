resource "aws_security_group" "jenkins-sg" {
    vpc_id = "vpc-0d0f50031677bf8d8"
    name = "security-jenkins"

    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        description = "allow ssh"
        from_port = 22
        to_port = 22
        security_groups = []
        prefix_list_ids = []
        protocol = "tcp"
        ipv6_cidr_blocks = []
        self = false

    }
       ingress {
        cidr_blocks = ["0.0.0.0/0"]
        description = "allow jenkins"
        from_port = 8080
        to_port = 8080
        security_groups = []
        prefix_list_ids = []
        protocol = "tcp"
        ipv6_cidr_blocks = []
        self = false
        
    }

    egress {
        cidr_blocks = ["0.0.0.0/0"]
        description = "block egress"
        from_port = 0
        to_port = 0
        security_groups = []
        prefix_list_ids = []
        protocol = -1
        ipv6_cidr_blocks = []
        self = false
    }
}

output "jenkins_security" {
  value = aws_security_group.jenkins-sg.id
}