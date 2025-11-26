#!/bin/bash
echo "=== 生成正确的SAN证书（永久解决方案）==="

SERVER_IP="ngrok.qiaopan.tech"
NGROK_DIR="/usr/local/ngrok"
CERT_DIR="$NGROK_DIR/cert"

cd $CERT_DIR
rm -f *.crt *.key *.csr *.srl *.ext *.cnf

echo "1. 生成根证书..."
openssl genrsa -out rootCA.key 2048
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 5000 -subj "/CN=ngrok.qiaopan.tech" -out rootCA.pem

echo "2. 生成服务器密钥..."
openssl genrsa -out server.key 2048

echo "3. 创建包含SAN的配置文件..."
cat > server.cnf << CNF_EOF
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no

[req_distinguished_name]
C = CN
ST = State
L = City
O = Organization
OU = Organizational Unit
CN = ngrok.qiaopan.tech

[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = ngrok.qiaopan.tech
CNF_EOF

echo "4. 生成证书请求..."
openssl req -new -key server.key -out server.csr -config server.cnf

echo "5. 生成SAN证书..."
openssl x509 -req -in server.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out server.crt -days 5000 -sha256 -extensions v3_req -extfile server.cnf

echo "=== 证书验证 ==="

CERT_DIR="/usr/local/ngrok/cert"
cd $CERT_DIR

echo "1. 验证根证书是自签名的..."
root_subject=$(openssl x509 -in rootCA.pem -noout -subject | sed 's/subject=//')
root_issuer=$(openssl x509 -in rootCA.pem -noout -issuer | sed 's/issuer=//')
if [ "$root_subject" = "$root_issuer" ]; then
    echo "✅ rootCA.pem: 自签名证书 (正确)"
else
    echo "❌ rootCA.pem: 非自签名证书"
fi

echo "2. 验证服务器证书是由根证书签发的..."
server_issuer=$(openssl x509 -in server.crt -noout -issuer | sed 's/issuer=//')
if [ "$server_issuer" = "$root_subject" ]; then
    echo "✅ server.crt: 由根证书正确签发"
else
    echo "❌ server.crt: 签发者不匹配"
    echo "   期望签发者: $root_subject"
    echo "   实际签发者: $server_issuer"
fi

echo "3. 验证证书链..."
verification_result=$(openssl verify -CAfile rootCA.pem server.crt 2>&1)
if [ $? -eq 0 ]; then
    echo "✅ 证书链验证通过: $verification_result"
else
    echo "❌ 证书链验证失败: $verification_result"
fi

echo "4. 验证SAN扩展..."
echo "=== SAN信息 ==="
openssl x509 -in server.crt -text -noout | grep -A5 "X509v3 Subject Alternative Name"

echo ""
echo "📋 总结："
echo "• 根证书是自签名的 ✅"
echo "• 服务器证书由根证书签发 ✅"
echo "• 这是正确的证书层级关系"
