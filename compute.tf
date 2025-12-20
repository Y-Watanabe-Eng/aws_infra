resource "aws_instance" "multi" {
  ami                    = data.aws_ami.ubuntu_22_04.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public01.id
  vpc_security_group_ids = [aws_security_group.ssh_sg.id, aws_security_group.web_sg.id]
  associate_public_ip_address = true
  key_name               = aws_key_pair.main.key_name
  tags = {
    Name = "tf-demo"
    Role = "env"
  }
  user_data_base64 = base64encode(
    file("${path.module}/user_data/multi.sh")
  )
    connection {
    type        = "ssh"
    user     = "ubuntu"
    private_key = file("${path.module}/.ssh/tf_demo")
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "${path.module}/site/youtube_antenna"
    destination = "/home/ubuntu/app"
  }

  provisioner "file" {
    source      = "${path.module}/nginx/default"
    destination = "/tmp/default"
  }

  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
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
