# Terraform × AWS ポートフォリオ

Terraform を使って AWS 上に基本的なネットワーク構成と EC2 を構築。  

## 構成概要

- VPC
- Public Subnet
- Internet Gateway
- Security Group
- EC2

EC2はPublic Subnetに配置し、  
SSHによる疎通確認ができる状態まで構築。
一時的にSecurity GroupでHTTP(80)を0.0.0.0/0で開放し、Nginxの動作確認。


## 使用技術

- Terraform
- AWS（EC2 / VPC / Security Group）
- Ubuntu 22.04 LTS
