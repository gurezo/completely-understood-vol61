# --- Build stage (Rust 1.89) ---
FROM rust:1.89 as builder
WORKDIR /usr/src/app

# 依存解決のキャッシュを効かせるためのダミー構成
COPY Cargo.toml Cargo.lock ./
# ワークスペースを使っている場合、メンバーの Cargo.toml もコピー
COPY apps/backend/Cargo.toml apps/backend/Cargo.toml
RUN mkdir -p apps/backend/src && echo "fn main(){}" > apps/backend/src/main.rs
# クレート名（package 名）に合わせる：ここでは `backend` を想定
RUN cargo build --release -p backend

# 本物のソースを投入して本ビルド
RUN rm -rf apps/backend/src
COPY apps/backend/ apps/backend/
RUN cargo build --release -p backend

# --- Runtime stage ---
FROM gcr.io/distroless/cc-debian12
WORKDIR /app
# 出力バイナリ名は Cargo.toml の package.name に合わせる
COPY --from=builder /usr/src/app/target/release/backend /app/backend
ENV PORT=8080
EXPOSE 8080
CMD ["/app/backend"]
