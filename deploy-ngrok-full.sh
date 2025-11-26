#!/bin/bash
echo "=== Ngrok一键部署脚本 ==="

echo "步骤1: 生成证书..."
sudo chmod +x /usr/local/bin/setup-ngrok-cert.sh
sudo /usr/local/bin/setup-ngrok-cert.sh

echo "步骤2: 编译Ngrok..."
sudo chmod +x /usr/local/bin/build-ngrok.sh  
sudo /usr/local/bin/build-ngrok.sh

echo "步骤3: 配置系统服务..."
sudo chmod +x /usr/local/bin/setup-ngrok-service.sh
sudo /usr/local/bin/setup-ngrok-service.sh

echo "步骤4: 配置客户端..."
sudo chmod +x /usr/local/bin/setup-ngrok-client.sh
/usr/local/bin/setup-ngrok-client.sh

echo ""
echo "🎉 Ngrok部署完成！"
echo ""
echo "📋 后续操作:"
echo "1. 阿里云安全组开放端口: 4443, 2222"
echo "2. 将客户端文件复制到家中虚拟机:"
echo "   scp /usr/local/ngrok/bin/linux_amd64/ngrok 用户名@家中IP:~/ngrok-client/"
echo "3. 在家中虚拟机运行: cd ngrok-client && ./start-ngrok-client.sh"
echo "4. 测试SSH连接: ssh -p 2222 用户名@ngrok.qiaopan.tech"
