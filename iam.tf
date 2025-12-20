# IAM role for EC2 instances to access Systems Manager
resource "aws_iam_role" "ssm_role" {
  name_prefix = "ssm-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the SSM managed policy to the role
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAM instance profile for EC2 instances
resource "aws_iam_instance_profile" "ssm_profile" {
  name_prefix = "ssm-"
  role = aws_iam_role.ssm_role.name
}
