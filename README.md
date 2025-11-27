
## 场景使用
  实现ngrok公网转发访问。

## 服务器server环境准备
### 服务器server的ubuntu环境
```bash
apt-get -y install zlib-devel openssl-devel perl hg cpio expat-devel gettext-devel curl curl-devel perl-ExtUtils-MakeMaker hg wget gcc gcc-c++ git
```
### 服务器server的go语言环境
go使用版本，可以用go verison查看，是 go version go1.16.3 linux/amd64
下载方式可以使用
```bash
// 删除 关于golang的依赖包
rpm -qa|grep golang|xargs rpm -e
// 下载安装包
tar -C /usr/local -xzf go1.8.3.linux-amd64.tar.gz
vim /etc/profile
//末尾添加''' '''里面的内容：
'''
#go lang
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin
'''
source /etc/profile
//检测是否安装成功go
go version
```
### 端口的准备
```bash
vim /etc/sysconfig/iptables
// 添加''' '''里面的内容
'''
-A INPUT -m state --state NEW -m tcp -p tcp --dport 50123 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 4443 -j ACCEPT
'''
/etc/init.d/iptables reload
/etc/init.d/iptables restart
// 可用下面的命令来查看开放的端口
iptables -nL
```

### 一键安装服务端
```

# 在服务端执行
./deploy-ngrok-full.sh
# 或者分步骤执行

echo "步骤1: 生成证书..."
sudo chmod +x /usr/local/bin/setup-ngrok-cert.sh
sudo /usr/local/bin/setup-ngrok-cert.sh

echo "步骤2: 同步证书Ngrok..."
sudo chmod +x /usr/local/bin/sync-ngrok-certs.sh  
sudo /usr/local/bin/sync-ngrok-certs.sh 

echo "步骤3: 编译Ngrok..."
sudo chmod +x /usr/local/bin/build-ngrok.sh  
sudo /usr/local/bin/build-ngrok.sh

echo "步骤4: 配置系统服务..."
sudo chmod +x /usr/local/bin/setup-ngrok-service.sh
sudo /usr/local/bin/setup-ngrok-service.sh

echo "步骤5: 配置客户端..."

sudo chmod +x /usr/local/bin/setup-ngrok-client.sh
/usr/local/bin/setup-ngrok-client.sh

```


