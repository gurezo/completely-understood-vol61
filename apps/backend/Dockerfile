FROM rust:1.87 as builder

WORKDIR /usr/src/app
COPY . .

RUN cargo build --release

FROM debian:buster-slim
WORKDIR /app
COPY --from=builder /usr/src/app/target/release/backend /app/backend
RUN apt-get update && apt-get install -y ca-certificates && apt-get clean

EXPOSE 8080
CMD ["./backend"]
