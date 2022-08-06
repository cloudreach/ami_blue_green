resource "aws_security_group" "ansible_server" {
  name        = "ansible_server"
  description = "Allow connect for ansible inbound traffic"
  vpc_id      = data.aws_vpc.talent_academy.id


  ingress {
    description      = "Allow port 3306"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = [data.aws_security_group.mysql_server.id]
  }


  # ingress {
  #   description      = "Allow port 22"
  #   from_port        = 22
  #   to_port          = 22
  #   protocol         = "tcp"
  #   cidr_blocks      = ["122.169.86.147/32"]
    
  # }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ansible_server"
  }
}