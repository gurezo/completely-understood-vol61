#!/bin/bash

# バックエンドをCloud Runにデプロイするスクリプト

set -e

# 環境変数の設定
ENVIRONMENT=${1:-staging}
PROJECT_ID=${GCP_PROJECT_ID:-$(gcloud config get-value project)}
REGION=${GCP_REGION:-asia-northeast1}
SERVICE_NAME="backend"
IMAGE_NAME="gcr.io/${PROJECT_ID}/backend"

echo "🚀 Deploying backend to Cloud Run..."
echo "Environment: $ENVIRONMENT"
echo "Project ID: $PROJECT_ID"
echo "Region: $REGION"
echo "Service: $SERVICE_NAME"

# プロジェクトの確認
if [ -z "$PROJECT_ID" ]; then
    echo "❌ GCP_PROJECT_ID environment variable is not set"
    echo "Please set GCP_PROJECT_ID or run: gcloud config set project YOUR_PROJECT_ID"
    exit 1
fi

# 認証の確認
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q .; then
    echo "❌ Not authenticated with Google Cloud"
    echo "Please run: gcloud auth login"
    exit 1
fi

# プロジェクトの設定
echo "📋 Setting project to: $PROJECT_ID"
gcloud config set project "$PROJECT_ID"

# バックエンドのビルド
echo "🔨 Building backend..."
cd apps/backend
npx nx build backend --configuration=production

# Dockerイメージのビルド
echo "🐳 Building Docker image..."
docker build -t "$IMAGE_NAME:latest" .

# イメージのプッシュ
echo "📤 Pushing Docker image to GCR..."
docker push "$IMAGE_NAME:latest"

# Cloud Runへのデプロイ
echo "🚀 Deploying to Cloud Run..."

if [ "$ENVIRONMENT" = "production" ]; then
    # 本番環境の設定
    gcloud run deploy "$SERVICE_NAME" \
        --image "$IMAGE_NAME:latest" \
        --region "$REGION" \
        --platform managed \
        --allow-unauthenticated \
        --memory 1Gi \
        --cpu 2 \
        --concurrency 100 \
        --timeout 300 \
        --min-instances 1 \
        --max-instances 20 \
        --set-env-vars "PORT=8080,RUST_LOG=info"
else
    # ステージング環境の設定
    gcloud run deploy "$SERVICE_NAME" \
        --image "$IMAGE_NAME:latest" \
        --region "$REGION" \
        --platform managed \
        --allow-unauthenticated \
        --memory 512Mi \
        --cpu 1 \
        --concurrency 80 \
        --timeout 300 \
        --min-instances 0 \
        --max-instances 10 \
        --set-env-vars "PORT=8080,RUST_LOG=info"
fi

# サービスURLの表示
SERVICE_URL=$(gcloud run services describe "$SERVICE_NAME" --region "$REGION" --format="value(status.url)")
echo "✅ Deployment completed successfully!"
echo "🌐 Service URL: $SERVICE_URL"

# ヘルスチェック
echo "🔍 Performing health check..."
sleep 10
if curl -f "$SERVICE_URL/" > /dev/null 2>&1; then
    echo "✅ Health check passed!"
else
    echo "⚠️  Health check failed. Service might still be starting up."
fi

cd ../..
