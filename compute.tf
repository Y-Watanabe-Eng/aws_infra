resource "aws_instance" "multi" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = aws_key_pair.main.key_name

  tags = {
    Name = "multi"
    Role = "env"
  }
}