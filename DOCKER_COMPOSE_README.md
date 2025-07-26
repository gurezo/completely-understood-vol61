# Docker Compose でのバックエンド実行

このプロジェクトでは、バックエンドを Docker Compose を使用して簡単に実行できます。

## 前提条件

- Docker Desktop がインストールされていること
- Docker Compose V2 が利用可能であること

## 使用方法

### 1. バックエンドの起動

```bash
# バックグラウンドで起動
docker compose up -d

# ログを表示しながら起動
docker compose up

# イメージを再ビルドして起動
docker compose up --build -d
```

### 2. バックエンドの停止

```bash
# コンテナを停止
docker compose down

# コンテナとイメージを削除
docker compose down --rmi all
```

### 3. 状態確認

```bash
# コンテナの状態確認
docker compose ps

# ログの確認
docker compose logs backend

# リアルタイムでログを表示
docker compose logs -f backend
```

### 4. API テスト

バックエンドが起動したら、以下のコマンドで API をテストできます：

```bash
# 数値を2倍にするAPI
curl -X POST http://localhost:8080/api/double \
  -H "Content-Type: application/json" \
  -d '{"value": 5}'

# 期待されるレスポンス
# {"result":10}
```

## 設定

### ポート

- バックエンド: `localhost:8080`

### 環境変数

- `RUST_LOG`: ログレベル（デフォルト: `info`）

### ヘルスチェック

バックエンドにはヘルスチェックが設定されており、30 秒ごとに API エンドポイントを確認します。

## トラブルシューティング

### ポートが既に使用されている場合

```bash
# 使用中のポートを確認
lsof -i :8080

# 既存のコンテナを停止
docker compose down
```

### ビルドエラーが発生した場合

```bash
# キャッシュをクリアして再ビルド
docker compose build --no-cache
docker compose up -d
```

### ログが表示されない場合

```bash
# コンテナの詳細情報を確認
docker compose ps
docker compose logs backend

# コンテナ内に入って確認
docker compose exec backend sh
```
