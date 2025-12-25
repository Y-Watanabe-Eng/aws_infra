# Terraform × AWS ポートフォリオ

## 概要
Terraformを用いてAWS上にWeb基盤を自動構築することを目的とした学習・ポートフォリオ用リポジトリ。 <br>
ALB（Application Load Balancer）でHTTPS終端を行い、EC2上のNginx/Node.js（Next.js）アプリケーションへ安全にリクエストを転送する。

## デモ URL
https://playbass.uk/ <br>
※検証時のみ稼働。不要時は terraform destroy により完全削除。

---

## 構成図
![構成図](./src/aws_Infra.png)

---

## 使用技術

### IaC
- Terraform

### AWS
- VPC
- EC2 (Ubuntu 22.04/t3.micro)
- Application Load Balancer
- Target Group
- Public Subnet ×2（マルチAZ:ap-northeast-1a/1c）
- Internet Gateway
- Route Table
- Security Group ×2（ALB/EC2）
- IAM Role（SSM用）
- S3（デプロイ管理）
- Route53+ACM（HTTPS）

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
  **パブリックサブネット運用を採用（NAT Gateway はコスト的に断念）**

---

## ポイント

### インフラ自動化

#### デプロイフロー
1. **アーティファクト作成**
   - Terraform で Next.js アプリを ZIP 化
   - Nginx 設定ファイルを準備

2. **S3 アップロード**
   - アプリケーション ZIP を S3 にアップロード
   - Nginx 設定を S3 にアップロード
   - バージョニング有効化で履歴管理

3. **EC2 初期化（user_data）**
   - パッケージインストール（Nginx, Node.js, PM2）
   - S3 から自動ダウンロード（AWS CLI 使用）
   - ZIP 展開・アプリビルド
   - サービス起動（Nginx + PM2）

4. **管理アクセス**
   - SSM Session Manager で接続（SSH 不要）
   - ログは `/var/log/user-data.log` で確認可能


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
6. 

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