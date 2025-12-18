# Terraform × AWS ポートフォリオ

## 概要

Terraform を用いてAWS上にWEB基盤を構築する学習・ポートフォリオ用リポジトリ。
ALB経由でEC2上のNginx/Node.jsアプリへリクエストを転送する。
[参考リンク](http://web-alb-1534830055.ap-northeast-1.elb.amazonaws.com/)<br>
※検証用途のため、不要時はterraform destroyすることから、稼働時のみの有効リンク

## 使用技術

- IaC：Terraform

- Clowd：AWS
-- VPC
-- EC2
-- Application Load Balancer
-- Public Subnet
-- Internet Gateway
-- Security Group

- OS/MW
-- Ubuntu 22.04 LTS
-- Nginx
-- Node.js(Next.js)

## ポイント

- EC2初期設定はuser_dataで実行
-- provisionerは起動タイミングによるエラーに悩まされたため、最小限の使用
-- terraform applyのみでWEBサーバが起動
- IP/DNSはoutputで管理
-- destroyした時に不便なため実装

## 開発の流れ

EC2はPublic Subnetに配置し、  
SSHによる疎通確認ができる状態まで構築。

http接続は~~一時的にSecurityGroupでポート80を0.0.0.0/0で開放し、~~<br>
ロードバランサ経由でのみアクセス可能に変更し、Nginxの動作確認。
その後、以前作成したWEBサイトを配置し、httpアクセス可能に。



