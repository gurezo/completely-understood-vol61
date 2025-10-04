#!/bin/bash

# バックエンドをCloud Runにデプロイするスクリプト

set -e

# 環境変数の設定
ENVIRONMENT=${1:-staging}
PROJECT_ID=${GCP_PROJECT_ID:-$(gcloud config get-value project 2>/dev/null || echo "")}
REGION=${GCP_REGION:-asia-northeast1}
SERVICE_NAME="backend"
IMAGE_NAME="${REGION}-docker.pkg.dev/${PROJECT_ID}/backend/backend"

echo "🚀 Deploying backend to Cloud Run..."
echo "Environment: $ENVIRONMENT"
echo "Project ID: $PROJECT_ID"
echo "Region: $REGION"
echo "Service: $SERVICE_NAME"
echo "Image Name: $IMAGE_NAME"

# プロジェクトの確認
if [ -z "$PROJECT_ID" ]; then
    echo "❌ GCP_PROJECT_ID environment variable is not set and gcloud project is not configured"
    echo "Please set GCP_PROJECT_ID or run: gcloud config set project YOUR_PROJECT_ID"
    exit 1
fi

# プロジェクトIDの形式を検証
if [[ ! "$PROJECT_ID" =~ ^[a-z0-9-]+$ ]]; then
    echo "❌ Invalid project ID format: $PROJECT_ID"
    echo "Project ID must contain only lowercase letters, numbers, and hyphens"
    exit 1
fi

# プロジェクトの存在確認
echo "🔍 Verifying project exists..."
if ! gcloud projects describe "$PROJECT_ID" &>/dev/null; then
    echo "❌ Project $PROJECT_ID does not exist or you don't have access to it"
    echo "Available projects:"
    gcloud projects list --format="table(projectId,name)"
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

# Artifact Registryリポジトリの作成（存在しない場合）
echo "🔍 Checking Artifact Registry repository..."
if ! gcloud artifacts repositories describe backend-repo --location="$REGION" &>/dev/null; then
    echo "📦 Creating Artifact Registry repository..."
    gcloud artifacts repositories create backend-repo \
        --repository-format=docker \
        --location="$REGION" \
        --description="Backend Docker repository"
else
    echo "✅ Artifact Registry repository already exists"
fi

# バックエンドのビルド
echo "🔨 Building backend..."
npx nx build backend --configuration=production

# Dockerイメージのビルド（ルートディレクトリのDockerfileを使用）
echo "🐳 Building Docker image for linux/amd64 platform..."
docker build --platform linux/amd64 -t "$IMAGE_NAME:latest" .

# Docker認証の設定
echo "🔐 Configuring Docker authentication for Artifact Registry..."
gcloud auth configure-docker ${REGION}-docker.pkg.dev --quiet

# イメージのプッシュ
echo "📤 Pushing Docker image to Artifact Registry..."
docker push "$IMAGE_NAME:latest"

# 環境変数ファイルのパスを設定
ENV_FILE="$(pwd)/cors-env.yaml"

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
        --port 8080 \
        --env-vars-file "$ENV_FILE"
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
        --port 8080 \
        --env-vars-file "$ENV_FILE"
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
