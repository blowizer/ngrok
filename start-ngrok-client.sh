#!/bin/bash
GODEBUG=x509ignoreCN=0
nohup ./ngrok -config=ngrok.cfg -log-level=debug -log=ngrok-client.log start ssh   2>&1 &
echo "Ngrok客户端已启动，日志文件: ngrok-client.log"
echo "查看日志: tail -f ngrok-client.log"