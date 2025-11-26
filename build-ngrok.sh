#!/bin/bash
echo "=== Ngrok编译脚本 ==="

NGROK_DIR="/usr/local/ngrok"

cd $NGROK_DIR

echo "1. 编译Linux服务端 (ngrokd)..."
GOOS=linux GOARCH=amd64 make release-server

echo "2. 编译Windows客户端..."
GOOS=windows GOARCH=amd64 make release-client

echo "3. 编译Linux客户端..."
GOOS=linux GOARCH=amd64 make release-client

echo "3. 编译Linux客户端..."
GOOS=darwin GOARCH=amd64 make release-client
echo "✅ 所有版本编译完成！"
echo "生成的文件在: $NGROK_DIR/bin/"
