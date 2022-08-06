
resource "aws_instance" "green_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.ansible_server.id]

  key_name = "talent-academy-lab"
  subnet_id = data.aws_subnet.public.id


  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_eip" "green_server_eip" {
  instance = aws_instance.ansible_server.id
  vpc      = true
}

resource "aws_instance" "blue_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.ansible_server.id]

  key_name = "talent-academy-lab"
  subnet_id = data.aws_subnet.public.id


  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_eip" "blue_server_eip" {
  instance = aws_instance.ansible_server.id
  vpc      = true
}