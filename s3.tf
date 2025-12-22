# S3 バケット（デプロイ用）
resource "aws_s3_bucket" "deploy_bucket" {
  bucket = "tf-demo-deploy-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "tf-demo-deploy"
    env  = "dev"
  }
}

# バージョニング設定
resource "aws_s3_bucket_versioning" "deploy_bucket_versioning" {
  bucket = aws_s3_bucket.deploy_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Nginx 設定ファイルアップロード
resource "aws_s3_object" "nginx_default" {
  bucket = aws_s3_bucket.deploy_bucket.id
  key    = "nginx/default"
  source = "${path.module}/nginx/default"
  etag   = filemd5("${path.module}/nginx/default")

  tags = {
    Name = "nginx-default"
  }
}

# アプリケーション ZIP ファイル作成
data "archive_file" "app_zip" {
  type        = "zip"
  source_dir  = "${path.module}/site/youtube_antenna"
  output_path = "${path.module}/site/app.zip"
}

# アプリケーション ZIP アップロード
resource "aws_s3_object" "app_zip" {
  bucket = aws_s3_bucket.deploy_bucket.id
  key    = "app/app.zip"
  source = data.archive_file.app_zip.output_path
  etag   = filemd5(data.archive_file.app_zip.output_path)

  tags = {
    Name = "app-zip"
  }
}

# AWS アカウント ID 取得
data "aws_caller_identity" "current" {}