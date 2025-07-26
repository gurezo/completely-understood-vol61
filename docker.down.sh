# 1. まずコンテナを停止
docker compose down

# 2. 未使用のイメージを削除
docker image prune -a -f

# 3. システム全体をクリーンアップ
docker system prune -a --volumes -f
