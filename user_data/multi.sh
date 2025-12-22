#!/bin/bash
set -e

# ログ出力
exec > >(tee /var/log/user-data.log)
exec 2>&1

echo "=== Starting user data script ==="
date

# 基本パッケージのインストール
apt-get update
apt-get install -y nginx awscli unzip

# Node.js のインストール
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

# PM2 のインストール
npm install -g pm2

# Nginx の起動
systemctl start nginx
systemctl enable nginx

# S3 バケット名を動的に取得（tf-demo-deploy-* というパターンで検索）
echo "=== Getting S3 bucket name ==="
BUCKET_NAME=$(aws s3 ls --region ap-northeast-1 | grep "tf-demo-deploy" | awk '{print $3}' | head -1)
echo "Bucket name: $BUCKET_NAME"

if [ -z "$BUCKET_NAME" ]; then
  echo "ERROR: Could not find S3 bucket"
  exit 1
fi

# アプリケーションディレクトリを作成
mkdir -p /home/ubuntu/app
chown -R ubuntu:ubuntu /home/ubuntu/app

# S3 からアプリケーションをダウンロード
echo "=== Downloading app from S3 ==="
aws s3 cp "s3://${BUCKET_NAME}/app/app.zip" "/tmp/app.zip" --region ap-northeast-1

# アプリケーションを展開
unzip -q "/tmp/app.zip" -d /home/ubuntu/app
chown -R ubuntu:ubuntu /home/ubuntu/app

# S3 から Nginx 設定をダウンロード
echo "=== Downloading nginx config from S3 ==="
aws s3 cp "s3://${BUCKET_NAME}/nginx/default" "/etc/nginx/sites-available/default" --region ap-northeast-1

# Ubuntu ユーザーでアプリケーションをビルド＆起動
echo "=== Building and starting application ==="
sudo -u ubuntu bash << 'EOF'
set -e
export HOME=/home/ubuntu
cd /home/ubuntu/app
npm install
npm run build
pm2 start npm --name "youtube-antenna" -- start
pm2 save
EOF

# Nginx のテスト＆再起動
nginx -t
systemctl restart nginx

# PM2 を systemd サービスとして登録
echo "=== Setting up PM2 systemd service ==="
sudo -u ubuntu bash << 'EOF'
export HOME=/home/ubuntu
env PATH=$PATH:/usr/bin pm2 startup systemd -u ubuntu --hp /home/ubuntu
pm2 save
EOF

# SSM Agent のインストール
echo "=== Installing SSM Agent ==="
curl "https://s3.amazonaws.com/amazon-ssm-ap-northeast-1/latest/debian_amd64/amazon-ssm-agent.deb" -o "amazon-ssm-agent.deb"
dpkg -i amazon-ssm-agent.deb
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

echo "=== User data script completed ==="
date