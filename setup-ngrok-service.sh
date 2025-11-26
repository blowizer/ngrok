#!/bin/bash
echo "=== Ngrok系统服务配置脚本 ==="

NGROK_DIR="/usr/local/ngrok"
CERT_DIR="$NGROK_DIR/cert"
SERVER_IP="ngrok.qiaopan.tech"

echo "3. 启动Ngrok服务..."
sudo systemctl stop ngrokd
# 创建systemd服务文件
sudo tee /etc/systemd/system/ngrokd.service > /dev/null << SERVICE_EOF
[Unit]
Description=Ngrok Server
After=network.target

[Service]
Type=simple
User=root
ExecStart=$NGROK_DIR/bin/ngrokd \\
  -domain=$SERVER_IP \\
  -tlsKey=$CERT_DIR/server.key \\
  -tlsCrt=$CERT_DIR/server.crt \\
  -tunnelAddr=:4443 \\
  -httpAddr=:8080 \\
  -httpsAddr=:8081
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
SERVICE_EOF

echo "1. 重新加载systemd..."
sudo systemctl daemon-reload

echo "2. 启用Ngrok服务..."
sudo systemctl enable ngrokd

echo "3. 启动Ngrok服务..."
sudo systemctl start ngrokd

echo "4. 检查服务状态..."
sudo systemctl status ngrokd

echo "✅ 系统服务配置完成！"
echo "常用命令:"
echo "  sudo systemctl status ngrokd    # 查看状态"
echo "  sudo systemctl restart ngrokd   # 重启服务"
echo "  sudo systemctl stop ngrokd      # 停止服务"
