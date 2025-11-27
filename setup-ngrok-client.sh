#!/bin/bash
echo "=== Ngrok客户端配置脚本 ==="
识别是 mac还是 linux，如果是 mac，则 HOME_DIR 为 /Users/$(whoami)，否则为 /home/$(whoami)
if [ "$(uname)" == "Darwin" ]; then
    HOME_DIR="/Users/$(whoami)"
else
    HOME_DIR="/home/$(whoami)"
fi

CLIENT_DIR="$HOME_DIR/ngrok-client"
mkdir -p $CLIENT_DIR
cd $CLIENT_DIR

# 创建客户端配置文件
tee ngrok.cfg > /dev/null << CONFIG_EOF
server_addr: "ngrok.qiaopan.tech:4443"
trust_host_root_certs: false
tunnels:
  ssh:
    proto:
      tcp: 22
    remote_port: 2222
CONFIG_EOF

echo "1. 客户端配置文件已创建: $CLIENT_DIR/ngrok.cfg"

# 创建客户端启动脚本
tee start-ngrok-client.sh > /dev/null << 'START_EOF'
#!/bin/bash
nohup ./ngrok -config=ngrok.cfg start ssh > ngrok-client.log 2>&1 &
echo "Ngrok客户端已启动，日志文件: ngrok-client.log"
echo "查看日志: tail -f ngrok-client.log"
START_EOF

chmod +x start-ngrok-client.sh

echo "2. 客户端启动脚本已创建: $CLIENT_DIR/start-ngrok-client.sh"
echo ""
echo "📝 使用说明:"
echo "1. 将 /usr/local/ngrok/bin/linux_amd64/ngrok 复制到此目录" 
echo "cd /Users/wugj/ngrok-client && scp root@qiaopan.tech:/usr/local/ngrok/bin/darwin_amd64/ngrok ."
echo "2. 运行: ./start-ngrok-client.sh"
echo "3. 查看日志: tail -f ngrok-client.log"
