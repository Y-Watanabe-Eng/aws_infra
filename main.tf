resource "aws_key_pair" "main" {
  key_name   = "tf-demo-key"
  # Read the public key stored in the repo-local .ssh directory
  public_key = file("${path.module}/.ssh/tf_demo.pub")

    tags = {
        Name = "tf-demo"
        env  = "dev"
    }
  
}