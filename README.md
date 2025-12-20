# Terraform × AWS ポートフォリオ

## 概要
Terraform を用いて AWS 上に Web 基盤を構築する学習・ポートフォリオ用リポジトリ。  
ALB → Target Group → EC2 (Nginx + Node.js) の一般的な Web サーバ構成を、IaC を通じて再現している。

https://playbass.uk/  
※検証用途のため、`terraform destroy` 時はアクセス不可。

---

## 構成図
![構成図](./src/aws_Infra.png)

---

## 使用技術

### IaC
- Terraform

### AWS
- VPC
- EC2 (Ubuntu 22.04 / t3.micro)
- Application Load Balancer
- Target Group
- Public Subnet × 2（マルチAZ: ap-northeast-1a / 1c）
- Internet Gateway
- Route Table
- Security Group × 3
- IAM Role（SSM 用）
- Key Pair
- Route53 + ACM（HTTPS）

### OS / Middleware
- Ubuntu 22.04 LTS
- Nginx（リバースプロキシ）
- Node.js（Next.js アプリケーション）

---

## ネットワーク構成
- マルチ AZ（ap-northeast-1a / 1c）
- ALB が **80/443** を受け、EC2 へ **80** で転送
- HTTP は ALB 側で HTTPS にリダイレクト
- 管理アクセスは SSH → **SSM Session Manager** へ移行済み
- YouTube Data API へのアウトバウンド通信のため  
  **パブリックサブネット運用を採用（NAT Gateway はコスト的に非採用）**

---

## ポイント

### インフラ自動化
- `user_data` で EC2 の初期構築（Nginx / Node.js のセットアップ）
- `provisioner "file"` により Web コンテンツを転送
- `terraform apply` のみで Web サーバが起動する構成

### 運用性
- `output` で EC2 IP / ALB DNS / ドメインを表示  
  → destroy → apply の再構築が容易
- SSM によりキーペア不要・22 番ポート閉鎖のセキュアな運用

---

## 開発ステップ
1. EC2 を Public Subnet に配置し、SSH で初期疎通確認  
2. **(初期)** EC2 に直接 80 を開放  
3. **(改善)** ALB 経由のみで 80/443 を受ける構成に変更  
4. Nginx の動作確認後、Next.js アプリを配置  
5. Route53 + ACM により HTTPS 化

---

## セットアップ

```bash
# 初期化
terraform init

# 実行計画
terraform plan

# インフラ構築
terraform apply

# インフラ削除
terraform destroy