resource "aws_key_pair" "main" {
  key_name   = "tf-demo-key"
  public_key = file("${path.module}/.ssh/tf_demo.pub")

    tags = {
        Name = "tf-demo"
        env  = "dev"
    }
  
}