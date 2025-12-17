resource "aws_instance" "multi" {
  ami                    = data.aws_ami.ubuntu_22_04.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public01.id
  vpc_security_group_ids = [aws_security_group.ssh_sg.id, aws_security_group.web_sg.id]
  key_name               = aws_key_pair.main.key_name

  user_data_base64 = base64encode(<<EOF
#!/bin/bash
apt-get update
apt-get install -y nginx
systemctl start nginx
systemctl enable nginx

EOF
  )

  tags = {
    Name = "tf-demo"
    Role = "env"
  }
}

data "aws_ami" "ubuntu_22_04" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
  
}