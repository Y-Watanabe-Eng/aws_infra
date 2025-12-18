# Terraform × AWS ポートフォリオ

Terraform を使って AWS 上に基本的なネットワーク構成と EC2 を構築。  

## 構成概要

- VPC
- EC2
- Public Subnet
- Internet Gateway
- Security Group
- Application Load Balancer


EC2はPublic Subnetに配置し、  
SSHによる疎通確認ができる状態まで構築。

http接続は~~一時的にSecurityGroupでポート80を0.0.0.0/0で開放し、~~<br>
ロードバランサ経由でのみアクセス可能に変更し、Nginxの動作確認。

## 使用技術

- Terraform
- AWS
- Ubuntu 22.04 LTS
