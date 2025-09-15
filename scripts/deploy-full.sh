#!/bin/bash

# フルスタックアプリケーションをデプロイするスクリプト

set -e

# 環境変数の設定
ENVIRONMENT=${1:-staging}
PROJECT_ID=${GCP_PROJECT_ID:-$(gcloud config get-value project 2>/dev/null || echo "")}
REGION=${GCP_REGION:-asia-northeast1}
SERVICE_NAME="backend"

echo "🚀 Deploying full-stack application..."
echo "Environment: $ENVIRONMENT"
echo "Project ID: $PROJECT_ID"
echo "Region: $REGION"

# プロジェクトの確認
if [ -z "$PROJECT_ID" ]; then
    echo "❌ GCP_PROJECT_ID environment variable is not set and gcloud project is not configured"
    echo "Please set GCP_PROJECT_ID or run: gcloud config set project YOUR_PROJECT_ID"
    exit 1
fi

# 1. バックエンドをデプロイ
echo "🔧 Step 1: Deploying backend..."
./scripts/deploy-backend.sh "$ENVIRONMENT"

# 2. バックエンドのURLを取得
echo "🔍 Step 2: Getting backend URL..."
BACKEND_URL=$(gcloud run services describe "$SERVICE_NAME" --region "$REGION" --format="value(status.url)")
echo "Backend URL: $BACKEND_URL"

# 3. フロントエンドの環境変数ファイルを更新
echo "📝 Step 3: Updating frontend environment..."
ENV_FILE="apps/frontend/src/assets/env.js"
cat > "$ENV_FILE" << EOF
// 環境変数ファイル
// このファイルはビルド時に動的に生成されます
window['env'] = {
  BACKEND_URL: '$BACKEND_URL'
};
EOF

echo "Updated $ENV_FILE with backend URL: $BACKEND_URL"

# 4. フロントエンドをビルド
echo "🔨 Step 4: Building frontend..."
npx nx build frontend --configuration=production

# 5. Firebase Hostingにデプロイ
echo "🌐 Step 5: Deploying to Firebase Hosting..."
firebase deploy --only hosting

echo "✅ Full-stack deployment completed successfully!"
echo "🌐 Frontend URL: https://${FIREBASE_PROJECT_ID}.web.app"
echo "🔧 Backend URL: $BACKEND_URL"
