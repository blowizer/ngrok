#!/bin/bash
echo "=== 同步Ngrok证书 ==="

NGROK_DIR="/usr/local/ngrok"
CERT_DIR="$NGROK_DIR/cert"

echo "1. 比较证书MD5..."
echo "原始服务器证书:"
md5sum $CERT_DIR/server.crt
echo "部署的服务器证书:"
md5sum $NGROK_DIR/assets/server/tls/snakeoil.crt

echo ""
echo "原始根证书:"
md5sum $CERT_DIR/rootCA.pem
echo "部署的根证书:"
md5sum $NGROK_DIR/assets/client/tls/ngrokroot.crt

echo ""
echo "2. 同步证书..."
cp $CERT_DIR/server.crt $NGROK_DIR/assets/server/tls/snakeoil.crt
cp $CERT_DIR/server.key $NGROK_DIR/assets/server/tls/snakeoil.key
cp $CERT_DIR/rootCA.pem $NGROK_DIR/assets/client/tls/ngrokroot.crt

echo ""
echo "3. 验证同步后的证书链..."
openssl verify -CAfile $NGROK_DIR/assets/client/tls/ngrokroot.crt $NGROK_DIR/assets/server/tls/snakeoil.crt && echo "✅ 证书链验证成功" || echo "❌ 证书链验证失败"
# 测试服务端TLS
echo "4. 测试服务端TLS握手:"
timeout 5 openssl s_client -connect localhost:4443 -CAfile $NGROK_DIR/assets/client/tls/ngrokroot.crt -servername ngrok.qiaopan.tech < /dev/null

echo ""
echo "5. 重启服务..."
sudo systemctl restart ngrokd

echo "✅ 证书同步完成"
