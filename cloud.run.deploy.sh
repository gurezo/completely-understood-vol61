# パラメータ設定
PROJECT_ID=your-project-id
REGION=asia-northeast1
SERVICE_NAME=backend

# Docker ビルド & Cloud Run にデプロイ
gcloud builds submit --tag gcr.io/${PROJECT_ID}/${SERVICE_NAME} apps/backend

gcloud run deploy ${SERVICE_NAME} \
  --image gcr.io/${PROJECT_ID}/${SERVICE_NAME} \
  --platform=managed \
  --region=${REGION} \
  --allow-unauthenticated \
  --port=8080
