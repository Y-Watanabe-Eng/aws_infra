# IAM ロール（SSM/S3 アクセス用）
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

# SSM ポリシー（セッションマネージャー用）
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# インスタンスプロファイル
resource "aws_iam_instance_profile" "ssm_profile" {
  name_prefix = "ssm-"
  role = aws_iam_role.ssm_role.name
}

# S3 アクセスポリシー（デプロイアーティファクト用）
resource "aws_iam_role_policy" "s3_access" {
  name_prefix = "s3-access-"
  role        = aws_iam_role.ssm_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListAllMyBuckets"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.deploy_bucket.arn,
          "${aws_s3_bucket.deploy_bucket.arn}/*"
        ]
      }
    ]
  })
}
