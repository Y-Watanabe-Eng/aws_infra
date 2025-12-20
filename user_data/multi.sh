#!/bin/bash
apt-get update
apt-get install -y nginx

curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

npm install -g pm2

systemctl start nginx
systemctl enable nginx

mkdir -p /home/ubuntu/app
chown -R ubuntu:ubuntu /home/ubuntu/app

cd /home/ubuntu/app
npm install
npm run build
pm2 start npm --name "youtube-antenna" -- start
pm2 save
mv /tmp/default /etc/nginx/sites-available/default
nginx -t
systemctl restart nginx
env PATH=$PATH:/usr/bin pm2 startup systemd -u ubuntu --hp /home/ubuntu
pm2 save

curl "https://s3.amazonaws.com/amazon-ssm-ap-northeast-1/latest/debian_amd64/amazon-ssm-agent.deb" -o "amazon-ssm-agent.deb"
dpkg -i amazon-ssm-agent.deb
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent