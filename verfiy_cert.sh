openssl x509 -in /usr/local/ngrok/cert/server.crt -noout -subject -issuer | \
awk '{if ($0 ~ /subject=.*issuer=.*/ && index($0, "subject") < index($0, "issuer")) {gsub("subject=", ""); gsub("issuer=", ""); if ($1 == $2) print "✅ 自签名证书"} else print "❌ 非自签名或格式异常"}'
echo "=== 测试TLS连接 ==="

# 测试服务端TLS
echo "1. 测试服务端TLS握手:"
timeout 5 openssl s_client -connect localhost:4443 -CAfile /usr/local/ngrok/assets/client/tls/ngrokroot.crt -servername ngrok.qiaopan.tech < /dev/null

echo ""
echo "2. 检查服务端日志:"
sudo journalctl -u ngrokd -n 10 --no-pager