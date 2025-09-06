# マルチステージビルドでRustアプリケーションをビルド
FROM --platform=linux/amd64 rust:1.89-slim-bookworm AS builder

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# ワークディレクトリを設定
WORKDIR /usr/src/app

# ワークスペースのCargo.tomlとCargo.lockをコピー
COPY Cargo.toml Cargo.lock ./

# バックエンドプロジェクトのCargo.tomlをコピー
COPY apps/backend/Cargo.toml ./apps/backend/Cargo.toml

# 依存関係を先にビルド（キャッシュ効率化）
RUN mkdir -p apps/backend/src && \
    echo "fn main() {}" > apps/backend/src/main.rs && \
    cargo build --release --bin backend && \
    rm -rf apps/backend/src

# ソースコードをコピー
COPY apps/backend/src ./apps/backend/src

# リリースビルドを実行（最適化フラグを追加）
RUN cargo build --release --bin backend --config 'profile.release.opt-level = "z"'

# 実行用イメージ
FROM --platform=linux/amd64 debian:bookworm-slim

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y \
    ca-certificates \
    libssl3 \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 非rootユーザーを作成
RUN groupadd -r appuser && useradd -r -g appuser appuser

# アプリケーションディレクトリを作成
WORKDIR /app

# ビルドされたバイナリをコピー
COPY --from=builder /usr/src/app/target/release/backend /app/backend

# バイナリに実行権限を付与
RUN chmod +x /app/backend

# ユーザーを変更
USER appuser

# ポートを公開
EXPOSE 8080

# ヘルスチェックを有効化
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

# シンプルな起動コマンド
CMD ["/app/backend"]
