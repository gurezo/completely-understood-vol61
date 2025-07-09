# Firebase デプロイ手順

## 概要

このプロジェクトは Firebase Functions と Rust Backend の連携構成です。

## デプロイ手順

### 1. Rust Backend のデプロイ

Rust Backend は以下のいずれかの方法でデプロイしてください：

#### オプション A: Cloud Run にデプロイ

```bash
# リリースビルド
cargo build --release

# Dockerfile を作成して Cloud Run にデプロイ
# または、バイナリを直接 Cloud Run にデプロイ
```

#### オプション B: Compute Engine にデプロイ

```bash
# リリースビルド
cargo build --release

# target/release/backend を Compute Engine にアップロード
```

### 2. Firebase Functions のデプロイ

#### 環境変数の設定

```bash
# 本番環境の Rust Backend URL を設定
export RUST_BACKEND_URL=https://your-rust-backend-url.com
```

#### デプロイ実行

```bash
cd functions
npm run deploy:prod
```

### 3. ローカル開発環境

#### Rust Backend の起動

```bash
# 開発用
cargo run

# リリースバイナリ
./target/release/backend
```

#### Firebase Functions の起動

```bash
cd functions
firebase emulators:start --only functions
```

## 環境変数

| 変数名           | 説明                | デフォルト値          |
| ---------------- | ------------------- | --------------------- |
| RUST_BACKEND_URL | Rust Backend の URL | http://127.0.0.1:8080 |

## 注意事項

1. Rust Backend は `0.0.0.0:8080` でバインドする必要があります
2. 本番環境では適切な CORS 設定を行ってください
3. セキュリティ設定（認証・認可）を適切に設定してください
