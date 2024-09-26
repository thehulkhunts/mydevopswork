resource "aws_instance" "jenkins" {
  ami = var.image
  instance_type = var.instance_type[1]
  key_name = "godevops50"
  subnet_id = var.subnet_id
  vpc_security_group_ids = [var.vpc_security_group_ids]
  user_data = file("${path.module}/jenkins.sh")

  root_block_device {
    volume_size = 20 
    volume_type = "gp2"
  }
  tags = {
    Name = "Jenkins_server"
    Environment = "dev"
  }
}