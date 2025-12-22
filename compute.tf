# EC2 インスタンス（アプリケーションサーバー）
resource "aws_instance" "multi" {
  ami                    = data.aws_ami.ubuntu_22_04.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public01.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "tf-demo"
    Role = "env"
  }

  user_data_base64 = base64encode(file("${path.module}/user_data/multi.sh"))

  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name

  depends_on = [
    aws_s3_object.app_zip,
    aws_s3_object.nginx_default
  ]
}

# Ubuntu 22.04 AMI データソース
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
