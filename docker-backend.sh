#!/bin/bash

# Backend Docker 管理スクリプト
# 使用方法: ./docker-backend.sh [build|start|stop|restart|logs|status|clean|help]

IMAGE_NAME="backend-app"
CONTAINER_NAME="backend-container"
PORT="8080"

# 色付きの出力用
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ヘルプ表示
show_help() {
    echo -e "${BLUE}Backend Docker 管理スクリプト${NC}"
    echo ""
    echo "使用方法: $0 [コマンド]"
    echo ""
    echo "コマンド:"
    echo "  build     - Dockerイメージをビルド"
    echo "  start     - コンテナを起動"
    echo "  stop      - コンテナを停止"
    echo "  restart   - コンテナを再起動"
    echo "  logs      - コンテナのログを表示"
    echo "  status    - コンテナの状態を表示"
    echo "  clean     - コンテナとイメージを削除"
    echo "  help      - このヘルプを表示"
    echo ""
    echo "例:"
    echo "  $0 build    # イメージをビルド"
    echo "  $0 start    # コンテナを起動"
    echo "  $0 stop     # コンテナを停止"
}

# イメージビルド
build_image() {
    echo -e "${BLUE}🔨 Dockerイメージをビルド中...${NC}"

    if docker build -t $IMAGE_NAME -f apps/backend/Dockerfile .; then
        echo -e "${GREEN}✅ イメージのビルドが完了しました: $IMAGE_NAME${NC}"
    else
        echo -e "${RED}❌ イメージのビルドに失敗しました${NC}"
        exit 1
    fi
}

# コンテナ起動
start_container() {
    echo -e "${BLUE}🚀 コンテナを起動中...${NC}"

    # 既存のコンテナが起動しているかチェック
    if docker ps -q -f name=$CONTAINER_NAME | grep -q .; then
        echo -e "${YELLOW}⚠️  コンテナは既に起動しています${NC}"
        return
    fi

    # 既存のコンテナが停止しているかチェック
    if docker ps -aq -f name=$CONTAINER_NAME | grep -q .; then
        echo -e "${YELLOW}🗑️  古いコンテナを削除中...${NC}"
        docker rm $CONTAINER_NAME
    fi

    # コンテナを起動
    if docker run -d --name $CONTAINER_NAME -p $PORT:$PORT $IMAGE_NAME; then
        echo -e "${GREEN}✅ コンテナが起動しました: $CONTAINER_NAME${NC}"
        echo -e "${GREEN}🌐 アクセスURL: http://localhost:$PORT${NC}"
        echo -e "${BLUE}📋 ログを確認: $0 logs${NC}"
    else
        echo -e "${RED}❌ コンテナの起動に失敗しました${NC}"
        exit 1
    fi
}

# コンテナ停止
stop_container() {
    echo -e "${BLUE}🛑 コンテナを停止中...${NC}"

    if docker stop $CONTAINER_NAME 2>/dev/null; then
        echo -e "${GREEN}✅ コンテナを停止しました: $CONTAINER_NAME${NC}"
    else
        echo -e "${YELLOW}⚠️  コンテナは既に停止しているか存在しません${NC}"
    fi
}

# コンテナ再起動
restart_container() {
    echo -e "${BLUE}🔄 コンテナを再起動中...${NC}"
    stop_container
    sleep 2
    start_container
}

# ログ表示
show_logs() {
    echo -e "${BLUE}📋 コンテナのログを表示中...${NC}"

    if docker ps -q -f name=$CONTAINER_NAME | grep -q .; then
        docker logs -f $CONTAINER_NAME
    else
        echo -e "${YELLOW}⚠️  コンテナが起動していません${NC}"
        echo -e "${BLUE}💡 コンテナを起動: $0 start${NC}"
    fi
}

# ステータス表示
show_status() {
    echo -e "${BLUE}📊 コンテナの状態を確認中...${NC}"
    echo ""

    # イメージの状態
    echo -e "${BLUE}🐳 イメージ:${NC}"
    if docker images $IMAGE_NAME | grep -q $IMAGE_NAME; then
        docker images $IMAGE_NAME
    else
        echo -e "${YELLOW}⚠️  イメージが存在しません: $IMAGE_NAME${NC}"
    fi

    echo ""

    # コンテナの状態
    echo -e "${BLUE}📦 コンテナ:${NC}"
    if docker ps -a | grep -q $CONTAINER_NAME; then
        docker ps -a | grep $CONTAINER_NAME
    else
        echo -e "${YELLOW}⚠️  コンテナが存在しません: $CONTAINER_NAME${NC}"
    fi

    echo ""

    # ポート使用状況
    echo -e "${BLUE}🌐 ポート $PORT の使用状況:${NC}"
    if lsof -i :$PORT >/dev/null 2>&1; then
        lsof -i :$PORT
    else
        echo -e "${YELLOW}⚠️  ポート $PORT は使用されていません${NC}"
    fi
}

# クリーンアップ
cleanup() {
    echo -e "${BLUE}🧹 クリーンアップ中...${NC}"

    # コンテナを停止・削除
    if docker ps -aq -f name=$CONTAINER_NAME | grep -q .; then
        echo -e "${BLUE}🗑️  コンテナを削除中...${NC}"
        docker stop $CONTAINER_NAME 2>/dev/null
        docker rm $CONTAINER_NAME
    fi

    # イメージを削除
    if docker images $IMAGE_NAME | grep -q $IMAGE_NAME; then
        echo -e "${BLUE}🗑️  イメージを削除中...${NC}"
        docker rmi $IMAGE_NAME
    fi

    echo -e "${GREEN}✅ クリーンアップが完了しました${NC}"
}

# メイン処理
case "${1:-help}" in
    build)
        build_image
        ;;
    start)
        start_container
        ;;
    stop)
        stop_container
        ;;
    restart)
        restart_container
        ;;
    logs)
        show_logs
        ;;
    status)
        show_status
        ;;
    clean)
        cleanup
        ;;
    help|*)
        show_help
        ;;
esac
