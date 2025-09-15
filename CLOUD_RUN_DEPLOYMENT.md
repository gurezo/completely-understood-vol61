# Cloud Run デプロイメントガイド

このガイドでは、Nx ワークスペースのバックエンドアプリケーションを Google Cloud Run にデプロイする方法について説明します。

## 🏗️ アーキテクチャ

- **Nx Cloud**: ビルドキャッシュと並列実行の最適化
- **GitHub Actions**: CI/CD パイプライン
- **Google Cloud Run**: サーバーレスコンテナ実行環境
- **Docker**: コンテナ化

## 📋 前提条件

1. **Google Cloud Project**が設定されている
2. **Google Cloud CLI**がインストールされている
3. **Docker**がインストールされている
4. **GitHub Secrets**が設定されている

## 🔑 必要な GitHub Secrets

以下のシークレットを GitHub リポジトリに設定してください：

```bash
# Google Cloud設定
GCP_PROJECT_ID=your-project-id
GCP_SA_KEY={"type": "service_account", ...} # JSON形式のサービスアカウントキー

# Nx Cloud設定
NX_CLOUD_ACCESS_TOKEN=your-nx-cloud-token
```

## 🚀 デプロイ方法

### 1. 自動デプロイ（推奨）

GitHub にプッシュすると、自動的に CI/CD パイプラインが実行されます：

```bash
git add .
git commit -m "feat: update backend"
git push origin main
```

### 2. 手動デプロイ

#### スクリプトを使用

```bash
# ステージング環境にデプロイ
./scripts/deploy-backend.sh staging

# 本番環境にデプロイ
./scripts/deploy-backend.sh production
```

#### Nx コマンドを使用

```bash
# ステージング環境にデプロイ
npx nx deploy:staging backend

# 本番環境にデプロイ
npx nx deploy:staging backend --configuration=production
```

#### 直接 gcloud コマンドを使用

```bash
# イメージのビルドとプッシュ
cd apps/backend
docker build -t gcr.io/PROJECT_ID/backend:latest .
docker push gcr.io/PROJECT_ID/backend:latest

# Cloud Runにデプロイ
gcloud run deploy backend \
  --image gcr.io/PROJECT_ID/backend:latest \
  --region asia-northeast1 \
  --platform managed \
  --allow-unauthenticated
```

## 🔧 設定のカスタマイズ

### 環境変数

`apps/backend/cloud-run.yaml`で環境変数を設定できます：

```yaml
env:
  - name: PORT
    value: '8080'
  - name: RUST_LOG
    value: 'info'
```

### リソース設定

```yaml
resources:
  limits:
    cpu: '1'
    memory: '512Mi'
  requests:
    cpu: '0.5'
    memory: '256Mi'
```

### スケーリング設定

```yaml
scaling:
  minScale: 0
  maxScale: 10
```

## 📊 モニタリング

### Cloud Run コンソール

- [Cloud Run Console](https://console.cloud.google.com/run)
- ログ、メトリクス、設定の確認

### ログの確認

```bash
gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=backend" --limit=50
```

### メトリクスの確認

```bash
gcloud monitoring metrics list --filter="metric.type:run.googleapis.com"
```

## 🧪 テスト

### ローカルテスト

```bash
# アプリケーションのビルド
npx nx build backend

# Dockerイメージのビルド
npx nx docker:build backend

# ローカルで実行
npx nx docker:run backend
```

### ヘルスチェック

```bash
curl http://localhost:8080/
# 期待される出力: "OK"
```

## 🔍 トラブルシューティング

### よくある問題

1. **認証エラー**

   ```bash
   gcloud auth login
   gcloud config set project YOUR_PROJECT_ID
   ```

2. **権限エラー**

   - サービスアカウントに適切な権限が付与されているか確認
   - 必要な権限: Cloud Run Admin, Storage Admin, Service Account User

3. **ビルドエラー**

   ```bash
   # キャッシュをクリア
   npx nx reset

   # 依存関係を再インストール
   pnpm install
   ```

4. **デプロイエラー**

   ```bash
   # ログの確認
   gcloud run services describe backend --region asia-northeast1

   # ログの表示
   gcloud logs read "resource.type=cloud_run_revision AND resource.labels.service_name=backend"
   ```

### ログの確認

```bash
# リアルタイムログ
gcloud logs tail "resource.type=cloud_run_revision AND resource.labels.service_name=backend"

# 特定の時間範囲のログ
gcloud logs read "resource.type=cloud_run_revision AND resource.labels.service_name=backend" \
  --format="table(timestamp,severity,textPayload)" \
  --limit=100
```

## 📚 参考資料

- [Google Cloud Run Documentation](https://cloud.google.com/run/docs)
- [Nx Documentation](https://nx.dev/)
- [Rust Actix-web Documentation](https://actix.rs/)
- [Docker Documentation](https://docs.docker.com/)

## 🤝 サポート

問題が発生した場合は、以下を確認してください：

1. GitHub Actions のログ
2. Cloud Run のログ
3. このドキュメントのトラブルシューティングセクション
4. Nx Cloud のダッシュボード
