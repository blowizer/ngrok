#!/bin/bash
echo "=== 客户端连接问题诊断 ==="

SERVER="ngrok.qiaopan.tech"
PORT="4443"

echo "1. 测试DNS解析..."
nslookup $SERVER
ping -c 2 $SERVER

echo ""
echo "2. 测试网络连通性..."
telnet $SERVER $PORT

echo ""
echo "3. 测试端口连通性..."
nc -zv $SERVER $PORT

echo ""
echo "4. 检查本地证书..."
ls -la ./rootCA.pem
openssl x509 -in ./rootCA.pem -noout -subject

echo ""
echo "5. 测试不带TLS的TCP连接..."
timeout 3 bash -c "echo 'test' | nc $SERVER $PORT" && echo "✅ TCP连接成功" || echo "❌ TCP连接失败"

echo ""
echo "6. 检查路由跟踪..."
traceroute $SERVER 2>/dev/null || tracepath $SERVER 2>/dev/null || echo "路由跟踪工具不可用"

echo ""
echo "📋 诊断完成"